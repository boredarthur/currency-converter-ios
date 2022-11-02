import Foundation

protocol CurrencyConverterHeaderViewDelegate: AnyObject {
    func updateCurrentCurrency(with currency: CurrencyProtocol)
}
