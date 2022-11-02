import Resolver

extension Resolver {

    public static func registerNetworkingComponents() {
        register {
            MainApiClientFactory.create()
        }.scope(.application)
    }
}
