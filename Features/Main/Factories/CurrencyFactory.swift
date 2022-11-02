import Foundation
import UIKit
import Combine

class CurrencyFactory {

    func getSupportedCurrencies() -> AnyPublisher<[CurrencyItemModel], Never> {
        let items = Currency.allCases.compactMap { currency in
            return CurrencyItemModel(
                image: UIImage(systemName: currency.iconName)!
            )
        }
        return Just(items).eraseToAnyPublisher()
    }
}
