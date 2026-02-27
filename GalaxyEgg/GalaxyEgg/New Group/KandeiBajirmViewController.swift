
import UIKit
import WebKit
import AdjustSdk

class KandeiBajirmViewController: UIViewController {
    
    
    var mdalo: Foeishbh?
    private var webView: WKWebView!
    private var loadingView: UIView!
    private var url: String = ""
    private var lastRequestedURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mdalo!.nhauwk != nil {
            view.backgroundColor = UIColor.init(hexString: mdalo!.nhauwk!)
        }
        
        
        TSManager.shared.baseLoading(mdalo!.zuiome!)
        url = mdalo!.ksimeh! + "&mApp=4" + "&cToken=" + TkManager.shared.token
        
        setupWebView()
        setupLoadingView()
        observeNotifications()
        checkTrackingStatus()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let ws = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let statusBarManager = ws.statusBarManager {
            
            let statusBarHeight = mdalo!.nsjies!.contains("l") ? statusBarManager.statusBarFrame.height : 0
            let bottomHeight = mdalo!.nsjies!.contains("p") ? view.safeAreaInsets.bottom : 0
            webView.frame = CGRectMake(0, statusBarHeight, view.bounds.width, view.bounds.height - statusBarHeight - bottomHeight)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.stopLoading()
    }

    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: mdalo!.vunsje![0])
        TSManager.shared.onTrackingIdAvailable = nil
        TSManager.shared.onAttributionChanged = nil
    }

    // MARK: - Setup

    private func setupWebView() {
        let config = WKWebViewConfiguration()
        
        //jsBridge
        config.userContentController.add(self, name: mdalo!.vunsje![0])

        webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        webView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }


    private func setupLoadingView() {
        loadingView = UIView()
        loadingView.backgroundColor = .black
        loadingView.translatesAutoresizingMaskIntoConstraints = false

        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        spinner.startAnimating()

        let label = UILabel()
        label.text = "Loading..."
        label.textColor = .white

        let stack = UIStackView(arrangedSubviews: [spinner, label])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        loadingView.addSubview(stack)
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func observeNotifications() {
        TSManager.shared.onTrackingIdAvailable = { [weak self] in
            guard let self else { return }
//            print("[WebViewController] Tracking ID available, loading WebView")
            self.loadingView.isHidden = true
            let currentURL = self.webView.url?.absoluteString ?? ""
            if currentURL != self.url, !self.url.isEmpty, let reqURL = URL(string: self.url) {
                self.lastRequestedURL = self.url
                self.webView.load(URLRequest(url: reqURL))
            }
        }

        TSManager.shared.onAttributionChanged = { [weak self] in
            guard let self else { return }
            self.updateJSData(webView: self.webView)
        }
    }

    private func checkTrackingStatus() {
        if TSManager.shared.hasTrackingId {
//            print("[WebViewController] Tracking ID already available, loading WebView immediately")
            loadingView.isHidden = true
            loadURL()
        } else {
//            print("[WebViewController] Waiting for Tracking ID...")
        }
    }

    private func loadURL() {
        guard !url.isEmpty, let reqURL = URL(string: url) else { return }
        lastRequestedURL = url
        webView.load(URLRequest(url: reqURL))
    }

    private func updateJSData(webView: WKWebView) {
        let trackingService = TSManager.shared
        let trackingId = trackingService.trackingId ?? ""
        let installReferrer = trackingService.getInstallReferrer()
        let deepLinkReferrer = trackingService.getDeepLink() ?? ""
        let idfv = trackingService.idfv
        let idfa = trackingService.idfa
        let isFirstOpen = trackingService.isFirstOpen() ? 1 : 0
        let info = Bundle.main.infoDictionary ?? [:]
        let bundleId = info["CFBundleIdentifier"] as? String ?? ""
        let appVersion = info["CFBundleShortVersionString"] as? String ?? ""
        let buildNumber = info["CFBundleVersion"] as? String ?? ""
        let device = UIDevice.current

        var adjustParams: [String: Any] = [:]
        adjustParams["ios_id"] = DeviceUtils.getDeviceUUID()
        adjustParams["ad_app_token"] = trackingService.appToken
        adjustParams["pkg_name"] = bundleId
        if let ref = installReferrer { adjustParams["ad_install_referer"] = ref }
        if !deepLinkReferrer.isEmpty { adjustParams["ad_deeplink_referer"] = deepLinkReferrer }
        if !trackingId.isEmpty { adjustParams["ad_adid"] = trackingId }
        if !idfa.isEmpty { adjustParams["ad_idfa"] = idfa }
        if !idfv.isEmpty { adjustParams["ad_idfv"] = idfv }

        var appPkgInfo: [String: Any] = [:]
        appPkgInfo["package_name"] = bundleId
        appPkgInfo["brand"] = "Apple"
        appPkgInfo["model"] = device.model
        appPkgInfo["device_name"] = device.name
        appPkgInfo["store_name"] = "apple"
        appPkgInfo["version"] = appVersion
        appPkgInfo["build_number"] = buildNumber
        appPkgInfo["device_id"] = DeviceUtils.getDeviceUUID()
        appPkgInfo["sdks"] = [["platform": 5, "token": trackingService.appToken]]

        let jsonObject: [String: Any] = [
            "adjust": adjustParams,
            "app_first_open": isFirstOpen,
            "app_package_info": appPkgInfo
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("[WebViewController] Failed to serialize SDK data")
            return
        }

        print("[WebViewController] updateJSData - Data to inject: \(jsonString)")

        let script = """
        (function() {
            try {
                var data = \(jsonString);
                window.__getReportSdkDataCache = data;
                console.log('[Native Bridge] SDK data cached successfully:', JSON.stringify(data));
            } catch(e) {
                console.error('[Native Bridge] Failed to parse SDK data:', e);
            }
        })();
        """

        webView.evaluateJavaScript(script) { _, error in
            if let error { print("[WebViewController] JS error: \(error.localizedDescription)") }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return (UIApplication.shared.delegate as? GalaxyEggAppDelegate)?.orientationLock ?? .all
    }
}

// MARK: - WKNavigationDelegate

extension KandeiBajirmViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        updateJSData(webView: webView)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateJSData(webView: webView)
    }
}

