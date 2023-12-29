import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> sendFirebaseLog(String name, Map<String, dynamic> params) async {
  try {
    await FirebaseAnalytics.instance.logEvent(
      name: name,
      parameters: params,
    );
  } catch (e) {
    await FirebaseAnalytics.instance.logEvent(
      name: "send_firebase_error",
      parameters: {"name": name, "params": params.toString(), "error": e},
    );
  }
}
