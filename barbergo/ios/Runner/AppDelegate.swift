import Flutter
import UIKit
import GoogleMaps
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase — inicializa antes de tudo
    FirebaseApp.configure()

    // Google Maps
    GMSServices.provideAPIKey("AIzaSyC2Bc5zn-00KeQO8sb0uV1zkXeJXpql2GQ")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
