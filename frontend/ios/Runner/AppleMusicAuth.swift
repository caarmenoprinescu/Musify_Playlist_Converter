import Foundation
import MusicKit

@objc class AppleMusicAuth: NSObject {

    @objc static func signInToAppleMusic(devToken: String, completion: @escaping (String?, Error?) -> Void) {
        Task {
            do {
                let authStatus = await MusicAuthorization.request()

                if authStatus != .authorized {
                    completion(nil, NSError(domain: "MusicKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "User denied Apple Music access"]))
                    return
                }

                let userToken = try await MusicUserTokenProvider.userToken(for: devToken)
                completion(userToken, nil)

            } catch {
                completion(nil, error)
            }
        }
    }
}