import UIKit
import Flutter
import MusicKit

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "apple_music_auth", binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "requestAppleMusicAuth" {
        self.requestMusicAuthorization(result: result)
      } else if call.method == "getAppleMusicUserToken" {
        guard let args = call.arguments as? [String: Any],
              let developerToken = args["developerToken"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing developerToken", details: nil))
          return
        }
        self.getAppleMusicUserToken(developerToken: developerToken, result: result)
      } else if call.method == "checkAppleMusicSubscription" {
          self.checkAppleMusicSubscription(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func requestMusicAuthorization(result: @escaping FlutterResult) {
    Task {
      let status = await MusicAuthorization.request()
      switch status {
        case .authorized:
          result("authorized")
        case .restricted:
          result("restricted")
        case .denied:
          result("denied")
        case .notDetermined:
          result("notDetermined")
        @unknown default:
          result("unknown")
      }
    }
  }

    private func getAppleMusicUserToken(developerToken: String, result: @escaping FlutterResult) {
        Task {
            let status = await MusicAuthorization.currentStatus
            guard status == .authorized else {
                result(FlutterError(
                    code: "NOT_AUTHORIZED",
                    message: "Apple Music not authorized",
                    details: nil
                ))
                return
            }

            do {
                let tokenProvider = MusicUserTokenProvider()
                let userToken = try await tokenProvider.userToken(
                    for: developerToken,
                    options: []
                )
               
               result(userToken)
            } catch {
                result(FlutterError(
                    code: "USER_TOKEN_ERROR",
                    message: error.localizedDescription,
                    details: nil
                ))
            }
        }
    }
    
    private func checkAppleMusicSubscription(result: @escaping FlutterResult) {
        Task {
            do {
                let subscription = try await MusicSubscription.current

                let response: [String: Any] = [
                    "canPlayCatalogContent": subscription.canPlayCatalogContent,
                    "canBecomeSubscriber": subscription.canBecomeSubscriber,
                    "hasCloudLibraryEnabled": subscription.hasCloudLibraryEnabled
                ]

                result(response)
            } catch {
                result(FlutterError(code: "SUBSCRIPTION_ERROR", message: "Could not retrieve Apple Music subscription", details: error.localizedDescription))
            }
        }
    }
    
}
