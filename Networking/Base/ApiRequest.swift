import Alamofire
import PromiseKit

class ApiRequest {

    let requestEndPoint: URLRequestConvertible
    let pendingPromise: (promise: Promise<Any>, resolver: Resolver<Any>)

    required init<T: URLRequestConvertible>(
        pendingPromise: (promise: Promise<Any>, resolver: Resolver<Any>),
        requestEndPoint: T
    ) {
        self.pendingPromise = pendingPromise
        self.requestEndPoint = requestEndPoint
    }
}
