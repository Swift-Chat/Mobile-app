import SwiftUI

struct LoginView: View {
    @StateObject private var loginViewModel: LoginViewModel = LoginViewModel()
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel

    private var errorMessage: String? {
        authenticationViewModel.errorMessage
    }

    var body: some View {
        VStack {

            HStack {
                Image("Logo")
                    .resizable()
                    .frame(width: 60, height: 60)
                Text("SwiftChat")
                    .font(.title)
            }

            Spacer()
                .frame(height: 100)

            Text("Sign In")
                .font(.title)
                .frame(width: 300, alignment: .leading)

            TextField("Username", text: $loginViewModel.credentials.username)
                .frame(height: 20)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.black, style: StrokeStyle(lineWidth: 1))
                )

            SecureField("Password", text: $loginViewModel.credentials.password)
                .frame(height: 20)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.black, style: StrokeStyle(lineWidth: 1))
                )

            Spacer()
                .frame(height: 20)

            Button {
                loginViewModel.login(completion: authenticationViewModel.handleLoginResult)
            } label: {
                HStack {
                    Text("Sign in")
                        .font(.headline)
                    Image(systemName: "arrow.right")
                }
                    .foregroundColor(Color.white)
                    .frame(height: 30)
                    .padding(10)
                    .frame(width: 300)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                Color.purpleApp
                            )
                    )
            }

        }
        .frame(width: 300)
        .alert(authenticationViewModel.errorMessage ?? "", isPresented: $authenticationViewModel.presenteErrorMessage) {
            Button("OK", role: .cancel) {}
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
