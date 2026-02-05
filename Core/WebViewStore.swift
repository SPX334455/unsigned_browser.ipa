import WebKit
import SwiftUI

final class WebViewStore: ObservableObject {

    let umingleView: WKWebView
    let preziView: WKWebView

    init() {
        // Umingle config (kamera kandırma)
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        let hookJS = """
        (function() {
            var canvas = document.createElement('canvas');
            canvas.width = 1280;
            canvas.height = 720;
            var ctx = canvas.getContext('2d');

            window.drawToFakeCamera = function(b64) {
                var img = new Image();
                img.onload = function() {
                    ctx.clearRect(0,0,canvas.width,canvas.height);
                    ctx.drawImage(img,0,0,canvas.width,canvas.height);
                };
                img.src = 'data:image/jpeg;base64,' + b64;
            };

            var stream = canvas.captureStream(25);

            navigator.mediaDevices.getUserMedia = function() {
                return Promise.resolve(stream);
            };
        })();
        """

        let script = WKUserScript(
            source: hookJS,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        )

        config.userContentController.addUserScript(script)

        umingleView = WKWebView(frame: .zero, configuration: config)
        umingleView.load(URLRequest(url: URL(string: "https://umingle.com")!))

        // Prezi (görüntü kaynağı)
        preziView = WKWebView(
            frame: CGRect(x: 0, y: 0, width: 1280, height: 720)
        )

        let preziURL = "https://prezi.com/view/SENIN_LINKIN/?present=1"
        preziView.load(URLRequest(url: URL(string: preziURL)!))
    }
}
