import SwiftUI
import ParseCore

@main
struct Examen_MovilesApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    /// Parse setup and initial app launch configuration.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        // Parse configuration with the keys directly
        let parseConfig = ParseClientConfiguration {
            $0.applicationId = "APP_ID"
            $0.clientKey = "MASTER_KEY"
            $0.server = "https://examenes.meeplab.com/parse"
        }

        // Parse initialization
        Parse.initialize(with: parseConfig)
        print("Parse initialized successfully!")

        return true
    }
}
