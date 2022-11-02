import Foundation
import ObjectMapper

class ApiCurrency: Mappable {

    var amount: String?
    var currency: String?

    public init() {}

    public required init?(map: Map) {}

    func mapping(map: Map) {
        amount      <- map["amount"]
        currency    <- map["currency"]
    }
}
