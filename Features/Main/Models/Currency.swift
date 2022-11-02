import Foundation

protocol CurrencyProtocol: AnyObject {
    var amount: Float { get set }
    var symbol: String { get }
}

enum Currency: Int, CaseIterable {
    case usd = 0
    case eur = 1
    case yen = 2

    var iconName: String {
        switch self {
        case .usd:
            return Usd.iconName
        case .eur:
            return Euro.iconName
        case .yen:
            return Yen.iconName
        }
    }

    var symbol: String {
        switch self {
        case .usd:
            return Usd().symbol
        case .eur:
            return Euro().symbol
        case .yen:
            return Yen().symbol
        }
    }

    var description: String {
        switch self {
        case .usd:
            return "USD"
        case .eur:
            return "EUR"
        case .yen:
            return "JPY"
        }
    }

    var key: String {
        switch self {
        case .usd:
            return "dollarsAmount"
        case .eur:
            return "eurosAmount"
        case .yen:
            return "yensAmount"
        }
    }

    class Usd: CurrencyProtocol {
        var amount: Float = 0
        let symbol: String = "$"
        static let iconName: String = "dollarsign"

        init(amount: Float = 0) { self.amount = amount }
    }

    class Euro: CurrencyProtocol {
        var amount: Float = 0
        let symbol: String = "€"
        static let iconName: String = "eurosign"

        init(amount: Float = 0) { self.amount = amount }
    }

    class Yen: CurrencyProtocol {
        var amount: Float = 0
        let symbol: String = "¥"
        static let iconName: String = "yensign"

        init(amount: Float = 0) { self.amount = amount }
    }
}
