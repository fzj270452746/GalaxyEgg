import UIKit
import WebKit
import AdjustSdk
import SafariServices


internal class KandeiBajirmViewController: UIViewController,WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, SFSafariViewControllerDelegate {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == mdalo!.vunsje![0] {
            if let bodyString = message.body as? String,
                       let data = bodyString.data(using: .utf8),
                       let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let method = dict["method"] as? String,
                       let params = dict["params"] as? [String: Any] ,
               let urlString = params["url"] as? String, let url = URL(string: urlString) {
                //mdalo!.vunsje![3] == openUrlByBrowser
                if method == mdalo!.vunsje![1]  {
                    // 在浏览器中打开 URL
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                if method == mdalo!.vunsje![2] {
                    let sf = SFSafariViewController(url: url)
                    sf.delegate = self
                    present(sf, animated: false)
                }
            }
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: false)
    }

    var mdalo: Foeishbh?
    private var nicnks: WKWebView?
    private var onyri = ""
    
    private var aidstr = ""
    private var ifastr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mdalo!.nhauwk != nil {
            view.backgroundColor = UIColor.init(hexString: mdalo!.nhauwk!)
        }
        
        let aaq = ADJConfig(appToken: mdalo!.zuiome!, environment: ADJEnvironmentProduction)
        Adjust.initSdk(aaq)
        
//        windcoCHunag = xiaoBears!.penwuqi!.components(separatedBy: ",")
//        HuntOrderKrajs = [aTc,diaChon, diyicicho, hdrawo, geicho, chozh, diyichCha, deop]
//        let usrScp = WKUserScript(source: xiaoBears!.xinlixud!, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let usCt = WKUserContentController()
//        usCt.addUserScript(usrScp)
        let cofg = WKWebViewConfiguration()
        cofg.userContentController = usCt
        cofg.allowsInlineMediaPlayback = true
        cofg.userContentController.add(self, name: mdalo!.vunsje![0])
        cofg.defaultWebpagePreferences.allowsContentJavaScript = true
        nicnks = WKWebView(frame: .zero, configuration: cofg)
        nicnks?.uiDelegate = self
        nicnks?.navigationDelegate = self
        view.addSubview(nicnks!)

        let deviceModel = UIDevice.current.model
        let syvs = UIDevice.current.systemVersion.replacingOccurrences(of: ".", with: "_")
        let mdna = UIDevice.current.modelName
        let ud = UIDevice.vkKeychainIDFV() ?? ""

        nicnks!.customUserAgent = "Mozilla/5.0 (\(deviceModel); CPU iPhone OS \(syvs) like Mac OS X) AppleWebKit(KHTML, like Gecko) Mobile AppShellVer:1.0 Chrome/41.0.2228.0 Safari/7534.48.3 model:\(mdna) UUID:\(ud)"
        
        Adjust.adid { [self] aid in
            aidstr = aid!
//            print(aid)
            if ifastr.count > 0 {
                koieBleki()
            }
        }
        
        Adjust.idfa { [self] ifa in
            ifastr = ifa!
//            print(ifa)
            if aidstr.count > 0 {
                koieBleki()
            }
        }
    }
    
    private func koieBleki() {
        onyri = mdalo!.ksimeh!.replacingOccurrences(of: "{adid}", with: aidstr)
        onyri = onyri.replacingOccurrences(of: "{idfa}", with: ifastr)
        
        print(onyri)
        
        nicnks?.load(URLRequest(url:URL(string: onyri)!))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let ws = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let statusBarManager = ws.statusBarManager {
            
            let statusBarHeight = mdalo!.nsjies!.contains("t") ? statusBarManager.statusBarFrame.height : 0
            let bottomHeight = mdalo!.nsjies!.contains("d") ? view.safeAreaInsets.bottom : 0
            nicnks?.frame = CGRectMake(0, statusBarHeight, view.bounds.width, view.bounds.height - statusBarHeight - bottomHeight)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        let ul = navigationAction.request.url
        if ((ul?.absoluteString.hasPrefix(webView.url!.absoluteString)) != nil) {
//            UIApplication.shared.open(ul!)
            webView.load(navigationAction.request)
        }
        return nil
    }
    
//    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        if message.name == Brie {
//            let dic = message.body as! [String : String]
//
//            KaiwgunChazuo(dic, xiaoBears!.shuliaod!)
//        }
//    }
    
    override var shouldAutorotate: Bool {
        false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
}


//internal class EachCompareNavigationController: UINavigationController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        isNavigationBarHidden = true
//    }
//
//    override var shouldAutorotate: Bool {
//        return topViewController?.shouldAutorotate ?? super.shouldAutorotate
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
//    }
//}
