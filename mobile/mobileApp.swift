import SwiftUI

@main
struct mobileApp: App {
    @StateObject var authenticationViewModel = AuthenticationViewModel()
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            switch authenticationViewModel.authState {
            case .loggedIn:
                ContentView(authenticationVM: authenticationViewModel)
            case .loggedOut:
                LoginView()
                    .environmentObject(authenticationViewModel)
            }
        }
    }
}