// MARK: - WKUIDelegate

extension KandeiBajirmViewController: WKUIDelegate {

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
            webView.load(URLRequest(url: url))
        }
        return nil
    }
}

// MARK: - WKScriptMessageHandler

extension KandeiBajirmViewController: WKScriptMessageHandler {

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("[WebViewController] message handler: \(message.name)")
        guard message.name == mdalo!.vunsje![0] else { return }
        handleNativeBridgeMessage(message: message)
    }

    private func handleNativeBridgeMessage(message: WKScriptMessage) {
        print("[WebViewController] handleNativeBridgeMessage: name - \(message.name), body - \(message.body)")

        // Handle console log forwarding
//        if let msgObj = message.body as? [String: Any],
//           let type = msgObj["type"] as? String, type == "console_log" {
//            let level = msgObj["level"] as? String ?? "log"
//            if let data = msgObj["data"] as? String {
////                print("[H5 Console \(level.uppercased())]: \(data)")
//            }
//            return
//        }

        guard let messageBody = message.body as? String,
              let jsonData = messageBody.data(using: .utf8),
              let msgObj = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any],
              let cmdName = msgObj["cmd"] as? String else {
//            print("[WebViewController] Unrecognized message body type: \(type(of: message.body))")
            return
        }

        let params = msgObj["params"] as? [String: Any]
        DispatchQueue.main.async {
            self.handleMessage(cmdName: cmdName, params: params, webView: message.webView)
        }
    }

    private func handleMessage(cmdName: String, params: [String: Any]?, webView: WKWebView?) {
        print("[WebViewController] function received: \(cmdName), params: \(String(describing: params))")
        
        // update_token,update_lang,openAppBrowser,getReportSdkData
        switch cmdName {
        case mdalo!.vunsje![1]:     dealTok(params: params)
        case mdalo!.vunsje![2]:      dealLang(params: params)
        case mdalo!.vunsje![3]:   dealOuts(params: params)
        case mdalo!.vunsje![4]: updateJSData(webView: webView ?? self.webView)
        default: print("...")
        }
    }

    private func dealTok(params: [String: Any]?) {
        guard let token = params?["token"] as? String else {
//            print("[WebViewController] update_token missing 'token'")
            return
        }
        TkManager.shared.setToken(token, expireTime: 0)
        if token.isEmpty { TkManager.shared.clearAllData() }
//        print("[WebViewController] Token updated: \(token.isEmpty ? "cleared" : "set")")
    }

    private func dealLang(params: [String: Any]?) {
        guard let lang = params?["lang"] as? String else {
//            print("[WebViewController] update_lang missing 'lang'")
            return
        }
        let appLanguage = ALang(rawValue: lang) ?? .english
        LangManager.shared.switchLanguage(to: appLanguage)
//        print("[WebViewController] Language updated to: \(lang)")
    }

    private func dealOuts(params: [String: Any]?) {
        guard let urlString = params?["url"] as? String, let url = URL(string: urlString) else {
//            print("[WebViewController] openAppBrowser missing or invalid 'url'")
            return
        }
        UIApplication.shared.open(url, options: [.universalLinksOnly: false]) { success in
//            print("[WebViewController] openAppBrowser \(success ? "success" : "failed"): \(urlString)")
        }
    }
}
