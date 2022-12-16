import XCTest
import Networker

extension NWRequest {
    var baseURL: URL { URL(string: "https://api-merchantapp.montypay.com")! }
}

struct Root<T: Decodable>: Decodable {
    let status: Bool
    let totalCount: Int?
    let data: T
    let title: String
    let message: String
    let developerMessage: String
    let responseCode: Int
}

struct Text: Decodable {
    let id: String
    let text: String
}

enum TermsAPI: NWRequest {
    
    case getTerms
    
    var path: String { "/merchant-app/termsAndConditions" }
    
    var acceptableStatusCodes: [Int] {
        switch self {
        case .getTerms:
            return [200]
        default:
            return Array(200...299)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getTerms:
            return nil
        default:
            return ["header": "header-value"]
        }
    }
    
    var httpMethod: NWMethod {
        switch self {
        case .getTerms:
            return .get
        }
    }
    
    var query: [String : String?]? {
        switch self {
        case .getTerms:
            return nil
        default:
            return ["query": "query-value"]
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getTerms:
            return nil
        default:
            return ["parameter": "parameter-value"]
        }
    }
    
    var withToken: Bool {
        switch self {
        case .getTerms:
            return false
        }
    }
    
    var token: String {
        return "-TOKEN-"
    }
    
}

final class NetworkerTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        let request = TermsAPI.getTerms
        let apiCaller = Networker()
        
        let exp = expectation(description: "wait for call")
        
        let task = apiCaller.get(request: request, response: Root<Text>.self) { _ in
//            dump(result)
            exp.fulfill()
        }
        
//        task.cancel()
        
        wait(for: [exp], timeout: 5.0)
    }
}
