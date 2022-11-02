import UIKit
import BonMot
import Stevia

class CurrencyConverterHeaderView: BaseView<CurrencyConverterHeaderViewState> {

    weak var delegate: CurrencyConverterHeaderViewDelegate?

    private let totalBalanceLabel = UILabel()
    private let totalBalanceValueLabel = UILabel()
    private let buttonControlsStackView = UIStackView()
    private let currencySelectionControl = UISegmentedControl(items: nil)
    private var padding: CGFloat = 20
    private var currentSymbol: String = Currency.usd.symbol {
        didSet {
            totalBalanceValueLabel.style(totalBalanceValueLabelStyle)
        }
    }

    private var currenciesModels = [CurrencyItemModel]() {
        didSet {
            currencySelectionControl.style(currencySelectionControlStyle)
        }
    }

    private var dollars = Currency.Usd(amount: 0)
    private var euros = Currency.Euro(amount: 0)
    private var yens = Currency.Yen(amount: 0)
    private var currentCurrency: CurrencyProtocol = Currency.Usd(amount: 0) {
        didSet {
            delegate?.updateCurrentCurrency(with: currentCurrency)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style(viewStyle)
        
        subviews(
            totalBalanceLabel.style(totalBalanceLabelStyle),
            totalBalanceValueLabel.style(totalBalanceValueLabelStyle),
            currencySelectionControl.style(currencySelectionControlStyle)
        )
        
        layout(
            0,
            |-padding-totalBalanceLabel-padding-|,
            20,
            |-padding-totalBalanceValueLabel-padding-|,
            (>=0),
            |-padding-currencySelectionControl.height(30)-padding-|,
            padding
        )
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated: animated)
        currencySelectionControl.selectedSegmentIndex = 0
    }
    
    override func render(state: CurrencyConverterHeaderViewState) {
        super.render(state: state)
        self.currenciesModels = state.currencies
        self.dollars = state.dollars as! Currency.Usd
        self.euros = state.euros as! Currency.Euro
        self.yens = state.yens as! Currency.Yen
        self.currentCurrency = state.currentCurrency ?? dollars
        currencySelectionControl.selectedSegmentIndex = Currency.allCases.first(where: { $0.symbol == self.currentCurrency.symbol })?.rawValue ?? 0
        totalBalanceValueLabel.style(totalBalanceValueLabelStyle)
    }
}

extension CurrencyConverterHeaderView {

    @objc private func didSelectCurrency(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentCurrency = self.dollars
        case 1:
            currentCurrency = self.euros
        case 2:
            currentCurrency = self.yens
        default:
            break
        }
        currentSymbol = Currency(rawValue: sender.selectedSegmentIndex)!.symbol
    }
}

// MARK: Styles

extension CurrencyConverterHeaderView {
    
    private func viewStyle(_ view: UIView) {
        view.backgroundColor = UIColor(named: "secondaryBackgroundColor")!
    }

    private func totalBalanceLabelStyle(_ view: UILabel) {
        view.text = "Balance"
        view.textColor = .white.withAlphaComponent(0.4)
        view.font = UIFont.regular(of: 14)
    }

    private func totalBalanceValueLabelStyle(_ view: UILabel) {
        view.text = "\(currentSymbol) \(String(format: "%.2f", currentCurrency.amount))"
        view.textColor = .white
        view.font = UIFont.regular(of: 62)
    }

    private func currencySelectionControlStyle(_ view: UISegmentedControl) {
        view.replaceSegments(with: currenciesModels)
        view.setTitleTextAttributes(StringStyle(.color(.white.withAlphaComponent(0.3))).attributes, for: .normal)
        view.setTitleTextAttributes(StringStyle(.color(.black.withAlphaComponent(0.8))).attributes, for: .selected)
        view.addTarget(self, action: #selector(didSelectCurrency(_:)), for: .valueChanged)
    }
}
