import Foundation

enum CurrencyConverterContentViewIntent: BaseViewIntent {
    case initialize
    case haveNotSelectedDestionationSource
    case destinationEqualsSource
    case emptyAmountField
    case invalidCharacters
    case notEnoughMoney
    case exchange(value: Float, currencyFrom: Currency, currencyTo: Currency)
    case preview(value: Float, currencyFrom: Currency, currencyTo: Currency)
    case showFeePopUp(fee: Float, symbol: String)
}
