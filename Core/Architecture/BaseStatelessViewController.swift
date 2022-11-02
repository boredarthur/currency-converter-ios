import Foundation
import UIKit

class BaseStatlessViewController<V: BaseStatelessView>: UIViewController {

    var controllerSubscribesKeyboardEvents: Bool {
        return true
    }

    private var currentStatusBarStyle = UIStatusBarStyle.default

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return currentStatusBarStyle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getView().viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if controllerSubscribesKeyboardEvents {
            subscribeKeyboardShowingEvents()
        }

        getView().viewWillAppear(animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getView().viewDidAppear(animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        getView().viewWillDisappear(animated: animated)

        if !isBeingDismissed && navigationController?.isBeingDismissed == false {
            NotificationCenter.default.removeObserver(
                self,
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
            NotificationCenter.default.removeObserver(
                self,
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
        }
    }

    override func loadView() {
        self.view = V.init(frame: UIScreen.main.bounds)
    }

    func getView() -> V {
        return self.view as? V ?? V.init()
    }

    private func subscribeKeyboardShowingEvents() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeInteracted),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillBeInteracted),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillBeInteracted(_ notification: Notification) {
        if
            let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        {
            let willKeyboardHide = notification.name == UIResponder.keyboardWillHideNotification
            getView().handleKeyboardChanges(
                keyboardHeight: willKeyboardHide ? 0 : keyboardFrame.cgRectValue.height,
                duration: duration
            )
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
}
