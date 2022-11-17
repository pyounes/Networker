import XCTest
@testable import Networker

struct Root: Decodable {
  let status: Bool
  let totalCount: Int?
  let data: Text
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
  
  var baseURL: URL {
    return URL(string: "https://api-merchantapp.montypay.com")!
  }
  
  var path: String {
    return "/merchant-app/termsAndConditions"
  }
  
//  var headers: [String : String]? {
//    ["testing":"headers"]
//  }
  
//  var query: [String : String?]? {
//    ["testing":"query"]
//  }
  
//  var parameters: [String : Any]?{
//    ["testing":"parameters"]
//  }
  
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

fileprivate class session: NWSessionConfiguration {}
fileprivate class logger: NWLogger {}
fileprivate class activityIndicator: NWActivityIndicator {}

final class NetworkerTests: XCTestCase {
  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct
    // results.
    
    let request = TermsAPI.getTerms
    let apiCaller = Networker(session: session(), logger: logger(), activityIndicator: activityIndicator())
    
    let exp = expectation(description: "wait for call")
    
    apiCaller.taskHandler(request: request, response: Root.self) { result in
//      dump(result)
      exp.fulfill()
    }
    
    wait(for: [exp], timeout: 2.0)

  }
  
}
