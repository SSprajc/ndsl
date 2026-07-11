import AppIntents
import Foundation
import home_widget

@available(iOS 17, *)
public struct BackgroundIntent: AppIntent {
  public static var title: LocalizedStringResource = "ndsl Widget Intent"

  @Parameter(title: "Widget URI")
  var url: URL?

  @Parameter(title: "AppGroup")
  var appGroup: String?

  public init() {}

  public init(url: URL?, appGroup: String?) {
    self.url = url
    self.appGroup = appGroup
  }

  public func perform() async throws -> some IntentResult {
    await HomeWidgetBackgroundWorker.run(url: url, appGroup: appGroup!)
    return .result()
  }
}

/// Keeps widget taps working when the app process is fully suspended by
/// continuing into the foreground app.
@available(iOS 17, *)
@available(iOSApplicationExtension, unavailable)
extension BackgroundIntent: ForegroundContinuableIntent {}
