import Foundation
import UIKit

class BaseStatelessView: UIView {

    required override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func viewDidLoad() {
        calculateDimensions()
    }

    func viewDidAppear(animated: Bool) { }

    func viewWillAppear(animated: Bool) { }

    func viewWillDisappear(animated: Bool) { }

    func calculateDimensions() { }

    func handleKeyboardChanges(keyboardHeight: CGFloat, duration: TimeInterval) { }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
