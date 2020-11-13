import UIKit

var bridge: AppKitBridge?
fileprivate let statusBarSceneId = "StatusBar"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        loadPlugin()
        return true
    }

    private func loadPlugin() {
        let bundleFileName = "AppKitPlugin.bundle"
        guard
            let bundleURL = Bundle.main.builtInPlugInsURL?.appendingPathComponent(bundleFileName)
        else {
            return
        }

        guard let bundle = Bundle(url: bundleURL) else { return }

        guard let bridgeClass = bundle.principalClass as? AppKitBridge.Type else {
            fatalError()
        }
        
        bridge = bridgeClass.init()
        bridge?.statusBarDelegate = self
    }
}

// MARK: UISceneSession Lifecycle
extension AppDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        guard options.userActivities.first?.activityType == statusBarSceneId else {
            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        }
        
        // Need to use separate configuration
        let configuration = UISceneConfiguration(name: "StatusBar Configuration", sessionRole: connectingSceneSession.role)
        configuration.delegateClass = StatusBarSceneDelegate.self
        return configuration
    }
}


// MARK: UISceneSession Lifecycle
extension AppDelegate: StatusBarBridgeDelegate {
    func createStatusBarWindow() {
        UIApplication.shared.newWindow()
    }
    
    func willCloseStatusBarWindow(window: XWindow) {
        let uiWindow = window.uiWindow as! UIWindow
        print("Closing... Should save the state...", uiWindow)
    }
}

// MARK: NSMenu actions
extension AppDelegate {
    @objc func showAlertFromMenu() {
        bridge?.showAlert(title: "👋 UIKit")
    }
}

// MARK: Create new window
extension UIApplication {
    func newWindow() {
        // Seems like the only way to present truly separate window from UIKit is to use UIScene
        // https://stackoverflow.com/questions/58882047/open-a-new-window-in-mac-catalyst
        let activity = NSUserActivity(activityType: statusBarSceneId)
        requestSceneSessionActivation(nil, userActivity: activity, options: nil) { (error) in
            print(error)
        }
    }
}
