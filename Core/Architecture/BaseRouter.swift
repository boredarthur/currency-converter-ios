import UIKit

class BaseRouter {

    func show(_ controller: UIViewController) {
        DispatchQueue.main.async {
            UIViewController.topmost().show(controller, sender: nil)
        }
    }
}
