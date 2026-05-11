import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calcwise_core/calcwise_core.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../core/data/mock_data_quebec.dart';
import '../core/data/mock_data_levis.dart';
import '../core/data/mock_data_montreal.dart';
import '../core/data/city_registry.dart';
import '../core/data/zone_registry.dart';
import '../core/models/city.dart';
import '../core/models/street_segment.dart';
import '../core/models/bulk_street.dart';
import '../core/models/parking_rule.dart';
import '../core/services/amd_service.dart';
import '../core/services/alternating_service.dart';
import '../core/services/nettoyage_service.dart';
import '../core/services/overpass_service.dart';
import '../core/services/rule_engine.dart';
import '../core/services/session_service.dart';
import '../core/services/user_preferences_service.dart';
import '../core/theme/app_theme.dart';
import '../widgets/time_control_widget.dart';
import '../widgets/layer_filter_widget.dart';
import '../widgets/map_skeleton_loader.dart';
import '../widgets/segment_bottom_sheet.dart';
import '../widgets/session_alert_banner.dart';
import 'settings_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();

  DateTime? _viewTime;
  City _selectedCity = CityRegistry.defaultCity;
  StreetSegment? _selectedSegment;
  bool _bannerDismissed = false;

  Map<ParkingColor, bool> _filters = {
    ParkingColor.free:        true,
    ParkingColor.meter:       true,
    ParkingColor.restricted:  true,
    ParkingColor.noData:      true,
  };

  Timer? _refreshTimer;

  // Géométrie OSM indexée par way ID (clé stable, jamais de faux match)
  Map<int, List<List<double>>> _wayGeometry = {};
  bool _loadingGeometry = false;

  // Rues en masse (Overpass bulk) — couvrent ~80 % de la carte
  List<BulkStreet> _bulkStreets = [];
  bool _loadingBulkStreets = false;
  BulkStreet? _selectedBulkStreet; // rue en masse sélectionnée (tap)

  // Règles par rue (zone lookup pré-calculé) — Map<osmWayId, rules>.
  // Calculé une fois après le chargement des bulk streets.
  // Null = hors zone connue → règles par défaut de la ville.
  Map<int, List<ParkingRule>> _streetRules = {};

  // GPS position
  LatLng? _currentPosition;
  StreamSubscription<geo.Position>? _positionStream;

  // Flag : auto-sélection de ville au premier fix GPS (une seule fois)
  bool _gpsAutoSelected = false;

  // Zoom courant — initialisé à la valeur par défaut, mis à jour par _onMapEvent.
  // NE PAS utiliser _mapController.camera.zoom dans build() :
  // le contrôleur n'est pas encore attaché au premier frame → StateError.
  double _currentZoom = CityRegistry.defaultCity.defaultZoom;

  // Seuils d'apparition des polylines.
  // En dessous : rues invisibles à cette échelle → calcul inutile.
  static const _kZoomBulk = 12.0;  // bulk  : visible dès le zoom par défaut ville
  static const _kZoomMock = 11.0;  // mock  : apparaissent un cran avant (peu nombreux)

  // Pulsing animation for GPS dot
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  List<StreetSegment> get _allSegments => [
    ...quebecSegments,
    ...levisSegments,
    ...montrealSegments,
  ];
  DateTime get _effectiveTime => _viewTime ?? DateTime.now();

  @override
  void initState() {
    super.initState();

    // Refresh every 10s (faster for demo)
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (_viewTime == null && mounted) setState(() {});
    });

    // Pulse animation for GPS dot
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 8, end: 16).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _startPositionTracking();
    _loadWayGeometry();
    _loadBulkStreets();
    AmdService().load();         // chargement en parallèle, sans attendre
    AlternatingService().load(); // 529 rues alternées Montréal
    NettoyageService().load();   // calendrier nettoyage des rues

    _restoreUserPreferences();    // Restaurer préférences utilisateur (ville, filtres, etc.)
  }

  Future<void> _restoreUserPreferences() async {
    final prefs = UserPreferencesService();
    try {
      final savedCity = await prefs.getSelectedCity();
      final savedFilters = await prefs.getFilters();
      final savedViewTime = await prefs.getViewTime();

      if (mounted) {
        setState(() {
          _selectedCity = savedCity;
          _filters = savedFilters;
          _viewTime = savedViewTime;
        });
      }
    } catch (_) {
      // Erreur lecture prefs → utiliser défauts
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _positionStream?.cancel();
    _pulseCtrl.dispose();
    _mapController.dispose();
    super.dispose();
  }

  // ── GPS position tracking ────────────────────────────────────────────────
  Future<void> _startPositionTracking() async {
    try {
      geo.LocationPermission perm = await geo.Geolocator.checkPermission();
      if (perm == geo.LocationPermission.denied) {
        perm = await geo.Geolocator.requestPermission();
      }
      if (perm == geo.LocationPermission.deniedForever) return;

      // Get initial position quickly
      final pos = await geo.Geolocator.getCurrentPosition(
        locationSettings: const geo.LocationSettings(
          accuracy: geo.LocationAccuracy.high,
        ),
      );
      if (mounted) {
        setState(() => _currentPosition = LatLng(pos.latitude, pos.longitude));

        // Auto-sélectionner la ville la plus proche au premier fix GPS
        if (!_gpsAutoSelected) {
          _gpsAutoSelected = true;
          final nearest = CityRegistry.nearest(
            LatLng(pos.latitude, pos.longitude),
          );
          if (nearest.id != _selectedCity.id) {
            _switchCity(nearest);
          }
        }
      }

      // Then stream updates
      _positionStream = geo.Geolocator.getPositionStream(
        locationSettings: const geo.LocationSettings(
          accuracy: geo.LocationAccuracy.high,
          distanceFilter: 5,
        ),
      ).listen((p) {
        if (mounted) {
          setState(() => _currentPosition = LatLng(p.latitude, p.longitude));
        }
      });
    } catch (_) {}
  }

  // ── OSM way geometry ────────────────────────────────────────────────────

  /// Charge la géométrie pour tous les way IDs déclarés dans les segments.
  /// Utilise le cache SharedPreferences — réseau seulement pour les IDs manquants.
  Future<void> _loadWayGeometry() async {
    if (_loadingGeometry) return;

    // Collecter tous les IDs uniques déclarés dans les mock data
    final ids = <int>{};
    for (final seg in _allSegments) {
      ids.addAll(seg.osmWayIds);
    }
    if (ids.isEmpty) return;

    setState(() => _loadingGeometry = true);
    final geom = await OverpassService.fetchByIds(ids);
    if (mounted) {
      setState(() {
        _wayGeometry = geom;
        _loadingGeometry = false;
      });
    }
  }

  /// Charge en arrière-plan toutes les rues nommées de toutes les villes via Overpass.
  ///
  /// Itère [CityRegistry.supported] — ajouter une ville = automatiquement incluse.
  /// Cache SharedPreferences 30 jours — réseau seulement au 1er lancement.
  Future<void> _loadBulkStreets() async {
    if (_loadingBulkStreets) return;
    setState(() => _loadingBulkStreets = true);

    final results = await Future.wait(
      CityRegistry.supported.map((c) => OverpassService.fetchBulkStreets(c)),
    );

    if (mounted) {
      setState(() {
        _bulkStreets = results.expand((r) => r).toList();
        _loadingBulkStreets = false;
        _loadingGeometry = false;  // Finalize loading state
      });
      _computeStreetRules();
    }
  }

  /// Pré-calcule les règles de zone pour chaque rue bulk.
  ///
  /// Exécuté une seule fois après le chargement des bulk streets.
  /// Complexité : O(streets × zones) ≈ 15 000 × 10 = 150 000 ops (~5 ms).
  ///
  /// Résultat stocké dans [_streetRules] : Map<osmWayId, List<ParkingRule>>.
  /// Null = hors zone → règles par défaut de la ville.
  Future<void> _computeStreetRules() async {
    // Yield au thread UI avant de démarrer le calcul
    await Future.delayed(Duration.zero);

    final newRules = <int, List<ParkingRule>>{};
    final amd      = AmdService();
    final alt      = AlternatingService();
    final nett     = NettoyageService();
    int amdHits    = 0;
    int altHits    = 0;
    int nettHits   = 0;
    int zoneHits   = 0;

    for (final street in _bulkStreets) {
      if (street.coordinates.isEmpty) continue;
      final mid = street.coordinates[street.coordinates.length ~/ 2];

      // 1. Données AMD précises (Montréal — parcomètres GPS)
      if (street.city == 'montreal' && amd.isLoaded) {
        final amdRules = amd.rulesNear(mid[0], mid[1]);
        if (amdRules != null) {
          newRules[street.osmWayId] = amdRules;
          amdHits++;
          continue;
        }
      }

      // 2. Stationnement alterné (Montréal — rues résidentielles pair/impair)
      if (street.city == 'montreal' && alt.isLoaded) {
        final altSeg = alt.segmentNear(mid[0], mid[1]);
        if (altSeg != null) {
          newRules[street.osmWayId] = altSeg.rules;
          altHits++;
          continue;
        }
      }

      // 2b. Nettoyage des rues (Montréal — calendrier annuel)
      if (street.city == 'montreal' && nett.isLoaded) {
        final nettSeg = nett.segmentNear(mid[0], mid[1]);
        if (nettSeg != null) {
          newRules[street.osmWayId] = nettSeg.rules;
          nettHits++;
          continue;
        }
      }

      // 3. Zone de référence (SRRR, vignette, parcomètre zone, heures de pointe)
      // findAllZones() cumule TOUTES les zones matchantes sur la même rue
      // → permet ex. heure de pointe + SRRR Plateau sur une artère résidentielle
      final zoneRules = ZoneRegistry.findAllZones(street.city, mid[0], mid[1]);
      if (zoneRules.isNotEmpty) {
        newRules[street.osmWayId] = zoneRules;
        zoneHits++;
      }
    }

    if (mounted) {
      setState(() => _streetRules = newRules);
      debugPrint('RuleLookup: ${newRules.length} rues assignées '
          '($amdHits AMD · $altHits alternés · $nettHits nettoyage · '
          '$zoneHits zones · '
          '${_bulkStreets.length - newRules.length} défaut ville)');
    }
  }

  /// IDs OSM déjà couverts par les segments mock (vérifiés, règles précises).
  /// Calculé une fois — évite de dessiner deux lignes sur la même rue.
  late final Set<int> _mockedWayIds = _allSegments
      .expand((s) => s.osmWayIds)
      .toSet();

  /// Construit les polylines pour les rues en masse (couche de fond).
  ///
  /// ## Logique couleur par rue
  ///   Rue dans une zone connue → règles de la zone évaluées à [_effectiveTime]
  ///   Rue hors zone + ville avec règles complètes → règles par défaut de la ville
  ///   Rue hors zone + ville sans règles complètes → noData (gris, honnête)
  ///
  /// ## Exemples
  ///   Rue dans Centre-Ville MTL, Lun 10h → meter → bleu
  ///   Rue dans Centre-Ville MTL, Lun 22h → pas de rule active → vert (libre)
  ///   Rue dans Plateau MTL, Lun 10h      → permit → orange
  ///   Rue résidentielle MTL (hors zone)  → gris (données inconnues)
  ///   Rue résidentielle QC (hors zone)   → vert ou rouge selon heure/saison
  List<Polyline> _buildBulkPolylines() {
    if (_currentZoom < _kZoomBulk) return [];
    if (_bulkStreets.isEmpty) return [];

    final polylines = <Polyline>[];

    for (final street in _bulkStreets) {
      if (street.city != _selectedCity.id) continue;
      if (street.coordinates.length < 2) continue;
      if (_mockedWayIds.contains(street.osmWayId)) continue;

      // ── Déterminer les règles applicables à cette rue ─────────────────────
      final zoneRules = _streetRules[street.osmWayId];
      final List<ParkingRule> rules;
      final bool hasSpecificData;

      if (zoneRules != null) {
        rules           = zoneRules;           // zone connue → règles précises
        hasSpecificData = true;
      } else if (_selectedCity.hasComprehensiveDefaults) {
        rules           = _selectedCity.defaultRules; // QC/LV : règles city-wide valides
        hasSpecificData = true;
      } else {
        rules           = const [];            // MTL hors zone : inconnu
        hasSpecificData = false;
      }

      // ── Évaluer la couleur à l'heure courante ─────────────────────────────
      // Pas de données du tout (ville non couverte) → on skip.
      // Règles vides = ville couverte sans restriction connue → vert (libre).
      if (!hasSpecificData) continue;

      final ParkingColor displayColor;
      if (rules.isEmpty) {
        displayColor = ParkingColor.free; // libre par défaut
      } else {
        final result = RuleEngine.evaluateRules(rules, _effectiveTime);
        displayColor = result.color == ParkingColor.noData
            ? ParkingColor.free   // on n'affiche jamais gris
            : result.color;
      }

      if (!(_filters[displayColor] ?? true)) continue;

      final baseColor = switch (displayColor) {
        ParkingColor.free       => AppTheme.free,
        ParkingColor.meter      => AppTheme.meter,
        ParkingColor.restricted => AppTheme.restricted,
        ParkingColor.noData     => AppTheme.noData,
      };

      final isSel = _selectedBulkStreet?.osmWayId == street.osmWayId;
      final points = _toLatLng(street.coordinates);

      // Glow effect for selected bulk streets
      if (isSel) {
        polylines.add(Polyline(
          points: points,
          color: baseColor.withAlpha(50),
          strokeWidth: 12.0,
          strokeCap: StrokeCap.round,
          strokeJoin: StrokeJoin.round,
        ));
      }

      polylines.add(Polyline(
        points: points,
        color: baseColor.withAlpha(isSel ? 242 : 160),
        strokeWidth: isSel ? 6.0 : 3.5,
        strokeCap: StrokeCap.round,
        strokeJoin: StrokeJoin.round,
      ));
    }

    return polylines;
  }

  /// Retourne la géométrie pour un segment.
  ///
  /// Priorité :
  ///   1. Ways OSM fetchés (index par ID → exact, aucune ambiguïté de nom)
  ///   2. Coords embarquées dans le mock (fallback offline ou osmWayIds vide)
  ///
  /// Plusieurs way IDs = concaténation dans l'ordre.
  /// Les nœuds de jonction dupliqués sont dédupliqués automatiquement.
  List<List<double>> _geometryFor(StreetSegment seg) {
    if (seg.osmWayIds.isEmpty || _wayGeometry.isEmpty) {
      return seg.coordinates;
    }

    final result = <List<double>>[];
    for (final id in seg.osmWayIds) {
      final pts = _wayGeometry[id];
      if (pts == null || pts.length < 2) continue;

      if (result.isEmpty) {
        result.addAll(pts);
      } else {
        // Dédupliquer le nœud de jonction si les deux ways se touchent
        final gap = _dist2(result.last, pts.first);
        result.addAll(gap < 1e-10 ? pts.skip(1) : pts);
      }
    }

    return result.length >= 2 ? result : seg.coordinates;
  }

  // Distance euclidienne² entre deux points [lng, lat]
  double _dist2(List<double> a, List<double> b) {
    final dl = a[0] - b[0], dp = a[1] - b[1];
    return dl * dl + dp * dp;
  }

  /// Distance² du point [p] au segment [a→b] (en coordonnées lon/lat).
  ///
  /// Plus précis qu'une distance point-à-point pour les taps sur rue :
  /// évite de sélectionner la mauvaise rue à une intersection.
  double _distToSegment2(List<double> p, List<double> a, List<double> b) {
    final dx = b[0] - a[0];
    final dy = b[1] - a[1];
    final len2 = dx * dx + dy * dy;
    if (len2 == 0) return _dist2(p, a); // segment dégénéré = point
    // Projection de p sur la droite a→b, clampée à [0,1]
    final t = ((p[0] - a[0]) * dx + (p[1] - a[1]) * dy) / len2;
    final tc = t.clamp(0.0, 1.0);
    return _dist2(p, [a[0] + tc * dx, a[1] + tc * dy]);
  }

  /// Distance² minimale de [tap] à la polyligne [coords].
  double _distToPolyline2(List<double> tap, List<List<double>> coords) {
    double best = double.infinity;
    for (int i = 0; i < coords.length - 1; i++) {
      final d = _distToSegment2(tap, coords[i], coords[i + 1]);
      if (d < best) best = d;
    }
    return best;
  }

  /// Crée un [StreetSegment] synthétique à partir d'une [BulkStreet].
  ///
  /// Permet de réutiliser [SegmentBottomSheet] pour afficher les règles par
  /// défaut de la ville quand l'utilisateur tape sur une rue en masse.
  StreetSegment _syntheticSegmentFor(BulkStreet street) {
    final city = CityRegistry.findById(street.city) ?? CityRegistry.defaultCity;
    // Priorité : règles de zone pré-calculées > règles par défaut de la ville.
    // Sans ça, une rue bleue (parcomètre) afficherait les règles génériques
    // de la ville dans le bottom sheet au lieu des règles du parcomètre.
    final zoneRules = _streetRules[street.osmWayId];
    final effectiveRules = zoneRules ?? city.defaultRules;
    final hasZone = zoneRules != null;
    return StreetSegment(
      id: 'bulk-${street.osmWayId}',
      streetName: street.name,
      city: city.name,
      side: 'Tous côtés',
      osmWayIds: [street.osmWayId],
      coordinates: street.coordinates,
      rules: effectiveRules,
      confidence: hasZone ? 0.80 : 0.65,
      sourceDate: '2026-01-01',
      sources: [DataSource.official],
      notes: hasZone
          ? null
          : 'Règle municipale par défaut — ${city.name}. '
              'Des restrictions locales peuvent s\'appliquer.',
    );
  }

  List<LatLng> _toLatLng(List<List<double>> coords) =>
      coords.map((c) => LatLng(c[1], c[0])).toList();

  /// Rebuild les polylines uniquement à la fin d'un geste (pas chaque frame).
  /// Évite de recalculer des milliers de polylines pendant le pinch/scroll.
  void _onMapEvent(MapEvent event) {
    if (event is MapEventMoveEnd) {
      setState(() => _currentZoom = event.camera.zoom);
    }
  }

  void _onMapTap(TapPosition tapPos, LatLng point) {
    final tap = [point.longitude, point.latitude];
    // Seuil de sélection : ~15 m en degrés (~0.00014°)
    const kThreshMock  = 2e-8;  // 0.00014² — segments vérifiés, seuil serré
    const kThreshBulk  = 8e-8;  // 0.00028² — rues bulk, seuil plus large

    // ── 1. Segments mock : distance à la polyligne (pas au point) ────────
    StreetSegment? nearestSeg;
    double minSegDist = double.infinity;

    for (final seg in _allSegments) {
      final coords = _geometryFor(seg);
      if (coords.length < 2) continue;
      final d = _distToPolyline2(tap, coords);
      if (d < minSegDist) { minSegDist = d; nearestSeg = seg; }
    }

    if (nearestSeg != null && minSegDist < kThreshMock) {
      setState(() { _selectedSegment = nearestSeg; _selectedBulkStreet = null; });
      return;
    }

    // ── 2. Rues bulk : distance à la polyligne (ville courante) ──────────
    BulkStreet? nearestBulk;
    double minBulkDist = double.infinity;

    for (final street in _bulkStreets) {
      if (street.city != _selectedCity.id) continue;
      if (street.coordinates.length < 2) continue;
      final d = _distToPolyline2(tap, street.coordinates);
      if (d < minBulkDist) { minBulkDist = d; nearestBulk = street; }
    }

    // Aucun segment mock assez proche (kThreshMock) — on choisit entre bulk
    // et segment mock élargi (kThreshBulk), en prenant le plus proche.
    final segInBulkRange  = nearestSeg  != null && minSegDist  < kThreshBulk;
    final bulkInRange     = nearestBulk != null && minBulkDist < kThreshBulk;

    if (!segInBulkRange && !bulkInRange) {
      // Tap dans le vide → fermer
      setState(() { _selectedSegment = null; _selectedBulkStreet = null; });
      return;
    }

    // Prend l'élément le plus proche (segment mock prioritaire à égalité)
    final pickSeg = segInBulkRange &&
        (!bulkInRange || minSegDist <= minBulkDist);

    setState(() {
      _selectedSegment    = pickSeg ? nearestSeg  : null;
      _selectedBulkStreet = pickSeg ? null        : nearestBulk;
    });
  }

  Future<void> _goToLocation() async {
    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, 16);
      return;
    }
    try {
      final pos = await geo.Geolocator.getCurrentPosition();
      _mapController.move(LatLng(pos.latitude, pos.longitude), 16);
    } catch (_) {
      _snack('Position indisponible');
    }
  }

  void _switchCity(City city) {
    setState(() => _selectedCity = city);
    _mapController.move(city.center, city.defaultZoom);
    UserPreferencesService().setSelectedCity(city.id);
  }

  void _onTimeChanged(DateTime? t) {
    setState(() => _viewTime = t);
    UserPreferencesService().setViewTime(t);
  }

  void _onFiltersChanged(Map<ParkingColor, bool> f) {
    setState(() => _filters = f);
    UserPreferencesService().setFilters(f);
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  // ── Build polylines ──────────────────────────────────────────────────────
  List<Polyline> _buildPolylines() {
    if (_currentZoom < _kZoomMock) return [];
    // Masquer les segments mock tant que la géométrie OSM n'est pas chargée :
    // évite d'afficher les coords fallback approximatives au démarrage.
    if (_loadingGeometry) return [];
    final polylines = <Polyline>[];
    for (final seg in _allSegments) {
      // Afficher uniquement les segments appartenant à la ville sélectionnée.
      // effectiveSegmentCityNames couvre les municipalités groupées
      // (ex: ['Québec', 'Lévis'] quand la Capitale-Nationale est sélectionnée).
      if (!_selectedCity.effectiveSegmentCityNames.contains(seg.city)) continue;

      final coords = _geometryFor(seg);
      if (coords.length < 2) continue;
      final result = RuleEngine.evaluate(seg, _effectiveTime);
      if (!(_filters[result.color] ?? true)) continue;

      final isSelected = _selectedSegment?.id == seg.id;
      final points = _toLatLng(coords);

      // Glow effect for selected streets
      if (isSelected) {
        polylines.add(Polyline(
          points: points,
          color: result.colorValue.withAlpha(31),
          strokeWidth: 14.0,
          strokeCap: StrokeCap.round,
          strokeJoin: StrokeJoin.round,
        ));
      }

      polylines.add(Polyline(
        points: points,
        color: result.colorValue.withAlpha(isSelected ? 255 : 217),
        strokeWidth: isSelected ? 8.0 : 5.0,
        strokeCap: StrokeCap.round,
        strokeJoin: StrokeJoin.round,
      ));
    }
    return polylines;
  }

  // ── GPS dot widget ───────────────────────────────────────────────────────
  Widget _buildGpsDot() {
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, __) => Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: _pulseAnim.value,
            height: _pulseAnim.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withAlpha(64),
            ),
          ),
          Container(
            width: 10, height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(color: Colors.blue.withAlpha(128), blurRadius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── City switcher ────────────────────────────────────────────────────────
  Widget _buildCitySwitcher() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(
            color: Colors.black.withAlpha(31), blurRadius: 8,
            offset: const Offset(0, 2))],
      ),
      // Row simple (pas de ScrollView) : 2 boutons maximum → jamais d'overflow.
      // SingleChildScrollView(horizontal) dans un Row avec Spacer() cause une
      // assertion Flutter sur les contraintes non bornées en mode debug.
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: CityRegistry.supported.map((city) {
          final sel = _selectedCity.id == city.id;
          return Semantics(
            button: true,
            enabled: true,
            label: sel ? '${city.name} (sélectionné)' : city.name,
            child: GestureDetector(
              onTap: () => _switchCity(city),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: sel ? AppTheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(city.name,
                    style: TextStyle(
                      color: sel ? Colors.white : AppTheme.primary,
                      fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Legend ───────────────────────────────────────────────────────────────
  // Grille 2×2 pour ne pas déborder sur les petits écrans.
  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(
            color: Colors.black.withAlpha(31), blurRadius: 10,
            offset: const Offset(0, 2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            _LegendItem(color: AppTheme.free,       label: 'Libre'),
            const SizedBox(width: 16),
            _LegendItem(color: AppTheme.meter,      label: 'Parcom.'),
          ]),
          const SizedBox(height: 8),
          Row(mainAxisSize: MainAxisSize.min, children: [
            _LegendItem(color: AppTheme.restricted, label: 'Interdit'),
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session  = context.watch<SessionService>();
    final mq        = MediaQuery.of(context);
    final isDark    = Theme.of(context).brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    ));
    final top       = mq.padding.top;
    final navBar    = mq.padding.bottom;          // hauteur barre système Android
    final maxSheetH = mq.size.height * 0.60 - navBar;
    final textScale = mq.textScaleFactor;

    // FABs + time pill : au-dessus de la stats bar (≈80px) + barre système
    const statsBarH       = 76.0;
    final fabBottom       = navBar + statsBarH + 16;
    final timePillBottom  = navBar + statsBarH + 10;

    final sheetOpen = _selectedSegment != null || _selectedBulkStreet != null;

    return Scaffold(
      extendBody: true,        // map fills edge-to-edge; mq.padding.bottom = nav bar height
      body: Stack(
        children: [
          // ── SKELETON LOADER (while geometry loads) ────────────────────────
          if (_loadingGeometry)
            const MapSkeletonLoader()
          else
            const SizedBox.shrink(),

          // ── MAP — plein écran ─────────────────────────────────────────────
          if (!_loadingGeometry)
            FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: CityRegistry.defaultCity.center,
              initialZoom: CityRegistry.defaultCity.defaultZoom,
              onTap: _onMapTap,
              onMapEvent: _onMapEvent,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.parksmart.app',
                maxZoom: 19,
              ),
              PolylineLayer(polylines: _buildBulkPolylines()),
              PolylineLayer(polylines: _buildPolylines()),
              if (_currentPosition != null)
                MarkerLayer(markers: [
                  Marker(
                    point: _currentPosition!,
                    width: 24, height: 24,
                    child: _buildGpsDot(),
                  ),
                ]),
            ],
          )
          else
            const SizedBox.shrink(),

          // ── SESSION BANNER (repositioned higher to avoid FAB collision) ─
          if (session.hasActiveSession && !_bannerDismissed)
            Positioned(
              top: top + 70, left: 12, right: 12,
              child: SessionAlertBanner(
                session: session.activeSession!,
                onDismiss: () => setState(() => _bannerDismissed = true),
                onEnd: () => session.endSession(),
              ),
            ),

          // ── TOP OVERLAY ──────────────────────────────────────────────────
          Positioned(
            top: top + 8, left: 12, right: 12,
            child: CalcwisePageEntrance(child: Opacity(
              opacity: sheetOpen ? 0.7 : 1.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCitySwitcher(),
                  const Spacer(),
                  _buildLegend(),
                  const SizedBox(width: 6),
                  Builder(
                    builder: (ctx) {
                      final surfaceColor = Theme.of(ctx).colorScheme.surface;
                      final iconColor = Theme.of(ctx).colorScheme.onSurface.withOpacity(0.6);
                      return ValueListenableBuilder<ThemeMode>(
                        valueListenable: themeModeService.notifier,
                        builder: (_, __, ___) => Material(
                          color: surfaceColor,
                          shape: const CircleBorder(),
                          elevation: 2,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => themeModeService.toggle(),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Icon(themeModeService.icon, size: 20, color: iconColor),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 6),
                  Builder(
                    builder: (ctx) {
                      final surfaceColor = Theme.of(ctx).colorScheme.surface;
                      final iconColor = Theme.of(ctx).colorScheme.onSurface.withOpacity(0.6);
                      return Material(
                        color: surfaceColor,
                        shape: const CircleBorder(),
                        elevation: 2,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => Navigator.push(
                            ctx,
                            MaterialPageRoute(
                              builder: (_) => const SettingsScreen(),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(Icons.settings_outlined, size: 20, color: iconColor),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )),
          ),

          // ── RIGHT FABs ───────────────────────────────────────────────────
          if (!sheetOpen)
            Positioned(
              right: 12, bottom: fabBottom,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tooltip(
                    message: 'Aller à ma position',
                    child: Semantics(
                      button: true,
                      enabled: true,
                      label: 'Accéder à ma position actuelle',
                      child: _Fab(icon: Icons.gps_fixed, onTap: _goToLocation),
                    ),
                  ),
                  const SizedBox(height: 10),
                  LayerFilterWidget(
                    filters: _filters,
                    onFiltersChanged: _onFiltersChanged,
                  ),
                ],
              ),
            ),

          // ── TIME PILL (bottom-left, safe area aware) ────────────────────
          if (!sheetOpen)
            Positioned(
              bottom: navBar + statsBarH + 16,
              left: 12,
              child: TimeControlWidget(
                selectedTime: _viewTime,
                onTimeChanged: _onTimeChanged,
              ),
            ),

          // ── BOTTOM SHEET / STATS ─────────────────────────────────────────
          // bottom: navBar → le widget commence AU-DESSUS de la barre système.
          // Ni SafeArea ni padding.bottom interne nécessaires.
          Positioned(
            bottom: navBar, left: 0, right: 0,
            child: sheetOpen
                ? ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxSheetH),
                    child: _selectedSegment != null
                        ? SegmentBottomSheet(
                            segment: _selectedSegment!,
                            viewTime: _effectiveTime,
                            onClose: () =>
                                setState(() => _selectedSegment = null),
                          )
                        : SegmentBottomSheet(
                            segment:
                                _syntheticSegmentFor(_selectedBulkStreet!),
                            viewTime: _effectiveTime,
                            onClose: () =>
                                setState(() => _selectedBulkStreet = null),
                          ),
                  )
                : _StatsBar(
                    allSegments: _allSegments,
                    effectiveTime: _effectiveTime,
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Small circular FAB ────────────────────────────────────────────────────────
class _Fab extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _Fab({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(
              color: Colors.black.withAlpha(31),
              blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Icon(icon, color: AppTheme.primary, size: 22),
      ),
    );
  }
}

// ── Stats bar ─────────────────────────────────────────────────────────────────
class _StatsBar extends StatelessWidget {
  final List<StreetSegment> allSegments;
  final DateTime effectiveTime;
  const _StatsBar({
    required this.allSegments,
    required this.effectiveTime,
  });

  @override
  Widget build(BuildContext context) {
    int free = 0, restricted = 0, meter = 0;
    for (final seg in allSegments) {
      switch (RuleEngine.evaluate(seg, effectiveTime).color) {
        case ParkingColor.free:       free++;       break;
        case ParkingColor.restricted: restricted++; break;
        case ParkingColor.meter:      meter++;      break;
        case ParkingColor.noData:     break;
      }
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 12, offset: const Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat(count: free,        color: AppTheme.free,       label: 'Libres'),
          _Divider(),
          _Stat(count: meter,       color: AppTheme.meter,      label: 'Parcom.'),
          _Divider(),
          _Stat(count: restricted,  color: AppTheme.restricted, label: 'Interdit'),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final int count;
  final Color color;
  final String label;
  const _Stat({required this.count, required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('$count',
          style: TextStyle(
              fontWeight: FontWeight.w800, fontSize: 20, color: color)),
      Text(label,
          style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
              fontWeight: FontWeight.w500)),
    ],
  );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 32,
          color: Theme.of(context).dividerColor);
}

// ── Legend item (dot + label) ─────────────────────────────────────────────────
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 10, height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(label,
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface)),
    ],
  );
}
