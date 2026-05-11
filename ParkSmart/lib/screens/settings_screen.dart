import 'package:calcwise_core/calcwise_core.dart' show CalcwiseTheme, themeModeService;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/services/freemium_service.dart';
import '../core/services/iap_service.dart';
import '../core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _requestReview() async {
    final review = InAppReview.instance;
    if (await review.isAvailable()) {
      await review.requestReview();
    } else {
      await review.openStoreListing();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ct = CalcwiseTheme.of(context);
    return Scaffold(
      backgroundColor: ct.surface,
      appBar: AppBar(
        backgroundColor: ct.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: ct.textSecondary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
            ),
            child: Icon(Icons.settings_outlined,
                color: AppTheme.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            'Paramètres',
            style: TextStyle(
                color: ct.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700),
          ),
        ]),
      ),
      body: ListView(
        children: [
          // ── Affichage ─────────────────────────────────────────────────────
          const _SectionHeader('Affichage'),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeModeService.notifier,
            builder: (_, __, ___) => ListTile(
              leading: Icon(themeModeService.icon, color: AppTheme.primary),
              title: Text(
                themeModeService.label(isFrench: true),
                style: TextStyle(color: ct.textPrimary),
              ),
              trailing: Icon(Icons.chevron_right, color: ct.textSecondary),
              onTap: () => themeModeService.toggle(),
            ),
          ),
          Divider(height: 1, color: ct.cardBorder),

          // ── Premium ───────────────────────────────────────────────────────
          const _SectionHeader('Premium'),
          ValueListenableBuilder<bool>(
            valueListenable: freemiumService.isPremiumNotifier,
            builder: (ctx, isPremium, _) => isPremium
                ? ListTile(
                    leading: Icon(Icons.verified_rounded,
                        color: AppTheme.accent),
                    title: Text('Premium activé',
                        style: TextStyle(color: ct.textPrimary)),
                    subtitle: Text(
                        'Toutes les fonctionnalités déverrouillées',
                        style: TextStyle(color: ct.textSecondary)),
                  )
                : Column(mainAxisSize: MainAxisSize.min, children: [
                    _SettingsTile(
                      icon: Icons.star_outline,
                      label: 'Obtenir Premium — \$2.99',
                      subtitle: 'Supprimer les publicités · Accès complet',
                      onTap: () => IAPService.instance.buy(),
                    ),
                    _SettingsTile(
                      icon: Icons.restore,
                      label: "Restaurer l'achat",
                      onTap: () => IAPService.instance.restore(),
                    ),
                    if (kDebugMode)
                      ListTile(
                        leading: const Icon(Icons.bug_report,
                            color: Colors.orange),
                        title: Text('Force Premium (DEV)',
                            style: TextStyle(color: ct.textPrimary)),
                        onTap: () => freemiumService.debugUnlockPremium(),
                      ),
                  ]),
          ),
          Divider(height: 1, color: ct.cardBorder),

          // ── Support ───────────────────────────────────────────────────────
          const _SectionHeader('Support'),
          _SettingsTile(
            icon: Icons.star_outline,
            label: 'Évaluer ParkSmart',
            onTap: _requestReview,
          ),
          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            label: 'Politique de confidentialité',
            onTap: () => _launch('https://calqwise.com/privacy'),
          ),
          _SettingsTile(
            icon: Icons.email_outlined,
            label: 'Contacter le support',
            onTap: () => _launch('mailto:support@calqwise.com'),
          ),
          Divider(height: 1, color: ct.cardBorder),

          // ── À propos ──────────────────────────────────────────────────────
          const _SectionHeader('À propos'),
          _SettingsTile(
            icon: Icons.apps_outlined,
            label: 'CalqWise',
            subtitle: 'Découvrez nos autres applications',
            onTap: () => _launch('https://calqwise.com'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Données de stationnement fournies à titre informatif uniquement. '
              'Vérifiez toujours la signalisation locale avant de stationner. '
              'ParkSmart ne peut être tenu responsable d\'une contravention.',
              style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: ct.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─── Helper widgets ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppTheme.primary,
            letterSpacing: 0.8,
          ),
        ),
      );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  const _SettingsTile({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ct = CalcwiseTheme.of(context);
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(label, style: TextStyle(color: ct.textPrimary)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TextStyle(color: ct.textSecondary))
          : null,
      trailing: Icon(Icons.chevron_right,
          size: 18, color: ct.textSecondary),
      onTap: onTap,
    );
  }
}
