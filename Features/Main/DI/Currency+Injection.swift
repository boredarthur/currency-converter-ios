import Resolver

extension Resolver {

    public static func registerCurrency() {
        register {
            CurrencyFactory()
        }.scope(.application)
        register {
            CurrencyManager()
        }.scope(.application)
        register {
            CurrencyConverterPrompt()
        }.scope(.application)
        register {
            UserDefaultsManager()
        }.scope(.application)
    }
}
