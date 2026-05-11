import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calcwise_core/calcwise_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/engines/offer_engine.dart';
import '../core/freemium/freemium_service.dart';
import '../core/language/language_notifier.dart';
import '../core/models/job_offer.dart';
import '../core/theme/app_theme.dart';
import '../widgets/offer_form_card.dart';
import '../widgets/paywall_hard.dart';
import 'comparison_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  JobOffer _offerA = const JobOffer(
      label: 'Offer A', baseSalary: 0, stateCode: 'CA',
      city: 'San Francisco, CA');
  JobOffer _offerB = const JobOffer(
      label: 'Offer B', baseSalary: 0, stateCode: 'TX',
      city: 'Austin, TX');

  bool get _canCompare => _offerA.baseSalary > 0 && _offerB.baseSalary > 0;

  @override
  void initState() {
    super.initState();
  }

  void _compare() async {
    if (!_canCompare) return;
    await freemiumService.incrementCalcCount();
    if (!mounted) return;
    if (freemiumService.showSoftGate) { _showPaywall(); return; }
    final result = OfferEngine.compare(_offerA, _offerB);
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ComparisonScreen(
          offerA: _offerA, offerB: _offerB, result: result),
    ));
  }

  void _showPaywall() {
    final isSp = isSpanishNotifier.value;
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaywallHard(
        isSpanish: isSp,
        onPurchase: () async {
          Navigator.pop(context);
          await freemiumService.unlockPremium();
          _compare();
        },
        onDismiss: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    ));
    return ValueListenableBuilder<bool>(
      valueListenable: isSpanishNotifier,
      builder: (_, isSp, __) => Scaffold(
        appBar: _appBar(isSp),
        body: _body(isSp),
        bottomNavigationBar: _cta(isSp),
      ),
    );
  }

  PreferredSizeWidget _appBar(bool isSp) {
    final ct = CalcwiseTheme.of(context);
    return AppBar(
    elevation: 0,
    title: Row(children: [
      Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          gradient: AppTheme.ctaGradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(
            color: AppTheme.primary.withOpacity(0.4),
            blurRadius: 12, offset: const Offset(0, 3))],
        ),
        child: const Icon(Icons.compare_arrows_rounded,
            color: Colors.white, size: 18),
      ),
      const SizedBox(width: 10),
      Flexible(
        child: RichText(
          overflow: TextOverflow.ellipsis,
          text: TextSpan(children: [
            TextSpan(text: 'Job Offer',
                style: TextStyle(color: ct.textPrimary,
                    fontSize: 19, fontWeight: FontWeight.w700,
                    letterSpacing: -0.4)),
            TextSpan(text: ' US',
                style: TextStyle(color: ct.accent,
                    fontSize: 19, fontWeight: FontWeight.w800,
                    letterSpacing: -0.4)),
          ]),
        ),
      ),
    ]),
    actions: [
      GestureDetector(
        onTap: () async {
          final next = !isSpanishNotifier.value;
          isSpanishNotifier.value = next;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('language', next ? 'es' : 'en');
        },
        child: Container(
          margin: const EdgeInsets.only(right: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: ct.surfaceHigh,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ct.cardBorder),
          ),
          child: Text(isSp ? '🇺🇸 EN' : '🇲🇽 ES',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                  color: ct.textPrimary)),
        ),
      ),
      IconButton(
        icon: Icon(Icons.settings_outlined, color: ct.textPrimary),
        onPressed: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const SettingsScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 250),
          ),
        ),
      ),
    ],
  );
  }

  Widget _body(bool isSp) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Hero ──────────────────────────────────────────────────────
          CalcwiseStaggerItem(index: 0, child: _HeroBanner(isSp: isSp)),
          const SizedBox(height: 20),
          ValueListenableBuilder<bool>(
            valueListenable: freemiumService.isPremiumNotifier,
            builder: (_, isPremium, __) => Column(children: [
              CalcwiseStaggerItem(
                index: 1,
                child: OfferFormCard(
                isOfferA: true, value: _offerA,
                isPremium: isPremium, isSpanish: isSp,
                onChanged: (o) => setState(() => _offerA = o),
              )),
              const SizedBox(height: 16),
              _VsDivider(),
              const SizedBox(height: 16),
              CalcwiseStaggerItem(
                index: 2,
                child: OfferFormCard(
                isOfferA: false, value: _offerB,
                isPremium: isPremium, isSpanish: isSp,
                onChanged: (o) => setState(() => _offerB = o),
              )),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _cta(bool isSp) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final ct = CalcwiseTheme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottom + 12),
      decoration: BoxDecoration(
        color: ct.surface,
        border: Border(top: BorderSide(color: ct.cardBorder)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3),
              blurRadius: 20, offset: const Offset(0, -4)),
        ],
      ),
      child: GestureDetector(
        onTap: _canCompare ? _compare : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 56,
          decoration: BoxDecoration(
            gradient: _canCompare ? AppTheme.ctaGradient : LinearGradient(
              colors: [
                AppTheme.primary.withOpacity(0.3),
                AppTheme.offerBDeep.withOpacity(0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: _canCompare ? AppTheme.ctaShadow : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.compare_arrows_rounded,
                  color: _canCompare
                      ? Colors.white
                      : Colors.white.withOpacity(0.35),
                  size: 22),
              const SizedBox(width: 10),
              Text(
                isSp ? 'Comparar ofertas' : 'Compare Offers',
                style: TextStyle(
                  color: _canCompare
                      ? Colors.white
                      : Colors.white.withOpacity(0.35),
                  fontSize: 17, fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Hero ─────────────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  final bool isSp;
  const _HeroBanner({required this.isSp});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        gradient: AppTheme.heroGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: const Color(0xFF3730A3).withOpacity(0.4),
              blurRadius: 28, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _LetterBadge('A', AppTheme.offerALight, AppTheme.offerADeep),
            const SizedBox(width: 8),
            _LetterBadge('B', AppTheme.offerBLight, AppTheme.offerBDeep),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: const [
                Icon(Icons.verified_rounded, color: AppTheme.accent, size: 13),
                SizedBox(width: 4),
                Text('2025', style: TextStyle(
                    color: AppTheme.accent, fontSize: 12,
                    fontWeight: FontWeight.w700)),
              ]),
            ),
          ]),
          const SizedBox(height: 14),
          Text(
            isSp ? 'Compara tu compensación real' : 'Know your true compensation',
            style: const TextStyle(
              color: Colors.white, fontSize: 22,
              fontWeight: FontWeight.w800, letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isSp
                ? 'Salario neto, impuestos, beneficios y más'
                : 'After-tax salary, benefits, commute & more',
            style: TextStyle(
                color: Colors.white.withOpacity(0.72), fontSize: 14,
                height: 1.4),
          ),
          const SizedBox(height: 14),
          Wrap(spacing: 8, runSpacing: 6, children: [
            _HChip(isSp ? '51 estados' : '51 States'),
            _HChip(isSp ? '50+ ciudades' : '50+ Cities'),
            _HChip('FICA · IRS 2025'),
            _HChip(isSp ? '★ 5 años' : '★ 5-yr',
                color: AppTheme.accent.withOpacity(0.25)),
          ]),
        ],
      ),
    );
  }
}

