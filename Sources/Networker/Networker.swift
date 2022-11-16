import Foundation

public final class Networker {
  
  private let logger: NWLogger
  private let activityIndicator: NWActivityIndicator
  private let session: NWSessionConfiguration
  
  public init(
    session: NWSessionConfiguration,
    logger: NWLogger,
    activityIndicator: NWActivityIndicator
  ) {
    self.logger = logger
    self.activityIndicator = activityIndicator
    self.session = session
  }
  
  
}
