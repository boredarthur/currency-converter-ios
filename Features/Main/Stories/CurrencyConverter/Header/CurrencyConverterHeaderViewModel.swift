import Foundation
import Combine
import Resolver

class CurrencyConverterHeaderViewModel: BaseViewModel<CurrencyConverterHeaderViewIntent, CurrencyConverterHeaderViewState> {

    @Injected private var currencyFactory: CurrencyFactory
    @Injected private var currencyManager: CurrencyManager

    private var cancellables = Set<AnyCancellable>()
    private var currentCurrency: CurrencyProtocol?

    override func sendIntent(_ intent: CurrencyConverterHeaderViewIntent) {
        switch intent {
        case .initialize(let dollars, let euros, let yens):
            initialize(dollars, euros, yens)
        case .updateCurrentCurrency(let currency):
            self.currentCurrency = currency
            currencyManager.updateSourceCurrency(with: currency)
        }
    }
    
    private func initialize(
        _ dollars: Currency.Usd,
        _ euros: Currency.Euro,
        _ yens: Currency.Yen
    ) {
        currencyFactory.getSupportedCurrencies().sink { [weak self] items in
            self?.updateState(state: CurrencyConverterHeaderViewState(
                currencies: items,
                dollars: dollars,
                euros: euros,
                yens: yens
            ))
        }.store(in: &cancellables)
        NotificationCenter.default.addObserver(self, selector: #selector(exchanged), name: Notification.Name("exchangeSuccessful"), object: nil)
    }

    @objc private func exchanged() {
        let fetched = currencyManager.fetchAllCurrencies()
        let currency = fetched.first(where: {
            $0.symbol == self.currentCurrency?.symbol
        })
        self.updateState(state: self.state?.mutate(
            currentCurrency: currency,
            dollars: fetched[0] as! Currency.Usd,
            euros: fetched[1] as! Currency.Euro,
            yens: fetched[2] as! Currency.Yen
        ))
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("exchangeSuccessful"), object: nil)
    }
}
