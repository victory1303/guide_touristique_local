import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // REMPLACER REMPLACER_TA_CLE_GOOGLE_MAPS_ICI par votre clé Google Maps (Google Cloud Console)
    GMSServices.provideAPIKey("REMPLACER_TA_CLE_GOOGLE_MAPS_ICI")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
