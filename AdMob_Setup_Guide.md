# AdMob Setup Guide — CalqWise Portfolio
**Publisher:** `ca-app-pub-5379540026739666`
**Date:** 2026-04-21

---

## Nomenclature des Unit IDs

Format: `{app_name}_{type}_{country}`

Exemples:
- `mortgageus_banner_us`
- `mortgageus_interstitial_us`
- `mortgageus_rewarded_us`
- `affordabilityca_banner_ca`
- `helocapp_rewarded_us`

---

## Étape 1 — Accéder à la console AdMob

1. Aller sur **https://admob.google.com**
2. Connexion avec le compte Google lié à `ca-app-pub-5379540026739666`
3. Menu gauche → **Apps**

---

## Étape 2 — Créer / Vérifier chaque App

Pour chaque app du portefeuille :

1. Cliquer **Add app** (ou sélectionner l'app existante)
2. Plateforme : **Android**
3. Entrer le **Package name** (ex: `com.mortgageus.calculator`)
4. Si déjà sur Play Store → cocher "Yes" pour auto-linking
5. Cliquer **Add app** → noter l'**App ID** (`ca-app-pub-XXXX~YYYY`)

> ⚠️ L'App ID va dans `AndroidManifest.xml` → `com.google.android.gms.ads.APPLICATION_ID`

---

## Étape 3 — Créer les Ad Units (3 par app)

Pour chaque app, répéter 3 fois :

### Banner Ad
1. Dans l'app → **Ad units** → **Add ad unit**
2. Type : **Banner**
3. Name : `{app_name}_banner_{country}` (ex: `mortgageus_banner_us`)
4. Cliquer **Create ad unit**
5. Copier l'**Ad Unit ID** (`ca-app-pub-5379540026739666/XXXXXXXXXX`)

### Interstitial Ad
1. Type : **Interstitial**
2. Name : `{app_name}_interstitial_{country}`
3. Créer → copier l'ID

### Rewarded Ad
1. Type : **Rewarded**
2. Name : `{app_name}_rewarded_{country}`
3. Récompense : `1 coin` (valeur arbitraire, pas utilisée en prod)
4. Créer → copier l'ID

---

## Étape 4 — Mettre à jour ad_config.dart

Dans chaque app, ouvrir `lib/config/ad_config.dart` :

```dart
static String get bannerAndroid => kReleaseMode
    ? 'ca-app-pub-5379540026739666/REAL_BANNER_ID'   // ← remplacer XXXXXXXXXX
    : 'ca-app-pub-3940256099942544/6300978111';       // test ID (garder)

static String get interstitialAndroid => kReleaseMode
    ? 'ca-app-pub-5379540026739666/REAL_INTER_ID'
    : 'ca-app-pub-3940256099942544/1033173712';

static String get rewardedAndroid => kReleaseMode
    ? 'ca-app-pub-5379540026739666/REAL_REWARD_ID'
    : 'ca-app-pub-3940256099942544/5224354917';
```

---

## Étape 5 — Mettre à jour AndroidManifest.xml

Dans `android/app/src/main/AndroidManifest.xml` :

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-5379540026739666~REAL_APP_ID" />
```

> ⚠️ Ne pas confondre App ID (`~YYYY`) avec Ad Unit ID (`/ZZZZ`)

---

## Étape 6 — Vérifier (test sur device réel)

1. Build release : `flutter build apk --release`
2. Installer sur device physique
3. Ouvrir l'app → les vraies pubs devraient apparaître après 1-2 minutes
4. Vérifier sur la console AdMob : **Reports → Today** → impressions

> ⚠️ Les pubs test (test IDs) n'apparaissent PAS sur la console. Seules les vraies IDs génèrent des impressions.

---

## Test IDs de référence (Google officiels — à garder en debug)

| Type | Android Test ID |
|------|----------------|
| Banner | `ca-app-pub-3940256099942544/6300978111` |
| Interstitial | `ca-app-pub-3940256099942544/1033173712` |
| Rewarded | `ca-app-pub-3940256099942544/5224354917` |

---

## Timeline AdMob

- **J+0** : Créer les unités dans la console → 45-90 min de délai d'activation
- **J+1** : Première impression visible dans Reports
- **J+7** : Estimations de revenus disponibles (eCPM stabilisé)
- **J+30** : Premier paiement (si seuil $100+ atteint)

---

## Règles CalqWise (obligatoires)

- ❌ **Jamais d'App Open Ad** (mauvaise UX)
- ✅ **Banner** → permanent en bas de chaque écran calculateur
- ✅ **Interstitial** → après chaque 5 calculs, cooldown 5 min minimum
- ✅ **Rewarded** → optionnel, offre 60 min sans pub
- ✅ **Premium** → désactive TOUTES les pubs (banner + interstitial)
- ✅ **Test IDs** → toujours actifs en `kDebugMode`, jamais en release
