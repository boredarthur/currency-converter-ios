import UIKit

extension UIView {

    var deviceSafeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }

    func getBottomMargins(
        keyboardHeight: CGFloat = 0
    ) -> CGFloat {
        let isKeyboardVisible = keyboardHeight > 0
        var bottomMargin: CGFloat = isKeyboardVisible ? 20 : 10

        let bottomInset = isKeyboardVisible ? keyboardHeight : deviceSafeAreaInsets.bottom
        return bottomMargin + bottomInset
    }
}
