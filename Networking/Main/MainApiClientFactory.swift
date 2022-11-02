import Alamofire

class MainApiClientFactory {

    public static func create() -> MainApiClient {
        let session = Session()
        return MainApiClient(session: session)
    }
}
