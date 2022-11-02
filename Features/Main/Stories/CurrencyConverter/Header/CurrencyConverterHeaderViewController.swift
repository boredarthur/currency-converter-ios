import UIKit

class CurrencyConverterHeaderViewController: BaseViewController<CurrencyConverterHeaderView, CurrencyConverterHeaderViewIntent,
                                             CurrencyConverterHeaderViewState, CurrencyConverterHeaderViewModel> {
    
    var configuration: CurrencyConverterHeaderConfiguration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        viewModel.sendIntent(.initialize(
            configuration.dollars,
            configuration.euros,
            configuration.yens
        ))
        getView().delegate = self
    }
}

extension CurrencyConverterHeaderViewController: CurrencyConverterHeaderViewDelegate {

    func updateCurrentCurrency(with currency: CurrencyProtocol) {
        viewModel.sendIntent(.updateCurrentCurrency(currency: currency))
    }
}
