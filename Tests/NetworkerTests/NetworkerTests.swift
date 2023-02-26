import XCTest
import Networker

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


extension NWMainBaseRequest {
  
  var baseURL: URL { URL(string: "https://api-merchantapp.montypay.com")! }
}

enum TermsAPI: NWRequest {
  case getTerms
  
  var path: String {
    switch self {
    case .getTerms:
      return "/merchant-app/termsAndConditions"
    }
  }
  
  var withToken: Bool {
    switch self {
    case .getTerms:
      return false
    }
  }
}

final class NetworkerTests: XCTestCase {
  func testExample() throws {
    
    let request = TermsAPI.getTerms
    let apiCaller = Networker(type: .default)
    
    let exp = expectation(description: "wait for call")
    
    let task = apiCaller.get(request: request, response: Root<Text>.self) { _ in
      exp.fulfill()
    }
    
    //        task.cancel()
    
    wait(for: [exp], timeout: 5.0)
  }
}
