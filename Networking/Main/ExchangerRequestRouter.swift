import Alamofire
import Foundation

enum ExchagerRequestRouter {

    case performExchange(value: Float, from: Currency, to: Currency)

    private static let baseURL = URL(string: "http://api.evp.lt/currency/commercial/")

    private var method: HTTPMethod {
        switch self {
        case .performExchange(_, _, _):
            return .get
        }
    }

    private var path: String {
        switch self {
        case .performExchange(let value, let from, let to):
            return "exchange/\(value)-\(from.description)/\(to.description)/latest"
        }
    }

    private var parameters: Parameters? {
        switch self {
        default:
            return nil
        }
    }
}

extension ExchagerRequestRouter: URLRequestConvertible {

    func asURLRequest() throws -> URLRequest {
        let url = Self.baseURL!.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method

        switch method {
        default:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }

        return urlRequest
    }
}
