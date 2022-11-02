import UIKit

extension UIViewController {
    
    class func topmost() -> UIViewController {
        guard let rootViewController = UIApplication.shared.rootWindow?.rootViewController else {
            return UIViewController()
        }
        return rootViewController
    }
}
