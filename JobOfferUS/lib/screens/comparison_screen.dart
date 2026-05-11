import 'package:flutter/material.dart';
import 'package:calcwise_core/calcwise_core.dart';
import '../core/engines/insight_engine.dart';
import '../core/freemium/freemium_service.dart';
import '../core/language/language_notifier.dart';
import '../core/models/comparison_result.dart';
import '../core/models/job_offer.dart';
import '../core/theme/app_theme.dart';
import '../widgets/comparison_bar.dart';
import '../widgets/insight_card.dart';
import '../widgets/paywall_hard.dart';
import '../widgets/paywall_soft.dart';
import '../core/ads/ad_footer.dart';

class ComparisonScreen extends StatelessWidget {
  final JobOffer offerA;
  final JobOffer offerB;
  final ComparisonResult result;

  const ComparisonScreen({
    super.key,
    required this.offerA,
    required this.offerB,
    required this.result,
  });

  void _showPaywall(BuildContext context, bool isSpanish) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaywallHard(
        isSpanish: isSpanish,
        onPurchase: () async {
          Navigator.pop(context);
          await freemiumService.unlockPremium();
        },
        onDismiss: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isSpanishNotifier,
      builder: (_, isSpanish, __) =>
          ValueListenableBuilder<bool>(
        valueListenable: freemiumService.isPremiumNotifier,
        builder: (_, isPremium, __) => Scaffold(
          appBar: AppBar(
            title: Text(isSpanish ? 'Resultado' : 'Comparison'),
            leading: const BackButton(),
            actions: [
              if (isPremium)
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  onPressed: () {/* TODO: PDF export */},
                  tooltip: isSpanish ? 'Exportar PDF' : 'Export PDF',
                )
              else
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  onPressed: () => _showPaywall(context, isSpanish),
                  tooltip: isSpanish ? 'Premium: PDF' : 'Premium: PDF',
                ),
            ],
          ),
          body: _buildBody(context, isSpanish, isPremium),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, bool isSpanish, bool isPremium) {
    final a = result.resultA;
    final b = result.resultB;
    final insights = InsightEngine.generate(result, isSpanish: isSpanish);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Winner banner ──────────────────────────────────────────────
          WinnerBanner(result: result, isSpanish: isSpanish),
          const SizedBox(height: 20),

          // ── Offer labels header ────────────────────────────────────────
          _OfferHeader(
            labelA: offerA.label.isNotEmpty
                ? offerA.label
                : (isSpanish ? 'Oferta A' : 'Offer A'),
            labelB: offerB.label.isNotEmpty
                ? offerB.label
                : (isSpanish ? 'Oferta B' : 'Offer B'),
            companyA: offerA.company,
            companyB: offerB.company,
          ),
          const SizedBox(height: 16),

          // ── Core comparison card ───────────────────────────────────────
          _SectionCard(
            title: isSpanish ? 'Salario Neto' : 'After-Tax Income',
            children: [
              ComparisonBar(
                label: isSpanish ? 'Salario neto anual' : 'Annual take-home',
                valueA: a.netTakeHome,
                valueB: b.netTakeHome,
                winner: result.categoryWinners['takeHome'],
                isSpanish: isSpanish,
              ),
              ComparisonBar(
                label: isSpanish ? 'Mensual' : 'Monthly',
                valueA: a.monthlyTakeHome,
                valueB: b.monthlyTakeHome,
                winner: result.categoryWinners['takeHome'],
                isSpanish: isSpanish,
              ),
              ComparisonBar(
                label: isSpanish ? 'Tasa impositiva efectiva' : 'Effective tax rate',
                valueA: a.effectiveTaxRate,
                valueB: b.effectiveTaxRate,
                winner: result.categoryWinners['takeHome'],
                isSpanish: isSpanish,
                formatter: (v) => '${v.toStringAsFixed(1)}%',
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Tax breakdown ──────────────────────────────────────────────
          _SectionCard(
            title: isSpanish ? 'Desglose de Impuestos' : 'Tax Breakdown',
            children: [
              ComparisonBar(
                label: isSpanish ? 'Impuesto federal' : 'Federal tax',
                valueA: a.federalTax,
                valueB: b.federalTax,
                isSpanish: isSpanish,
              ),
              ComparisonBar(
                label: isSpanish ? 'Impuesto estatal' : 'State tax',
                valueA: a.stateTax,
                valueB: b.stateTax,
                isSpanish: isSpanish,
              ),
              ComparisonBar(
                label: 'FICA (SS + Medicare)',
                valueA: a.ficaTax,
                valueB: b.ficaTax,
                isSpanish: isSpanish,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Benefits & extras ──────────────────────────────────────────
          _SectionCard(
            title: isSpanish ? 'Beneficios y Extras' : 'Benefits & Extras',
            children: [
              if (a.annualBonus > 0 || b.annualBonus > 0)
                ComparisonBar(
                  label: isSpanish ? 'Bono neto anual' : 'Annual bonus (after tax)',
                  valueA: a.bonusAfterTax,
                  valueB: b.bonusAfterTax,
                  winner: result.categoryWinners['bonus'],
                  isSpanish: isSpanish,
                ),
              if (a.k401kMatch > 0 || b.k401kMatch > 0)
                ComparisonBar(
                  label: isSpanish ? '401k (aporte empleador)' : '401k employer match',
                  valueA: a.k401kMatch,
                  valueB: b.k401kMatch,
                  winner: result.categoryWinners['benefits'],
                  isSpanish: isSpanish,
                ),
              if (a.healthBenefits > 0 || b.healthBenefits > 0)
                ComparisonBar(
                  label: isSpanish ? 'Salud + dental' : 'Health + dental',
                  valueA: a.healthBenefits,
                  valueB: b.healthBenefits,
                  winner: result.categoryWinners['benefits'],
                  isSpanish: isSpanish,
                ),
              if (a.ptoValue > 0 || b.ptoValue > 0)
                ComparisonBar(
                  label: isSpanish ? 'Valor vacaciones (PTO)' : 'PTO value',
                  valueA: a.ptoValue,
                  valueB: b.ptoValue,
                  winner: result.categoryWinners['pto'],
                  isSpanish: isSpanish,
                ),
              if (a.annualRsuValue > 0 || b.annualRsuValue > 0)
                ComparisonBar(
                  label: isSpanish ? 'RSU / Stock anual' : 'Annual RSU / Stock',
                  valueA: a.annualRsuValue,
                  valueB: b.annualRsuValue,
                  winner: result.categoryWinners['rsu'],
                  isSpanish: isSpanish,
                ),
              if (a.commuteCost > 0 || b.commuteCost > 0)
                ComparisonBar(
                  label: isSpanish ? 'Costo transporte (−)' : 'Commute cost (−)',
                  valueA: a.commuteCost,
                  valueB: b.commuteCost,
                  winner: result.categoryWinners['commute'],
                  isSpanish: isSpanish,
                ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Total compensation ─────────────────────────────────────────
          _SectionCard(
            title: isSpanish ? 'Compensación Total Neta' : 'Net Total Compensation',
            highlight: true,
            children: [
              ComparisonBar(
                label: isSpanish ? 'Total anual neto' : 'Total annual net',
                valueA: a.totalCompensation,
                valueB: b.totalCompensation,
                winner: result.categoryWinners['total'],
                isSpanish: isSpanish,
              ),
              ComparisonBar(
                label: isSpanish ? 'Total mensual neto' : 'Total monthly net',
                valueA: a.monthlyTotalComp,
                valueB: b.monthlyTotalComp,
                winner: result.categoryWinners['total'],
                isSpanish: isSpanish,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── CoL-adjusted (Premium) ─────────────────────────────────────
          if (isPremium) ...[
            _SectionCard(
              title: isSpanish
                  ? 'Poder Adquisitivo Real'
                  : 'Real Purchasing Power (CoL-adjusted)',
              children: [
                ComparisonBar(
                  label: isSpanish
                      ? 'Salario ajustado por costo de vida'
                      : 'CoL-adjusted take-home',
                  valueA: a.colAdjustedTakeHome,
                  valueB: b.colAdjustedTakeHome,
                  winner: result.categoryWinners['col'],
                  isSpanish: isSpanish,
                ),
              ],
            ),
            const SizedBox(height: 12),
          ] else ...[
            PaywallSoft(
              featureTitle: isSpanish
                  ? 'Poder adquisitivo real por ciudad'
                  : 'Real purchasing power by city',
              featureSubtitle: isSpanish
                  ? '\$100k en NYC ≠ \$100k en Dallas'
                  : '\$100k in NYC ≠ \$100k in Dallas',
              isSpanish: isSpanish,
              onUnlock: () => _showPaywall(context, isSpanish),
            ),
            const SizedBox(height: 12),
          ],

          // ── 5-year projection (Premium) ────────────────────────────────
          if (isPremium && a.fiveYearProjection.isNotEmpty) ...[
            _ProjectionCard(
              resultA: a,
              resultB: b,
              labelA: offerA.label,
              labelB: offerB.label,
              isSpanish: isSpanish,
            ),
            const SizedBox(height: 12),
          ] else if (!isPremium) ...[
            PaywallSoft(
              featureTitle:
                  isSpanish ? 'Proyección a 5 años' : '5-year career projection',
              featureSubtitle: isSpanish
                  ? 'Con aumentos anuales, ¿cuál ofrece más a largo plazo?'
                  : 'With annual raises, which pays more long-term?',
              isSpanish: isSpanish,
              onUnlock: () => _showPaywall(context, isSpanish),
            ),
            const SizedBox(height: 12),
          ],

          // ── Smart insights ─────────────────────────────────────────────
          InsightCard(insights: insights, isSpanish: isSpanish),
          const SizedBox(height: 20),

          // ── Share / PDF CTA ────────────────────────────────────────────
          if (isPremium)
            OutlinedButton.icon(
              onPressed: () {/* TODO PDF */},
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: Text(isSpanish ? 'Exportar reporte PDF' : 'Export PDF Report'),
            ),
          const SizedBox(height: 20),

          // ── Ad footer ──────────────────────────────────────────────────
          const AdFooter(),
        ],
      ),
    );
  }
}

// ── Sub-widgets ──────────────────────────────────────────────────────────────

class _OfferHeader extends StatelessWidget {
  final String labelA, labelB, companyA, companyB;
  const _OfferHeader({
    required this.labelA, required this.labelB,
    required this.companyA, required this.companyB,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: _OfferChip(label: labelA, company: companyA, isA: true)),
      const SizedBox(width: 8),
      Expanded(child: _OfferChip(label: labelB, company: companyB, isA: false)),
    ]);
  }
}

class _OfferChip extends StatelessWidget {
  final String label, company;
  final bool isA;
  const _OfferChip({required this.label, required this.company, required this.isA});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.offerColor(isA);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.offerColorLight(isA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(children: [
        Container(
          width: 24, height: 24,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(child: Text(isA ? 'A' : 'B',
              style: const TextStyle(color: Colors.white,
                  fontSize: 11, fontWeight: FontWeight.w800))),
        ),
        const SizedBox(width: 8),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700, color: color)),
            if (company.isNotEmpty)
              Text(company, style: TextStyle(
                  fontSize: 11, color: CalcwiseTheme.of(context).textSecondary),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        )),
      ]),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool highlight;
  const _SectionCard({
    required this.title, required this.children, this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final ct = CalcwiseTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight
              ? AppTheme.primary.withOpacity(0.4)
              : ct.cardBorder,
          width: highlight ? 1.5 : 1,
        ),
        boxShadow: highlight ? [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.2),
            blurRadius: 16, offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(title, style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700,
              color: highlight ? AppTheme.primaryLight : ct.textPrimary,
            )),
          ),
          Divider(height: 1, color: ct.cardBorder),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _ProjectionCard extends StatelessWidget {
  final dynamic resultA, resultB;
  final String labelA, labelB;
  final bool isSpanish;
  const _ProjectionCard({
    required this.resultA, required this.resultB,
    required this.labelA, required this.labelB, required this.isSpanish,
  });

  @override
  Widget build(BuildContext context) {
    final projA = (resultA.fiveYearProjection as List<double>);
    final projB = (resultB.fiveYearProjection as List<double>);
    final totalA = projA.fold(0.0, (s, v) => s + v);
    final totalB = projB.fold(0.0, (s, v) => s + v);

    final ct = CalcwiseTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ct.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              isSpanish ? 'Proyección 5 Años' : '5-Year Projection',
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                ...List.generate(5, (i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: ComparisonBar(
                    label: isSpanish ? 'Año ${i + 1}' : 'Year ${i + 1}',
                    valueA: i < projA.length ? projA[i] : 0,
                    valueB: i < projB.length ? projB[i] : 0,
                    winner: (i < projA.length && i < projB.length)
                        ? (projA[i] >= projB[i] ? Winner.offerA : Winner.offerB)
                        : null,
                    isSpanish: isSpanish,
                  ),
                )),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 4),
                ComparisonBar(
                  label: isSpanish ? 'TOTAL 5 años' : 'TOTAL 5 years',
                  valueA: totalA,
                  valueB: totalB,
                  winner: totalA >= totalB ? Winner.offerA : Winner.offerB,
                  isSpanish: isSpanish,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
