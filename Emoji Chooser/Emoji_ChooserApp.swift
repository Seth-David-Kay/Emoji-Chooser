import SwiftUI

@main
struct Emoji_ChooserApp: App {
    // Connect to AppDelegate for app lifecycle events
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
