import Resolver

extension Resolver: ResolverRegistering {

    public static func registerAllServices() {
        registerCurrency()

        registerNetworkingComponents()
    }
}
