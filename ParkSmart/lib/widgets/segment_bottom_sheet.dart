import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:calcwise_core/calcwise_core.dart' show PaywallSoft;
import '../core/models/street_segment.dart';
import '../core/models/parking_rule.dart';
import '../core/services/freemium_service.dart';
import '../core/services/iap_service.dart';
import '../core/services/rule_engine.dart';
import '../core/services/session_service.dart';
import '../core/theme/app_theme.dart';

class SegmentBottomSheet extends StatelessWidget {
  final StreetSegment segment;
  final DateTime viewTime;
  final VoidCallback onClose;

  const SegmentBottomSheet({
    super.key,
    required this.segment,
    required this.viewTime,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final result = RuleEngine.evaluate(segment, viewTime);
    final zoneColor = AppTheme.colorForHex(result.colorHex);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Colored accent bar
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [zoneColor, zoneColor.withAlpha(77)],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(2),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              segment.streetName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: AppTheme.primary,
                                    fontSize: 20,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _SideBadge(side: segment.side),
                                const SizedBox(width: 6),
                                Text(
                                  segment.city,
                                  style: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.dark
                                      ? const Color(0xFFCBD5E1)
                                      : const Color(0xFF475569),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: onClose,
                        color: const Color(0xFF64748B),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Status badge
                  _StatusBadge(result: result, zoneColor: zoneColor),
                  const SizedBox(height: 12),

                  // Next change time
                  if (result.nextChangeTime != null)
                    _NextChangeBanner(
                      nextChange: result.nextChangeTime!,
                      viewTime: viewTime,
                      color: zoneColor,
                    ),

                  // Meter info
                  if (result.activeRule?.type == RuleType.meter &&
                      result.activeRule != null)
                    _MeterInfo(rule: result.activeRule!),

                  // Permit info
                  if (result.activeRule?.type == RuleType.permitOnly &&
                      result.activeRule?.permitZone != null)
                    _PermitInfo(zone: result.activeRule!.permitZone!),

                  // Pair/impair info
                  if (result.activeRule?.isAlternating == true)
                    _AlternatingInfo(
                      rule: result.activeRule!,
                      viewTime: viewTime,
                      allRules: segment.rules,
                    ),

                  if (segment.rules.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Règles de stationnement',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.primary,
                          ),
                    ),
                    const SizedBox(height: 8),
                    ...segment.rules
                        .map((rule) => _RuleRow(rule: rule, viewTime: viewTime))
                        .toList(),
                  ],

                  const SizedBox(height: 16),

                  // Confidence bar
                  _ConfidenceBar(confidence: segment.confidence),
                  const SizedBox(height: 12),

                  // Sources
                  _SourcesRow(sources: segment.sources),
                  const SizedBox(height: 4),
                  Text(
                    'Données du ${_formatDate(segment.sourceDate)}',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),

                  if (segment.notes != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 14, color: Colors.amber[800]),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              segment.notes!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.amber[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: _StartSessionButton(
              segment: segment,
              viewTime: viewTime,
              result: result,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('d MMM yyyy', 'fr_CA').format(dt);
    } catch (_) {
      return dateStr;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final RuleResult result;
  final Color zoneColor;

  const _StatusBadge({required this.result, required this.zoneColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: zoneColor.withAlpha(31),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: zoneColor.withAlpha(102)),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: zoneColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            result.label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: zoneColor,
              fontSize: 15,
            ),
          ),
          if (result.hasTimeLimit && result.activeRule?.maxMinutes != null) ...[
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: zoneColor.withAlpha(38),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Max ${_formatDuration(result.activeRule!.maxMinutes!)}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: zoneColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) return '${minutes}min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m > 0 ? '${h}h${m}min' : '${h}h';
  }
}

class _NextChangeBanner extends StatelessWidget {
  final DateTime nextChange;
  final DateTime viewTime;
  final Color color;

  const _NextChangeBanner({
    required this.nextChange,
    required this.viewTime,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final diff = nextChange.difference(viewTime);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    final label = hours > 0
        ? 'Prochain changement dans ${hours}h${minutes > 0 ? '${minutes}min' : ''}'
        : 'Prochain changement dans ${diff.inMinutes}min';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, size: 14, color: const Color(0xFF475569)),
          const SizedBox(width: 6),
          Text(
            '$label (${DateFormat('HH:mm').format(nextChange)})',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF475569),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _MeterInfo extends StatelessWidget {
  final ParkingRule rule;

  const _MeterInfo({required this.rule});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.meter.withAlpha(20),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.payment, color: AppTheme.meter, size: 18),
          const SizedBox(width: 10),
          if (rule.ratePerHour != null)
            Text(
              '${rule.ratePerHour!.toStringAsFixed(2)} \$/h',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppTheme.meter,
                fontSize: 14,
              ),
            ),
          if (rule.ratePerHour != null && rule.maxMinutes != null)
            const Text('  ·  ', style: TextStyle(color: Color(0xFF64748B))),
          if (rule.maxMinutes != null)
            Text(
              'Max ${_formatMins(rule.maxMinutes!)}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.meter,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }

  String _formatMins(int minutes) {
    if (minutes < 60) return '${minutes}min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m > 0 ? '${h}h${m}min' : '${h}h';
  }
}

class _PermitInfo extends StatelessWidget {
  final String zone;

