import Foundation
import UIKit

class CurrencyConverterPrompt: BasePrompt {

    func showPromptHaveNotSelectedDestionationSource() {
        let alert = UIAlertController(
            title: "Incorrect destionation source",
            message: "Seems like you haven't selected destination source",
            preferredStyle: .alert
        )

        let submitAction = UIAlertAction(
            title: "OK",
            style: .default
        ) { _ in
            alert.dismiss(animated: true)
        }

        alert.addAction(submitAction)
        presentPrompt(alert)
    }

    func showPromptDestinationEqualsSource() {
        let alert = UIAlertController(
            title: "Incorrect destionation source",
            message: "You're destionation is the same as source. Choose another destination",
            preferredStyle: .alert
        )

        let submitAction = UIAlertAction(
            title: "OK",
            style: .default
        ) { _ in
            alert.dismiss(animated: true)
        }

        alert.addAction(submitAction)
        presentPrompt(alert)
    }

    func showPromptEmptyAmountField() {
        let alert = UIAlertController(
            title: "Incorrect amount",
            message: "Seems like you left amount field empty. Try to fill it in",
            preferredStyle: .alert
        )

        let submitAction = UIAlertAction(
            title: "OK",
            style: .default
        ) { _ in
            alert.dismiss(animated: true)
        }

        alert.addAction(submitAction)
        presentPrompt(alert)
    }

    func showPromptInvalidCharacter() {
        let alert = UIAlertController(
            title: "Invalid characters",
            message: "You need to fill in only digits",
            preferredStyle: .alert
        )

        let submitAction = UIAlertAction(
            title: "OK",
            style: .default
        ) { _ in
            alert.dismiss(animated: true)
        }

        alert.addAction(submitAction)
        presentPrompt(alert)
    }

    func showPromptNotEnoughMoney() {
        let alert = UIAlertController(
            title: "Not enough money",
            message: "You do not have enough money on your account. Please, decrease the amount or try another currency.",
            preferredStyle: .alert
        )

        let submitAction = UIAlertAction(
            title: "OK",
            style: .default
        ) { _ in
            alert.dismiss(animated: true)
        }

        alert.addAction(submitAction)
        presentPrompt(alert)
    }

    func showNetworkError() {
        let alert = UIAlertController(
            title: "Network error",
            message: "We couldn't proceed the exchange. Try again later",
            preferredStyle: .alert
        )

        let submitAction = UIAlertAction(
            title: "OK",
            style: .default
        ) { _ in
            alert.dismiss(animated: true)
        }

        alert.addAction(submitAction)
        presentPrompt(alert)
    }

    func showFeePopUp(fee: Float, symbol: String) {
        let alert = UIAlertController(
            title: "Fee",
            message: "Fee for transaction: \(symbol) \(String(format: "%.2f", fee))",
            preferredStyle: .alert
        )

        let submitAction = UIAlertAction(
            title: "OK",
            style: .default
        ) { _ in
            alert.dismiss(animated: true)
        }

        alert.addAction(submitAction)
        presentPrompt(alert)
    }
}
