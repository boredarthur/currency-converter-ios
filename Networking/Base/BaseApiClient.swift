import Foundation
import Alamofire
import PromiseKit
import ObjectMapper

class BaseApiClient {

    private let session: Session
    private var requestsQueue = [ApiRequest]()
    private let workQueue = DispatchQueue(label: "\(BaseApiClient.self)")

    public init(session: Session) {
        self.session = session
    }

    func cancelAllRequests() {
        session.cancelAllRequests()
    }

    func doRequest<RC: URLRequestConvertible, E: Mappable>(requestRouter: RC) -> Promise<[E]> {
        let request = createRequest(requestRouter)
        executeRequest(request)

        return request
            .pendingPromise
            .promise
            .map(on: workQueue) { body in
                guard let objects = Mapper<E>().mapArray(JSONObject: body) else {
                    throw self.mapError(body: body)
                }
                return objects
            }
    }

    func doRequest<RC: URLRequestConvertible, E: Mappable>(requestRouter: RC) -> Promise<E> {
        let request = createRequest(requestRouter)
        executeRequest(request)

        return request
            .pendingPromise
            .promise
            .map(on: workQueue) { body in
                guard let object = Mapper<E>().map(JSONObject: body) else {
                    throw self.mapError(body: body)
                }
                return object
            }
    }

    func createRequest<RC: URLRequestConvertible>(_ endpoint: RC) -> ApiRequest {
        ApiRequest(pendingPromise: Promise<Any>.pending(), requestEndPoint: endpoint)
    }

    func executeRequest(_ apiRequest: ApiRequest) {
        workQueue.async {
            guard let urlRequest = apiRequest.requestEndPoint.urlRequest else {
                return
            }

            self.session
                .request(apiRequest.requestEndPoint)
                .responseJSON(queue: self.workQueue) { response in
                    self.handleResponse(response, for: apiRequest, with: urlRequest)
                }
        }
    }

    func handleResponse(
        _ response: AFDataResponse<Any>,
        for apiRequest: ApiRequest,
        with urlRequest: URLRequest
    ) {
        guard let urlResponse = response.response else {
            return missingUrlResponse(for: apiRequest, with: response.error)
        }

        let responseData = try? response.result.get()
        let statusCode = urlResponse.statusCode

        if 200...299 ~= statusCode {
            apiRequest.pendingPromise.resolver.fulfill(responseData ?? "")
        } else {
            let error = mapError(body: responseData)
            error.statusCode = statusCode

            apiRequest.pendingPromise.resolver.reject(error)
        }
    }

    private func mapError(body: Any?) -> ApiError {
        Mapper<ApiError>().map(JSONObject: body) ?? .unknown()
    }

    private func missingUrlResponse(
        for apiRequest: ApiRequest,
        with afError: AFError?
    ) {
        let error: ApiError

        switch afError {
        case .explicitlyCancelled:
            error = .cancelled()
        case .sessionTaskFailed(let err as URLError) where
            err.code == .notConnectedToInternet ||
            err.code == .networkConnectionLost ||
            err.code == .dataNotAllowed:
            error = .noInternet()
        default:
            error = .unknown()
        }
    }
}
