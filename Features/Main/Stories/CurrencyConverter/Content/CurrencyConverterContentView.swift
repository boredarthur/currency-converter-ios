import UIKit
import Stevia
import BonMot

class CurrencyConverterContentView: BaseView<CurrencyConverterContentViewState>, CollapsingChildView {

    weak var scrollDelegate: UIScrollViewDelegate?
    weak var delegate: CurrencyConverterContentViewDelegate?

    private let scrollView = UIScrollView()
    private let scrollContentView = UIView()
    private let destinationLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let destinationSegmentedControl = UISegmentedControl(items: nil)
    private let amountToChangeLabel = UILabel()
    private let prefixTextFieldLabel = UILabel()
    private let sourceCurrencyTextField = UITextField()
    private let receiveLabel = UILabel()
    private let exchangeButton = BaseButton()

    private var currenciesModels = [CurrencyItemModel]() {
        didSet {
            destinationSegmentedControl.style(destinationSegmentedControlStyle)
            amountToChangeLabel.style(amountToChangeLabelStyle)
        }
    }

    private var sourceCurrency: CurrencyProtocol? {
        didSet {
            prefixTextFieldLabel.style(prefixTextFieldLabelStyle)
            sourceCurrencyTextField.style(sourceCurrencyTextFieldStyle)
        }
    }
    private var destinationSource: Currency? = nil
    private var storedSegment: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        style(viewStyle)
        
        subviews(
            scrollView.style(scrollViewStyle).subviews(
                scrollContentView.subviews(
                    destinationLabel.style(destinationLabelStyle),
                    descriptionLabel.style(descriptionLabelStyle),
                    destinationSegmentedControl.style(destinationSegmentedControlStyle),
                    amountToChangeLabel.style(amountToChangeLabelStyle),
                    sourceCurrencyTextField.style(sourceCurrencyTextFieldStyle),
                    receiveLabel.style(receiveLabelStyle),
                    exchangeButton.style(exchangeButtonStyle)
                )
            )
        )

        scrollView.fillContainer()
        scrollContentView.fillContainer()
        scrollContentView.Width == scrollView.Width


        scrollContentView.layout(
            25,
            |-25-destinationLabel-25-|,
            25,
            |-25-descriptionLabel-25-|,
            25,
            |-25-destinationSegmentedControl.height(30)-25-|,
            25,
            |-25-amountToChangeLabel-25-|,
            25,
            |-25-sourceCurrencyTextField.height(48)-25-|,
            25,
            |-25-receiveLabel-25-|,
            25,
            |-25-exchangeButton.height(48)-25-|,
            (>=0)
        )
    }
    
    override func render(state: CurrencyConverterContentViewState) {
        super.render(state: state)

        if let currency = state.sourceCurrency {
            self.sourceCurrency = currency
        }

        self.currenciesModels = state.currencies

        if let storedSegment = self.storedSegment {
            destinationSegmentedControl.selectedSegmentIndex = storedSegment
        }

        if let receivedAmount = state.receivedAmount {
            receiveLabel.text = "+ \(receivedAmount)\(destinationSource?.symbol ?? "$")"
        }

        if let fee = state.fee, fee > 0 {
            delegate?.showFeePopUp(fee: fee, symbol: sourceCurrency?.symbol ?? "?")
        }
    }

    override func handleKeyboardChanges(keyboardHeight: CGFloat, duration: TimeInterval) {
        let bottomMargin = getBottomMargins(keyboardHeight: keyboardHeight)

        scrollView.contentInset.bottom = bottomMargin
        exchangeButton.bottomConstraint?.constant = -bottomMargin
        
        layoutIfNeeded()
    }
}

extension CurrencyConverterContentView {

