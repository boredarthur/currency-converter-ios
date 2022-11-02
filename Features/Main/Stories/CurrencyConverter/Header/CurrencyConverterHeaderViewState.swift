import Foundation

struct CurrencyConverterHeaderViewState: BaseViewState {
    var currencies: [CurrencyItemModel] = [CurrencyItemModel]()
    var currentCurrency: CurrencyProtocol?
    var dollars: CurrencyProtocol
    var euros: CurrencyProtocol
    var yens: CurrencyProtocol

    func mutate(
        currencies: [CurrencyItemModel]? = nil,
        currentCurrency: CurrencyProtocol? = nil,
        dollars: CurrencyProtocol? = nil,
        euros: CurrencyProtocol? = nil,
        yens: CurrencyProtocol? = nil
    ) -> CurrencyConverterHeaderViewState {
        return CurrencyConverterHeaderViewState(
            currencies: currencies ?? self.currencies,
            currentCurrency: currentCurrency ?? self.currentCurrency,
            dollars: dollars ?? self.dollars,
            euros: euros ?? self.euros,
            yens: yens ?? self.yens
        )
    }
}
