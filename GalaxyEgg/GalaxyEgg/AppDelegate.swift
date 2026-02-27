

import UIKit


@main
class GalaxyEggAppDelegate: UIResponder, UIApplicationDelegate {
    
    var orientationLock: UIInterfaceOrientationMask = .portrait
    
    func application(_ GalaxyEggApplication: UIApplication, didFinishLaunchingWithOptions GalaxyEggLaunchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        true
    }
    
    func application(_ GalaxyEggApplication: UIApplication, configurationForConnecting GalaxyEggConnectingSceneSession: UISceneSession, options GalaxyEggConnectionOptions: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "GalaxyEggDefaultConfiguration", sessionRole: GalaxyEggConnectingSceneSession.role)
    }
    
    func application(_ GalaxyEggApplication: UIApplication, didDiscardSceneSessions GalaxyEggSceneSessions: Set<UISceneSession>) {
        // No-op for now.
    }
    
    func application(_ application: UIApplication,
                         supportedInterfaceOrientationsFor window: UIWindow?)
        -> UIInterfaceOrientationMask {
            return orientationLock
        }
}

struct OrientationManager {
    static func lock(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? GalaxyEggAppDelegate {
            delegate.orientationLock = orientation
            
            UINavigationController.attemptRotationToDeviceOrientation()

        }
    }

    static func lockAndRotate(_ orientation: UIInterfaceOrientationMask,
                              rotateTo: UIInterfaceOrientation) {

        lock(orientation)

        UIDevice.current.setValue(rotateTo.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}
