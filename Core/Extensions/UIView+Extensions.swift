import UIKit

extension UIView{

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.dismissKeyboard))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
        
    @objc func dismissKeyboard() {
        endEditing(true)
    }
}
