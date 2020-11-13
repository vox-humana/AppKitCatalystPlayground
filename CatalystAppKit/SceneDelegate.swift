import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //guard let scene = (scene as? UIWindowScene) else { return }
    }
}


class StatusBarSceneDelegate: UIResponder, UIWindowSceneDelegate {
    private let statusBarWindowSize = CGSize(width: 320, height: 240)
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        assert(scene.windows.count <= 1)

        scene.sizeRestrictions?.minimumSize = statusBarWindowSize
        scene.sizeRestrictions?.maximumSize = statusBarWindowSize

        let window = UIWindow(windowScene: scene)
        window.rootViewController = UIHostingController(rootView: ToolView())
        self.window = window
        //window.isHidden = true
        //window.makeKeyAndVisible()

        // NSWindow is not here yet
        // On Big Sur (11.0.1) single async dispatch is not enough
        DispatchQueue.main.async {
            DispatchQueue.main.async {
                guard let nsWindow = window.nsWindow else {
                    fatalError()
                }
                bridge?.showStatusBarWindow(window: XWindow(uiWindow: window, nsWindow: nsWindow))
            }
        }
    }
}
