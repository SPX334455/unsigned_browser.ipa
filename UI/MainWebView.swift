import SwiftUI
import WebKit

struct MainWebView: View {

    @StateObject private var store = WebViewStore()
    let timer = Timer.publish(every: 0.06, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack(alignment: .bottom) {

            RepresentableWebView(webView: store.umingleView)
                .ignoresSafeArea()

            HStack(spacing: 30) {

                Button { sendKey(37) } label: {
                    ControlIcon(icon: "arrow.left.circle.fill", color: .blue)
                }

                Button { activatePresent() } label: {
                    Text("TAM EKRAN")
                        .font(.caption.bold())
                        .padding(10)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button { sendKey(39) } label: {
                    ControlIcon(icon: "arrow.right.circle.fill", color: .green)
                }
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(20)
            .padding(.bottom, 30)
        }
        .onReceive(timer) { _ in
            syncFrames()
        }
    }

    // MARK: - JS Kontroller

    private func activatePresent() {
        let js = """
        var btn = document.querySelector('.present-button')
               || document.querySelector('[data-test-id="present-button"]');
        if(btn){ btn.click(); }
        else {
            document.dispatchEvent(
                new KeyboardEvent('keydown', { key:'p', keyCode:80, which:80 })
            );
        }
        """
        store.preziView.evaluateJavaScript(js)
    }

    private func sendKey(_ key: Int) {
        let js = """
        document.dispatchEvent(
            new KeyboardEvent('keydown', { keyCode:\(key), which:\(key) })
        );
        """
        store.preziView.evaluateJavaScript(js)
    }

    private func syncFrames() {
        store.preziView.takeSnapshot(with: nil) { image, _ in
            guard
                let img = image,
                let data = img.jpegData(compressionQuality: 0.6)
            else { return }

            let b64 = data.base64EncodedString()
            let js = "window.drawToFakeCamera && window.drawToFakeCamera('\(b64)')"
            store.umingleView.evaluateJavaScript(js)
        }
    }
}
