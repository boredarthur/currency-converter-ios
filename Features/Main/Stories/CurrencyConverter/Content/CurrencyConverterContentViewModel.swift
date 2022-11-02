import Foundation
import Resolver
import Combine

class CurrencyConverterContentViewModel: BaseViewModel<CurrencyConverterContentViewIntent, CurrencyConverterContentViewState> {

    @Injected private var currencyFactory: CurrencyFactory
    @Injected private var currencyManager: CurrencyManager
    @Injected private var currencyConverterPrompt: CurrencyConverterPrompt
    @Injected private var userDefaultsManager: UserDefaultsManager

    private var cancellables = Set<AnyCancellable>()

    override func sendIntent(_ intent: CurrencyConverterContentViewIntent) {
        switch intent {
        case .initialize:
            initialize()
        case .haveNotSelectedDestionationSource:
            currencyConverterPrompt.showPromptHaveNotSelectedDestionationSource()
        case .destinationEqualsSource:
            currencyConverterPrompt.showPromptDestinationEqualsSource()
        case .emptyAmountField:
            currencyConverterPrompt.showPromptEmptyAmountField()
        case .invalidCharacters:
            currencyConverterPrompt.showPromptInvalidCharacter()
        case .notEnoughMoney:
            currencyConverterPrompt.showPromptNotEnoughMoney()
        case .exchange(let value, let currencyFrom, let currencyTo):
            Task { await invokeExchange(value: value, from: currencyFrom, to: currencyTo) }
        case .preview(let value, let currencyFrom, let currencyTo):
            Task { await invokePreview(value: value, from: currencyFrom, to: currencyTo) }
        case .showFeePopUp(let fee, let symbol):
            currencyConverterPrompt.showFeePopUp(fee: fee, symbol: symbol)
        }
    }
    
    private func initialize() {
        currencyFactory.getSupportedCurrencies().sink { [weak self] items in
            self?.updateState(state: CurrencyConverterContentViewState(
                currencies: items
            ))
        }.store(in: &cancellables)
        NotificationCenter.default.addObserver(self, selector: #selector(updatedSourceCurrency), name: Notification.Name("updatedSourceCurrency"), object: nil)
    }

    @objc private func updatedSourceCurrency() {
        currencyManager.getSourceCurrency().sink { [weak self] currency in
            if let currency = currency {
                self?.updateState(state: self?.state?.mutate(
                    sourceCurrency: currency,
                    fee: 0
                ))
            }
        }.store(in: &cancellables)
    }

    private func invokeExchange(value: Float, from: Currency, to: Currency) async {
        do {
            try await currencyManager.performExchange(value: value, from: from, to: to) { [weak self] fee in
                self?.updateState(state: self?.state?.mutate(
                    receivedAmount: 0,
                    fee: fee
                ))
                NotificationCenter.default.post(name: NSNotification.Name("exchangeSuccessful"), object: nil)
            }
        } catch {
            currencyConverterPrompt.showNetworkError()
        }
    }

    private func invokePreview(value: Float, from: Currency, to: Currency) async {
        do {
            try await currencyManager.getPreview(value: value, from: from, to: to) { [weak self] value in
                self?.updateState(state: self?.state?.mutate(
                    receivedAmount: value,
                    fee: 0
                ))
            }
        } catch {
            // Ignore for preview
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("updatedSourceCurrency"), object: nil)
    }
}