    @objc private func destinationSourceChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: destinationSource = Currency.usd
        case 1: destinationSource = Currency.eur
        case 2: destinationSource = Currency.yen
        default: break
        }
    }

    @objc private func exchange() {
        // Validate destionation
        guard destinationSegmentedControl.selectedSegmentIndex != -1 else {
            delegate?.haveNotSelectedDestinationSource()
            return
        }
        guard Currency(rawValue: destinationSegmentedControl.selectedSegmentIndex)?.symbol != sourceCurrency?.symbol else {
            delegate?.destinationEqualsSource()
            return
        }

        // Validate input
        guard let text = sourceCurrencyTextField.text else { return }
        guard !text.isEmpty else {
            delegate?.emptyAmountField()
            return
        }
        guard text.isNumeric else {
            delegate?.invalidCharacters()
            return
        }

        // Validate amount
        let amount = Float(text)
        guard let source = sourceCurrency, let amount = amount else { return }
        guard !(amount > source.amount) && !(amount + ((amount / 100) * 5) > source.amount) else {
            delegate?.notEnoughMoney()
            return
        }
        receiveLabel.text = ""
        delegate?.exchange(
            value: amount,
            fromCurrency: Currency.allCases.first(where: {
                $0.symbol == sourceCurrency?.symbol
            })!,
            toCurrency: destinationSource!
        )
        endEditing(true)
        sourceCurrencyTextField.text = ""
    }

    @objc private func preview() {
        // Validate destionation
        guard destinationSegmentedControl.selectedSegmentIndex != -1 else { return}
        guard Currency(rawValue: destinationSegmentedControl.selectedSegmentIndex)?.symbol != sourceCurrency?.symbol else { return }

        // Validate input
        guard let text = sourceCurrencyTextField.text else { return }
        guard !text.isEmpty else {
            receiveLabel.text = ""
            return
        }
        guard text.isNumeric else { return }

        // Validate amount
        let amount = Float(text)
        guard let source = sourceCurrency, let amount = amount else { return }
        guard !(amount > source.amount) else { return }
        self.storedSegment = destinationSegmentedControl.selectedSegmentIndex
        delegate?.preview(
            value: amount,
            fromCurrency: Currency.allCases.first(where: {
                $0.symbol == sourceCurrency?.symbol
            })!,
            toCurrency: destinationSource!
        )
    }
}

extension CurrencyConverterContentView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            scrollDelegate?.scrollViewDidScroll?(scrollView)
        }
    }
}

extension CurrencyConverterContentView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return !(string == " ")
    }
}

// MARK: Styles

extension CurrencyConverterContentView {
    
    private func viewStyle(_ view: UIView) {
        view.backgroundColor = .white
    }

    private func scrollViewStyle(_ view: UIScrollView) {
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = true
        view.backgroundColor = .clear
        view.delegate = self
    }

    private func destinationLabelStyle(_ view: UILabel) {
        view.text = "Select a destination source"
        view.textColor = .black.withAlphaComponent(0.8)
        view.font = UIFont.bold(of: 24)
        view.textAlignment = .center
    }

    private func descriptionLabelStyle(_ view: UILabel) {
        view.text = "Please, select desired destination source and enter the amount you want to exchange"
        view.textColor = .black.withAlphaComponent(0.8)
        view.font = UIFont.regular(of: 16)
        view.textAlignment = .center
        view.numberOfLines = 0
    }

    private func destinationSegmentedControlStyle(_ view: UISegmentedControl) {
        view.replaceSegments(with: currenciesModels)
        view.setTitleTextAttributes(StringStyle(.color(.black.withAlphaComponent(0.3))).attributes, for: .normal)
        view.setTitleTextAttributes(StringStyle(.color(.black)).attributes, for: .selected)
        view.addTarget(self, action: #selector(destinationSourceChanged(_:)), for: .valueChanged)
    }

    private func amountToChangeLabelStyle(_ view: UILabel) {
        if let symbol = sourceCurrency?.symbol {
            view.text = "Now, enter the amount of \(symbol) you want to exchange"
        }
        view.textColor = .black.withAlphaComponent(0.8)
        view.font = UIFont.regular(of: 16)
        view.textAlignment = .center
        view.numberOfLines = 0
    }

    private func sourceCurrencyTextFieldStyle(_ view: UITextField) {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.layer.cornerRadius = 15
        view.textColor = .black
        view.keyboardType = .numbersAndPunctuation
        view.leftView = prefixTextFieldLabel.style(prefixTextFieldLabelStyle)
        view.leftViewMode = .always
        view.layer.sublayerTransform = CATransform3DMakeTranslation(15, 0, 15)
        view.addTarget(self, action: #selector(preview), for: .editingChanged)
        view.delegate = self
    }
    
    private func prefixTextFieldLabelStyle(_ view: UILabel) {
        view.text = (sourceCurrency?.symbol ?? "") + " "
        view.width(20)
        view.font = UIFont.bold(of: 16)
        view.textColor = .black
    }

    private func receiveLabelStyle(_ view: UILabel) {
        view.font = UIFont.bold(of: 16)
        view.textAlignment = .center
        view.textColor = .black
    }

    private func exchangeButtonStyle(_ view: BaseButton) {
        view.setTitle("Exchange", for: .normal)
        view.setTitleColor(.white.withAlphaComponent(0.8), for: .normal)
        view.backgroundColor = .black
        view.layer.cornerRadius = 15
        view.addTarget(self, action: #selector(exchange), for: .touchUpInside)
    }
}
