import Foundation

final class XWindow: NSObject {
    let uiWindow: AnyObject
    let nsWindow: AnyObject

    init(uiWindow: AnyObject, nsWindow: AnyObject) {
        self.uiWindow = uiWindow
        self.nsWindow = nsWindow
    }
}

@objc(StatusBarBridgeDelegate)
protocol StatusBarBridgeDelegate: NSObjectProtocol {
    func createStatusBarWindow() // expects that `showStatusBarWindow` will be called
    func willCloseStatusBarWindow(window: XWindow)
}

@objc(StatusBarBridge)
protocol StatusBarBridge: NSObjectProtocol {
    weak var statusBarDelegate: StatusBarBridgeDelegate? { get set }
    func showStatusBarWindow(window: XWindow)
}

@objc(AlertBridge)
protocol AlertBridge: NSObjectProtocol {
    func showAlert(title: String)
    func showPanel()
}

@objc(AppKitBridge)
protocol AppKitBridge: StatusBarBridge, AlertBridge {
    init()
}
