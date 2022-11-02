import Foundation

enum CurrencyConverterHeaderViewIntent: BaseViewIntent {
    case initialize(
        _ dollars: Currency.Usd,
        _ euros: Currency.Euro,
        _ yens: Currency.Yen
    )
    case updateCurrentCurrency(currency: CurrencyProtocol)
}
