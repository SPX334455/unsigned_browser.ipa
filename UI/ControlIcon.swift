import SwiftUI

struct ControlIcon: View {
    let icon: String
    let color: Color

    var body: some View {
        Image(systemName: icon)
            .resizable()
            .frame(width: 45, height: 45)
            .foregroundColor(color)
    }
}
