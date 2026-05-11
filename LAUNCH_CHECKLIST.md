# Pre-Launch Checklist — CalqWise Portfolio
> Copier cette checklist par app. Cocher chaque item avant de soumettre sur Play Console.

---

## App: _____________________ | Package: _____________________

---

## 1. AdMob Setup

- [ ] App enregistrée dans AdMob console (`admob.google.com`)
- [ ] **Banner** Ad Unit ID créé → `lib/config/ad_config.dart` mis à jour
- [ ] **Interstitial** Ad Unit ID créé → `lib/config/ad_config.dart` mis à jour
- [ ] **Rewarded** Ad Unit ID créé → `lib/config/ad_config.dart` mis à jour
- [ ] App ID AdMob mis à jour dans `android/app/src/main/AndroidManifest.xml`
- [ ] Aucun `XXXXXXXXXX` restant dans le code release

## 2. Monetization — Code

- [ ] `FreemiumService.initialize()` appelé dans `main()`
- [ ] `IAPService.instance.initialize()` appelé dans `main()`
- [ ] `AdService.instance.initialize()` appelé dans `main()`
- [ ] `BannerAdWidget` présent sur tous les écrans calculateur (bas de page)
- [ ] `AdService.instance.onCalculation()` appelé à chaque calcul
- [ ] `PaywallService` initialisé dans `main()` (si intégré)
- [ ] Paywall soft déclenché après session 2-3 (si intégré)
- [ ] Paywall hard déclenché après 5+ calculs (si intégré)

## 3. Premium / IAP

- [ ] Produit `premium_upgrade` créé dans Play Console → In-app products
- [ ] Prix correct par marché : US=$2.99 / UK=£1.99 / CA=$3.99 CAD
- [ ] Bouton "Get Premium" visible dans Settings
- [ ] Bouton "Restore Purchase" visible dans Settings
- [ ] Achat testé avec compte test Google Play (pas un vrai achat)
- [ ] Premium désactive toutes les pubs (vérifier sur device)
- [ ] Rewarded 60 min fonctionne (désactive pubs temporairement)

## 4. Tests — Device réel (pas émulateur)

- [ ] Banner s'affiche correctement (pas de layout overflow)
- [ ] Interstitial s'affiche après 5 calculs (vérifier le compteur)
- [ ] Cooldown 5 min entre interstitials fonctionne
- [ ] Rewarded video charge et joue jusqu'à la fin
- [ ] Callback rewarded activé → pubs disparaissent 60 min
- [ ] Aucun crash au démarrage (Firebase Crashlytics)
- [ ] Analytics events envoyés (Firebase DebugView)
- [ ] Historique limité à 3 entrées pour free users
- [ ] Historique illimité pour premium users

## 5. Build & Signing

- [ ] `kReleaseMode` = true → vrais IDs AdMob utilisés
- [ ] Aucun `kDebugMode` override laissé actif
- [ ] `flutter build appbundle --release` réussi (0 erreur)
- [ ] AAB signé avec le bon keystore
- [ ] Version code incrémenté (ex: 1.0.0+2 si update)
- [ ] `flutter analyze` → 0 erreurs, warnings minimes

## 6. Store Listing

- [ ] Titre : ≤ 50 caractères, mot-clé principal inclus
- [ ] Description courte : ≤ 80 caractères
- [ ] Description longue : 4000 max, bullet points
- [ ] Privacy Policy URL : `https://calqwise.com/privacy`
- [ ] Screenshots : 5+ (portrait 1080×1920 ou 1440×2560)
- [ ] Feature graphic : 1024×500 px
- [ ] Catégorie : Finance
- [ ] Classification de contenu : Tout public (PEGI 3)

## 7. Play Console

- [ ] AAB uploadé dans la release (Production ou Closed Testing)
- [ ] Release notes rédigées (en + langue locale si applicable)
- [ ] Politique de données (Data safety) complétée
- [ ] Pas d'alertes bloquantes dans le tableau de bord

## 8. Post-Launch (J+1)

- [ ] AdMob dashboard : premières impressions visibles
- [ ] Firebase Crashlytics : 0 crash critique
- [ ] Play Console : note et avis surveillés
- [ ] AdMob eCPM vérifié après 48h (cible : >$1.50 US/CA)

---

## IDs de référence rapide

| App | Package | Banner | Interstitial | Rewarded |
|-----|---------|--------|-------------|---------|
| AffordabilityCA | com.affordabilityca.calculator | FILL | FILL | FILL |
| AffordabilityUK | com.affordability.uk.calculator | FILL | FILL | FILL |
| AffordabilityUS | com.affordability.us.calculator | FILL | FILL | FILL |
| HELOCApp | com.heloc.us.calculator | FILL | FILL | FILL |
| PropertyROI | com.propertyroi.us.calculator | FILL | FILL | FILL |
| SalaryApp | com.salary.us.calculator | FILL | FILL | FILL |
| StudentLoan | com.studentloan.us.calculator | FILL | FILL | FILL |
| MortgageCA | com.mortgageca.calculator | FILL | FILL | FILL |
| MortgageUK | com.mortgageuk.calculator | FILL | FILL | FILL |
| MortgageUS | com.mortgageus.calculator | FILL | FILL | FILL |
| AutoLoan | com.autoloan.auto_loan | FILL | FILL | FILL |
| LoanPayoffUS | com.loanpayoff.us.calculator | FILL | FILL | FILL |
| RentBuyUS | com.rentbuy.us.calculator | FILL | FILL | FILL |
| RefinanceApp | com.refinance.us.calculator | FILL | FILL | FILL |
| CreditCardAPR | com.creditcard.us.calculator | FILL | FILL | FILL |

> Remplir depuis `AdMob_Unit_IDs_Spreadsheet.csv` une fois les vrais IDs créés.
