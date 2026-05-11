

/// Request GDPR/PIPEDA consent via Google UMP SDK.
/// Resolves on success, timeout, or error so the app always launches.
/// On non-EEA/UK devices the UMP SDK completes immediately without showing a form.
Future<void> _requestConsent() async {
  final completer = Completer<void>();
  ConsentInformation.instance.requestConsentInfoUpdate(
    ConsentRequestParameters(),
    () async {
      // Consent info updated — show form only if required
      if (await ConsentInformation.instance.isConsentFormAvailable()) {
        ConsentForm.loadAndShowConsentFormIfRequired(
          (_) { if (!completer.isCompleted) completer.complete(); },
        );
      } else {
        if (!completer.isCompleted) completer.complete();
      }
    },
    (_) { if (!completer.isCompleted) completer.complete(); },
  );
  return completer.future;
}
