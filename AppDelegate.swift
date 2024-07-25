import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Save emojis to shared UserDefaults
        let sharedDefaults = UserDefaults(suiteName: "group.boopid")
        let emojis = ["␡","😁","😊","🥰","😔","🥺","😠","🫣","🫡","😑","😴","🫰🏻","🫳🏻","👋🏻","🏃🏻","🏃🏻‍➡️","🪡","🐱","🐹","🐨","🐸","🦆","🐶","🐊","🌪️","🌟","🍇","🧄","🌯","🍜","🥟","🥄","🥢","🖲️","💡","🧭","🎚️","🟤","📿"] // Default emojis
        sharedDefaults?.set(emojis, forKey: "sharedEmojis")

        return true
    }
}
