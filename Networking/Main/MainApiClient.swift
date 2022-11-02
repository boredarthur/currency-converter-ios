import PromiseKit

class MainApiClient: BaseApiClient {

    func performExchange(value: Float, from: Currency, to: Currency) -> Promise<ApiCurrency> {
        doRequest(requestRouter: ExchagerRequestRouter.performExchange(value: value, from: from, to: to))
    }

    func previewExchange(value: Float, from: Currency, to: Currency) -> Promise<ApiCurrency> {
        doRequest(requestRouter: ExchagerRequestRouter.performExchange(value: value, from: from, to: to))
    }
}