class _LetterBadge extends StatelessWidget {
  final String l;
  final Color bg, border;
  const _LetterBadge(this.l, this.bg, this.border);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        color: bg.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: bg.withOpacity(0.5), width: 1.5),
      ),
      child: Center(
        child: Text(l,
            style: TextStyle(color: bg, fontSize: 16,
                fontWeight: FontWeight.w800)),
      ),
    );
  }
}

class _HChip extends StatelessWidget {
  final String t;
  final Color? color;
  const _HChip(this.t, {this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color ?? Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Text(t,
          style: TextStyle(
              color: Colors.white.withOpacity(0.88), fontSize: 12,
              fontWeight: FontWeight.w500)),
    );
  }
}

// ── VS divider ────────────────────────────────────────────────────────────────

class _VsDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Container(height: 1.5,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, AppTheme.offerADeep],
            ),
          ))),
      const SizedBox(width: 10),
      Container(
        width: 46, height: 46,
        decoration: BoxDecoration(
          gradient: AppTheme.ctaGradient,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(
            color: AppTheme.primary.withOpacity(0.4),
            blurRadius: 16, offset: const Offset(0, 4),
          )],
        ),
        child: const Center(
          child: Text('VS', style: TextStyle(
            color: Colors.white, fontSize: 13,
            fontWeight: FontWeight.w900, letterSpacing: 1.5,
          )),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(child: Container(height: 1.5,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.offerBDeep, Colors.transparent],
            ),
          ))),
    ]);
  }
}
