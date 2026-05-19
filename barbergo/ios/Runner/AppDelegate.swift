import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase é inicializado pelo FlutterFire no Dart (Firebase.initializeApp)
    // NÃO chamar FirebaseApp.configure() aqui — causaria dupla inicialização
    GMSServices.provideAPIKey("AIzaSyC2Bc5zn-00KeQO8sb0uV1zkXeJXpql2GQ")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
