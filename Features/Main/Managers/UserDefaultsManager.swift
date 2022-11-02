import Foundation

class UserDefaultsManager {

    func setDollarsAmount(_ value: Float) {
        UserDefaults.standard.set(value, forKey: "dollarsAmount")
        UserDefaults.standard.synchronize()
    }

    func setEurosAmount(_ value: Float) {
        UserDefaults.standard.set(value, forKey: "eurosAmount")
        UserDefaults.standard.synchronize()
    }

    func setYensAmount(_ value: Float) {
        UserDefaults.standard.set(value, forKey: "yensAmount")
        UserDefaults.standard.synchronize()
    }

    func setAmount(_ value: Float, for key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    func setAmount(_ value: Int, for key: String) {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    func getAmountOfTransactions() -> Int {
        return UserDefaults.standard.integer(forKey: "amountOfTransactions")
    }

    func increateAmountOfTransactions() {
        let amountOfTransactions = getAmountOfTransactions()
        setAmount(amountOfTransactions + 1, for: "amountOfTransactions")
    }

    func getValue(for key: String) -> Float {
        return UserDefaults.standard.float(forKey: key)
    }
}
