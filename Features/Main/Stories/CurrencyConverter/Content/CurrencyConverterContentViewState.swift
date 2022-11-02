import Foundation

struct CurrencyConverterContentViewState: BaseViewState {
    var currencies: [CurrencyItemModel] = [CurrencyItemModel]()
    var sourceCurrency: CurrencyProtocol? = nil
    var receivedAmount: Float? = nil
    var fee: Float? = nil

    func mutate(
        currencies: [CurrencyItemModel]? = nil,
        sourceCurrency: CurrencyProtocol? = nil,
        receivedAmount: Float? = nil,
        fee: Float? = nil
    ) -> CurrencyConverterContentViewState {
        return CurrencyConverterContentViewState(
            currencies: currencies ?? self.currencies,
            sourceCurrency: sourceCurrency ?? self.sourceCurrency,
            receivedAmount: receivedAmount ?? self.receivedAmount,
            fee: fee ?? self.fee
        )
    }
}
