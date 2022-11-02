import UIKit

extension UIApplication {

    public var rootWindow: UIWindow? {
        get {
            return (UIApplication.shared.connectedScenes.first?.delegate as? UIWindowSceneDelegate)?.window ?? nil
        }
    }

    class func isFirstLaunch() -> Bool {
        if !UserDefaults.standard.bool(forKey: "hasBeenLaunchedBeforeFlag") {
            UserDefaults.standard.set(true, forKey: "hasBeenLaunchedBeforeFlag")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
}
