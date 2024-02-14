import SwiftUI

struct Header: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 10)
            HStack {
                Image("Logo")
                    .resizable()
                    .frame(width: 60, height: 60)
                Text("SwiftChat")
                    .font(.title)
            }
        }
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header()
    }
}
