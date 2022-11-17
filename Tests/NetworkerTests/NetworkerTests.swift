import XCTest
@testable import Networker

struct Text: Codable {
    let id: String
    let text: String
}

enum TermsAPI: NWRequestBuilder {
    
    case getTerms
    
    var baseURL: URL {
        return URL(string: "https://api-merchantapp.montypay.com")!
    }
    
    var path: String {
        return "/merchant-app/termsAndConditions"
    }
    
    var headers: [String : String]? {
        ["testing":"headers"]
    }
    
    var query: [String : String?]? {
        ["testing":"query"]
    }
    
    var parameters: [String : Any]?{
        ["testing":"parameters"]
    }
    
    var withToken: Bool {
        false
    }
    
    var token: String {
        "TESTING_TOKEN-123ouiwkdsjv"
    }
    
    var acceptableStatusCodes: ClosedRange<Int> {
        return 200...299
    }
    
    var httpMethod: NWMethod {
        .get
    }
    
}

final class NetworkerTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        let builder = TermsAPI.getTerms
        
        
        dump(builder.token)
    }
    
}
