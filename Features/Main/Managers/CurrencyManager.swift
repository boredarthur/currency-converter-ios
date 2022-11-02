import Foundation
import Resolver
import Combine

class CurrencyManager {

    @Injected private var mainApiClient: MainApiClient
    @Injected private var userDefaultsManager: UserDefaultsManager

    private var sourceCurrency: CurrencyProtocol? = nil

    func getSourceCurrency() -> AnyPublisher<CurrencyProtocol?, Never> {
        if let currency = sourceCurrency {
            return Just(currency).eraseToAnyPublisher()
        }
        return Just(nil).eraseToAnyPublisher()
    }

    func updateSourceCurrency(with currency: CurrencyProtocol) {
        self.sourceCurrency = currency
        NotificationCenter.default.post(name: NSNotification.Name("updatedSourceCurrency"), object: nil)
    }

    func performExchange(
        value: Float,
        from currencyFrom: Currency,
        to currencyTo: Currency,
        completion: ((Float) -> Void)? = nil
    ) async throws {
        let apiCurrency = try await mainApiClient.performExchange(value: value, from: currencyFrom, to: currencyTo).async()
        guard let amount = apiCurrency.amount?.floatValue else { return }
        let storedAmountTo = userDefaultsManager.getValue(for: currencyTo.key)
        let storedAmountFrom = userDefaultsManager.getValue(for: currencyFrom.key)
        let fee = userDefaultsManager.getAmountOfTransactions() < 5 ? 0 : (value / 100) * 5
        userDefaultsManager.setAmount(storedAmountTo + amount, for: currencyTo.key)
        userDefaultsManager.setAmount(storedAmountFrom - value - fee, for: currencyFrom.key)
        userDefaultsManager.increateAmountOfTransactions()
        completion?(fee)
    }

    func getPreview(
        value: Float,
        from currencyFrom: Currency,
        to currencyTo: Currency,
        completion: ((Float) -> Void)? = nil
    ) async throws {
        let apiCurrency = try await mainApiClient.previewExchange(value: value, from: currencyFrom, to: currencyTo).async()
        guard let amount = apiCurrency.amount?.floatValue else { return }
        completion?(amount)
    }

    func fetchAllCurrencies() -> [CurrencyProtocol] {
        return Currency.allCases.map {
            let amount = userDefaultsManager.getValue(for: $0.key)
            switch $0 {
            case .usd:
                return Currency.Usd(amount: amount)
            case .eur:
                return Currency.Euro(amount: amount)
            case .yen:
                return Currency.Yen(amount: amount)
            }
        }
    }
}
