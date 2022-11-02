import UIKit

class CurrencyConverterController: CollapsingViewController {

    var configuration: CurrencyConverterConfiguration!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure(
            headerHeight: 250,
            headerController: initializeHeader(),
            contentController: initializeContent()
        )
    }

    private func initializeHeader() -> UIViewController {
        let controller = CurrencyConverterHeaderViewController()
        controller.configuration = CurrencyConverterHeaderConfiguration(
            dollars: configuration.dollars,
            euros: configuration.euros,
            yens: configuration.yens
        )
        return controller
    }

    private func initializeContent() -> UIViewController {
        let controller = CurrencyConverterContentViewController()
        return controller
    }
}
