import UIKit
import Resolver

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    @Injected private var userDefaultsManager: UserDefaultsManager

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        window = UIWindow(windowScene: windowScene)
        let controller = CurrencyConverterController()
        if UIApplication.isFirstLaunch() {
            controller.configuration = configureFirstLaunch()
        } else {
            controller.configuration = loadUserDefaults()
        }
        window?.rootViewController = BaseNavigationController(rootViewController: controller)
        window?.makeKeyAndVisible()
    }

    private func configureFirstLaunch() -> CurrencyConverterConfiguration {
        userDefaultsManager.setDollarsAmount(0)
        userDefaultsManager.setEurosAmount(1000)
        userDefaultsManager.setYensAmount(0)

        return CurrencyConverterConfiguration(
            dollars:Currency.Usd(amount: 0),
            euros: Currency.Euro(amount: 1000),
            yens: Currency.Yen(amount: 0)
        )
    }

    private func loadUserDefaults() -> CurrencyConverterConfiguration {
        return CurrencyConverterConfiguration(
            dollars: Currency.Usd(
                amount: userDefaultsManager.getValue(for: "dollarsAmount")
            ),
            euros: Currency.Euro(
                amount: userDefaultsManager.getValue(for: "eurosAmount")
            ),
            yens: Currency.Yen(
                amount: userDefaultsManager.getValue(for: "yensAmount")
            )
        )
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
