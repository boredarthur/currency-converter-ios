import Foundation
import ObjectMapper

class ApiError: Mappable, Error {

    var type: String?
    var errorCode: String?
    var errorMessage: String?
    var statusCode: Int?

    init(
        type: String? = nil,
        errorCode: String? = nil,
        errorMessage: String? = nil,
        statusCode: Int? = nil
    ) {
        self.type = type
        self.errorCode = errorCode
        self.errorMessage = errorMessage
        self.statusCode = statusCode
    }

    required init?(map: Map) { }

    func mapping(map: Map) {
        type            <- map["type"]
        errorCode       <- map["errorCode"]
        errorMessage    <- map["errorMessage"]
    }

    class func unknown() -> ApiError {
        return ApiError(errorCode: "unknown")
    }

    class func mapping(json: String) -> ApiError {
        return ApiError(errorCode: "mapping", errorMessage: "Mapping failed on: \(json)")
    }

    class func cancelled() -> ApiError {
        return ApiError(errorCode: "cancelled")
    }

    class func noInternet() -> ApiError {
        return ApiError(errorCode: "no_internet", errorMessage: "No internet connection")
    }
}
