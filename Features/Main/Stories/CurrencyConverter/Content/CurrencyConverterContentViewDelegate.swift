import Foundation

protocol CurrencyConverterContentViewDelegate: AnyObject {
    func haveNotSelectedDestinationSource()
    func destinationEqualsSource()
    func emptyAmountField()
    func invalidCharacters()
    func notEnoughMoney()
    func exchange(value: Float, fromCurrency: Currency, toCurrency: Currency)
    func preview(value: Float, fromCurrency: Currency, toCurrency: Currency)
    func showFeePopUp(fee: Float, symbol: String)
}
