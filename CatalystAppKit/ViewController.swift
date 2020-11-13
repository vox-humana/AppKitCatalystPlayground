import UIKit

class ViewController: UIViewController {
    
    @IBAction func newWindow(_ sender: Any) {
        UIApplication.shared.newWindow()
    }
 
    @IBAction func nsAlert(_ sender: Any) {
        bridge?.showAlert(title: "👋 UIKit")
    }
    
    @IBAction func nsPanel(_ sender: Any) {
        bridge?.showPanel()
    }
}

