

import UIKit
import AppTrackingTransparency

class GalaxyEggSceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private var GalaxyEggWindowStorage: UIWindow?
    
    var window: UIWindow? {
        get { GalaxyEggWindowStorage }
        set { GalaxyEggWindowStorage = newValue }
    }
    
    func scene(_ GalaxyEggScene: UIScene, willConnectTo GalaxyEggSession: UISceneSession, options GalaxyEggConnectionOptions: UIScene.ConnectionOptions) {
        guard let GalaxyEggWindowScene = GalaxyEggScene as? UIWindowScene else { return }
        let GalaxyEggWindow = UIWindow(windowScene: GalaxyEggWindowScene)
//        GalaxyEggWindow.rootViewController = GXUNavigationController(rootViewController:GalaxyEggMainMenuViewController())
        GalaxyEggWindow.rootViewController = GalaxyEggMainMenuViewController()

        GalaxyEggWindow.makeKeyAndVisible()
        GalaxyEggWindow.overrideUserInterfaceStyle = .dark
        self.GalaxyEggWindowStorage = GalaxyEggWindow
    }
    
    func sceneDidBecomeActive(_ GalaxyEggScene: UIScene) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ATTrackingManager.requestTrackingAuthorization {_ in }
        }
    }
    
    func sceneWillResignActive(_ GalaxyEggScene: UIScene) {}
    
    func sceneWillEnterForeground(_ GalaxyEggScene: UIScene) {}
    
    func sceneDidEnterBackground(_ GalaxyEggScene: UIScene) {}
}