  const _PermitInfo({required this.zone});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.restricted.withAlpha(26),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.restricted.withAlpha(77)),
      ),
      child: Row(
        children: [
          const Icon(Icons.badge_outlined, color: AppTheme.restricted, size: 18),
          const SizedBox(width: 10),
          const Text(
            'Zone permis : ',
            style: TextStyle(
              color: AppTheme.restricted,
              fontSize: 14,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.restricted,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              zone,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stationnement alterné (pair/impair) ────────────────────────────────────
class _AlternatingInfo extends StatelessWidget {
  final ParkingRule rule;
  final DateTime viewTime;
  final List<ParkingRule> allRules;

  const _AlternatingInfo({
    required this.rule,
    required this.viewTime,
    required this.allRules,
  });

  @override
  Widget build(BuildContext context) {
    // Déterminer le libellé de parité du mois ou du jour
    final isMonthly = rule.monthParity != null;
    final cycleLabel = isMonthly
        ? 'Stationnement alterné par mois'
        : 'Stationnement alterné par jour';

    // Trouver la règle complémentaire (l'autre parité)
    final complementary = allRules.firstWhere(
      (r) => r.isAlternating && r != rule,
      orElse: () => rule,
    );

    // Construire les deux lignes côté pair / côté impair
    final currentUnit = isMonthly
        ? 'Mois ${viewTime.month} (${_monthName(viewTime.month)})'
        : 'Jour ${viewTime.day}';
    final currentParity = isMonthly ? viewTime.month % 2 : viewTime.day % 2;

    // Côté pair = monthParity/dayParity == 0 dans le noParking → interdit quand parity=0 actif
    // La règle "active" est celle dont la parité == currentParity
    // Si rule.monthParity == currentParity → ce côté est interdit maintenant
    final forbiddenSideNote = rule.note ?? 'Côté interdit actuellement';
    final freeSideNote = complementary.note ?? 'Côté autorisé actuellement';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.withAlpha(120)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.swap_horiz, color: Colors.orange, size: 18),
              const SizedBox(width: 8),
              Text(
                cycleLabel,
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Indicateur de date/mois actuel
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.withAlpha(30),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$currentUnit · Parité : ${currentParity == 0 ? "pair" : "impair"}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.deepOrange,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Côté INTERDIT maintenant
          _sideLine(
            icon: Icons.block,
            color: AppTheme.restricted,
            label: forbiddenSideNote,
            suffix: 'INTERDIT maintenant',
          ),
          const SizedBox(height: 6),
          // Côté LIBRE maintenant
          _sideLine(
            icon: Icons.check_circle_outline,
            color: AppTheme.free,
            label: freeSideNote,
            suffix: 'AUTORISÉ maintenant',
          ),
        ],
      ),
    );
  }

  Widget _sideLine({
    required IconData icon,
    required Color color,
    required String label,
    required String suffix,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                suffix,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static const _months = [
    '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
  ];
  String _monthName(int m) => _months[m];
}

class _RuleRow extends StatelessWidget {
  final ParkingRule rule;
  final DateTime viewTime;

  const _RuleRow({required this.rule, required this.viewTime});

  bool get _isActive => rule.appliesAt(viewTime);

  Color get _baseColor {
    switch (rule.type) {
      case RuleType.noParking:    return AppTheme.restricted;
      case RuleType.permitOnly:   return AppTheme.restricted;
      case RuleType.permitOrLimit: return AppTheme.free;
      case RuleType.meter:        return AppTheme.meter;
      case RuleType.free:         return AppTheme.free;
    }
  }

  IconData get _ruleIcon {
    switch (rule.type) {
      case RuleType.noParking:    return Icons.block;
      case RuleType.permitOnly:   return Icons.badge_outlined;
      case RuleType.permitOrLimit: return Icons.hourglass_bottom_outlined;
      case RuleType.meter:        return Icons.timer_outlined;
      case RuleType.free:         return Icons.check_circle_outline;
    }
  }

  String get _typeLabel {
    switch (rule.type) {
      case RuleType.noParking:    return 'Interdit';
      case RuleType.permitOnly:   return 'Permis résidents requis';
      case RuleType.permitOrLimit:
        final lim = rule.maxMinutes != null ? ' (${_fmtMins(rule.maxMinutes!)} max)' : '';
        return '2h max · Permis au-delà$lim';
      case RuleType.meter:        return 'Parcomètre';
      case RuleType.free:
        return rule.maxMinutes != null ? 'Limité ${_fmtMins(rule.maxMinutes!)}' : 'Libre';
    }
  }

  String _fmtMins(int m) {
    if (m < 60) return '${m}min';
    final h = m ~/ 60;
    final rem = m % 60;
    return rem > 0 ? '${h}h${rem}min' : '${h}h';
  }

  @override
  Widget build(BuildContext context) {
    final active = _isActive;
    final color  = active ? _baseColor : const Color(0xFF64748B);

    return Opacity(
      opacity: active ? 1.0 : 0.55,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withAlpha(active ? 18 : 10),
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: color, width: 4),
            top: BorderSide(color: color.withAlpha(active ? 60 : 35)),
            right: BorderSide(color: color.withAlpha(active ? 60 : 35)),
            bottom: BorderSide(color: color.withAlpha(active ? 60 : 35)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Ligne 1 : type + badge actif/inactif ─────────────────────
            Row(
              children: [
                Icon(_ruleIcon, color: color, size: 15),
                const SizedBox(width: 7),
                Text(
                  _typeLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: color,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                // Badge d'état
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: active
                        ? color.withAlpha(30)
                        : const Color(0xFF64748B).withAlpha(20),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: active ? color.withAlpha(80) : const Color(0xFFCBD5E1),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active ? color : const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        active ? 'En vigueur' : 'Hors période',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: active ? color : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // ── Ligne 2 : jours · heures [· saison] ──────────────────────
            Wrap(
              spacing: 4,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _InfoChip(label: rule.daysLabel, color: color),
                _InfoChip(label: rule.timeLabel, color: color),
                if (rule.monthLabel.isNotEmpty)
                  _InfoChip(
                    label: rule.monthLabel,
                    color: color,
                    bold: true,
                  ),
                if (rule.maxMinutes != null && rule.type == RuleType.free)
                  _InfoChip(
                    label: 'Max ${_fmtMins(rule.maxMinutes!)}',
                    color: color,
                    bold: true,
                  ),
              ],
            ),
            // ── Ligne 3 : note ───────────────────────────────────────────
            if (rule.note != null) ...[
              const SizedBox(height: 4),
              Text(
                rule.note!,
                style: TextStyle(fontSize: 11, color: Color(0xFF475569)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool bold;

  const _InfoChip({required this.label, required this.color, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

class _ConfidenceBar extends StatelessWidget {
  final double confidence;

  const _ConfidenceBar({required this.confidence});

  Color get _color {
    if (confidence >= 0.85) return AppTheme.free;
    if (confidence >= 0.65) return Colors.amber;
    return AppTheme.restricted;
  }

  String get _label {
    if (confidence >= 0.85) return 'Haute fiabilité';
    if (confidence >= 0.65) return 'Fiabilité moyenne';
    return 'Fiabilité faible';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Fiabilité',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF475569),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              _label,
              style: TextStyle(
                fontSize: 11,
                color: _color,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '${(confidence * 100).round()}%',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: confidence,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(_color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class _SourcesRow extends StatelessWidget {
  final List<DataSource> sources;

  const _SourcesRow({required this.sources});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: sources
          .map((s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCBD5E1)!),
                ),
                child: Text(
                  '${s.icon} ${s.label}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF334155),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _SideBadge extends StatelessWidget {
  final String side;

  const _SideBadge({required this.side});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.primary.withAlpha(26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        side,
        style: const TextStyle(
          fontSize: 11,
          color: AppTheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StartSessionButton extends StatelessWidget {
  final StreetSegment segment;
  final DateTime viewTime;
  final RuleResult result;

  const _StartSessionButton({
    required this.segment,
    required this.viewTime,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final sessionService = context.watch<SessionService>();
    final hasSession = sessionService.hasActiveSession;

    if (result.color == ParkingColor.restricted) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.restricted.withAlpha(26),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.block, color: AppTheme.restricted, size: 16),
            SizedBox(width: 8),
            Text(
              'Stationnement interdit ici',
              style: TextStyle(
                color: AppTheme.restricted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () {
          if (hasSession) {
            sessionService.endSession();
          } else if (freemiumService.isPremium) {
            sessionService.startSession(segment, viewTime);
          } else {
            PaywallSoft.show(
              context,
              featureTitle: 'ParkSmart Pro',
              featureSubtitle: 'Unlock session tracking, history & more',
              onUnlock: () => IAPService.instance.buy(),
            );
          }
        },
        icon: Icon(hasSession ? Icons.stop_circle_outlined : Icons.play_circle_outline),
        label: Text(
          hasSession ? 'Terminer la session' : 'Débuter une session',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: hasSession ? Colors.red[700] : AppTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
