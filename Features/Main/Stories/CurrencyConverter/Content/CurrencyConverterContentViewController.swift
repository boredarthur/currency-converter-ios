import UIKit

class CurrencyConverterContentViewController: BaseViewController<CurrencyConverterContentView, CurrencyConverterContentViewIntent,
                                              CurrencyConverterContentViewState, CurrencyConverterContentViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        viewModel.sendIntent(.initialize)
        getView().delegate = self
    }
}

extension CurrencyConverterContentViewController: CurrencyConverterContentViewDelegate {

    func haveNotSelectedDestinationSource() {
        viewModel.sendIntent(.haveNotSelectedDestionationSource)
    }

    func destinationEqualsSource() {
        viewModel.sendIntent(.destinationEqualsSource)
    }

    func emptyAmountField() {
        viewModel.sendIntent(.emptyAmountField)
    }

    func invalidCharacters() {
        viewModel.sendIntent(.invalidCharacters)
    }

    func notEnoughMoney() {
        viewModel.sendIntent(.notEnoughMoney)
    }

    func exchange(value: Float, fromCurrency: Currency, toCurrency: Currency) {
        viewModel.sendIntent(.exchange(value: value, currencyFrom: fromCurrency, currencyTo: toCurrency))
    }

    func preview(value: Float, fromCurrency: Currency, toCurrency: Currency) {
        viewModel.sendIntent(.preview(value: value, currencyFrom: fromCurrency, currencyTo: toCurrency))
    }

    func showFeePopUp(fee: Float, symbol: String) {
        viewModel.sendIntent(.showFeePopUp(fee: fee, symbol: symbol))
    }
}
