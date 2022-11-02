import UIKit

class BasePrompt {

    func presentPrompt(
        _ controller: UIViewController,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        UIViewController.topmost().present(
            controller,
            animated: animated,
            completion: completion
        )
    }
}
