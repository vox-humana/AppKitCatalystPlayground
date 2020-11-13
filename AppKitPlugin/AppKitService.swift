import Cocoa

struct Popover {
    let uiWindow: AnyObject
    let nsWindow: NSWindow
    let globalEventsMonitor: Any
    
    init?(window: XWindow, eventHandler block: @escaping (NSEvent) -> Void) {
        self.uiWindow = window.uiWindow
        guard let nsWindow = window.nsWindow as? NSWindow else {
            return nil
        }
        self.nsWindow = nsWindow
        guard let monitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.leftMouseUp, .leftMouseDown],
            handler: block
        ) else {
            return nil
        }
        self.globalEventsMonitor = monitor
    }
}

extension XWindow {
    convenience init(popover: Popover) {
        self.init(uiWindow: popover.uiWindow, nsWindow: popover.nsWindow)
    }
}

class AppKitService: NSObject, AppKitBridge {
    var statusBarDelegate: StatusBarBridgeDelegate?
    
    private let statusItem: NSStatusItem = {
        let statusBar = NSStatusBar.system
        let statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.button?.title = "App"
        return statusItem
    }()
    
    private lazy var statusMenu: NSMenu = {
        let rightClickMenu = NSMenu()
        // Should be registered in Responder chain
        // https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/MenuList/Articles/EnablingMenuItems.html
        rightClickMenu.addItem(
            NSMenuItem(
                title: NSLocalizedString("Show alert", comment: ""),
                action: NSSelectorFromString("showAlertFromMenu"),
                keyEquivalent: ""
            )
        )
        rightClickMenu.addItem(
            NSMenuItem(
                title: NSLocalizedString("Quit", comment: ""),
                action: #selector(NSApplication.terminate(_:)),
                keyEquivalent: "q"
            )
        )
        return rightClickMenu
    }()
    
    private var popover: Popover?
    
    required override init() {
        super.init()
        statusItem.button?.target = self
        statusItem.button?.action = #selector(showPopover)
        let options: NSEvent.EventTypeMask = [.leftMouseUp, .rightMouseUp]
        statusItem.button?.sendAction(on: options)
    }
    
    func showStatusBarWindow(window: XWindow) {
        guard let popover = Popover(window: window, eventHandler: { [weak self] _ in
            self?.hidePopover()
        })
        else {
            assertionFailure("Cannot create Popover")
            return
        }
        self.popover = popover
        
        let nsWindow = popover.nsWindow
        nsWindow.level = .modalPanel
        nsWindow.styleMask.remove(.titled)
        
        popover.nsWindow.updateFrame(for: statusItem)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onClose(notification:)),
            name: NSWindow.willCloseNotification,
            object: popover.nsWindow
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onResignKey(notification:)),
            name: NSWindow.didResignKeyNotification,
            object: popover.nsWindow
        )
    }
    
    @objc private func showPopover(sender: NSStatusBarButton) {
        switch NSApp.currentEvent!.type {
        case .rightMouseUp:
            statusItem.menu = statusMenu
            statusItem.button?.performClick(nil)
            statusItem.menu = nil
        default:
            if popover == nil {
                statusBarDelegate?.createStatusBarWindow()
            } else {
                hidePopover()
            }
        }
    }
    
    private func hidePopover() {
        guard let popover = popover else {
            return
        }
        statusBarDelegate?.willCloseStatusBarWindow(window: XWindow(popover: popover))
        popover.nsWindow.close()
        
        self.popover = nil
    }
    
    @objc private func onClose(notification: Notification) {
        guard let window = notification.object as? NSWindow else {
            assertionFailure("Unknown notification format \(notification)")
            return
        }
        guard window == popover?.nsWindow else {
            return
        }
        
        self.popover = nil
    }
    
    @objc private func onResignKey(notification: Notification) {
        guard let window = notification.object as? NSWindow else {
            assertionFailure("Unknown notification format \(notification)")
            return
        }
        guard window == popover?.nsWindow else {
            return
        }
        hidePopover()
    }
}

extension AppKitService: AlertBridge {
    func showAlert(title: String) {
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = title
        alert.informativeText = "NSAlert"
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    func showPanel() {
        let bundle = Bundle(for: AppKitService.self)
        let path = bundle.path(forResource: "Panel", ofType: "nib")!
        let wc = NSWindowController(windowNibPath: path, owner: self)
        wc.showWindow(nil)
    }
}

extension NSWindow {
    func updateFrame(for statusItem: NSStatusItem) {
        let origin = NSPoint(x: statusItem.button!.frame.minX, y: statusItem.button!.frame.maxY)
        let screenOrigin = statusItem.button!.window!.convertPoint(toScreen: origin)
        let frameOrigin = NSPoint(x: screenOrigin.x, y: screenOrigin.y - frame.size.height)
        let frame = NSRect(origin: frameOrigin, size: self.frame.size)
        setFrame(frame, display: true)
    }
}
