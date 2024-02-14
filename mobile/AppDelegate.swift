import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationWillTerminate(_ application: UIApplication) {
        // TODO: Close websocket
        print("Application terminate")
    }
}
