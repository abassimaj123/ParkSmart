import 'package:latlong2/latlong.dart';
import '../models/city.dart';
import 'city_defaults.dart';

/// Registre de toutes les villes supportées par ParkSmart.
///
/// ## Ajouter une ville
/// Une seule entrée ici — tout le reste (Overpass, cache, UI, GPS) s'adapte.
///
/// ## Capitale-Nationale (Québec + Lévis)
/// Une seule entrée couvre les deux rives du Saint-Laurent.
/// Le filtre admin_level=8 avec union ['Québec', 'Lévis'] garantit que seules
/// les rues de ces deux municipalités sont incluses.
/// segmentCityNames: ['Québec', 'Lévis'] → les segments mock des deux villes
/// s'affichent quand cette entrée est sélectionnée.
///
/// ## Grand Montréal
/// Montréal + Laval + Longueuil dans une seule entrée via union Overpass.
/// L'utilisateur voit "Montréal" — le fetch couvre les 3 municipalités.
class CityRegistry {
  static const List<City> supported = [

    // ── Capitale-Nationale (Québec + Lévis) ────────────────────────────────
    City(
      id: 'capitale',
      name: 'Québec',
      center: LatLng(46.7800, -71.2200),
      // Bbox couvre les deux rives : rive nord (Québec) + rive sud (Lévis)
      overpassBbox: '46.580,-71.600,46.960,-70.880',
      overpassAreaNames: ['Québec', 'Lévis'],
      segmentCityNames: ['Québec', 'Lévis'],
      defaultRules: CityDefaults.quebecRules,
      hasComprehensiveDefaults: true,  // limite 2h inscrite dans R.V.Q. 1400
      defaultZoom: 12.5,
    ),

    // ── Grand Montréal (Île + Laval + Longueuil) ──────────────────────────
    City(
      id: 'montreal',
      name: 'Montréal',
      center: LatLng(45.5317, -73.6017),
      // Bbox couvre les 3 municipalités
      overpassBbox: '45.360,-74.050,45.730,-73.340',
      overpassAreaNames: ['Montréal', 'Laval', 'Longueuil'],
      segmentCityNames: ['Montréal'],
      defaultRules: CityDefaults.montrealRules,
      // true : rues hors zone connue → règle par défaut (libre + déneigement Nov-Mar).
      // La majorité des rues MTL sont libres ; les zones SRRR/parcomètre
      // sont capturées par ZoneRegistry. Gris = trop pessimiste.
      hasComprehensiveDefaults: true,
      defaultZoom: 12.0,
    ),
  ];

  static City get defaultCity => supported.first;

  static City? findById(String id) =>
      supported.cast<City?>().firstWhere(
        (c) => c?.id == id,
        orElse: () => null,
      );

  /// Ville dont le centre est le plus proche de [position].
  static City nearest(LatLng position) {
    City best = supported.first;
    double bestDist = double.infinity;
    for (final city in supported) {
      final dlat = city.center.latitude  - position.latitude;
      final dlon = city.center.longitude - position.longitude;
      final d2   = dlat * dlat + dlon * dlon;
      if (d2 < bestDist) { bestDist = d2; best = city; }
    }
    return best;
  }
}
