
import Foundation
import AdjustSdk

final class TSManager: NSObject, AdjustDelegate {
    static let shared = TSManager()

    var onTrackingIdAvailable: (() -> Void)?
    var onAttributionChanged: (() -> Void)?

    private var isInitialized = false
    private var hasTrackingIdBeenNotified = false
    private var cachedTrackingId: String?
    private var cachedIdfa: String?
    private var cachedIdfv: String?
    private let cacheQueue = DispatchQueue(label: "com.egg.GalaxyEgg.cache")

    // MARK: - Public Properties

    var hasTrackingId: Bool {
        cacheQueue.sync { !(cachedTrackingId ?? "").isEmpty }
    }

    var trackingId: String? {
        cacheQueue.sync {
            return cachedTrackingId
        }
    }

    var appToken: String = ""

    var idfa: String { cacheQueue.sync { cachedIdfa ?? "" } }

    var idfv: String { cacheQueue.sync { cachedIdfv ?? "" } }

    // MARK: - Initialization
    
    func baseLoading(_ token: String) {
        guard !isInitialized else { return }
        
        appToken = token
        guard let config = ADJConfig(appToken: appToken, environment: ADJEnvironmentProduction) else {
            print("[Tracking] ⚠️ Failed to create Adjust configuration")
            return
        }
        
        isInitialized = true

        config.delegate = self
        Adjust.initSdk(config)
//        Adjust.attribution { attribution in
//            print("[Adjust] attribution: \(attribution?.description ?? "nil")")
//        }
        
        huoquInfouy()
        jianChaOneOpen()
    }

    // MARK: - Identifier Caching

    private func huoquInfouy() {
        guard #available(iOS 13.0, *) else { return }
        Task {
            if let adid = await Adjust.adid() {
//                print("[Tracking] Initializing - Tracking ID: \(adid)")
                updateCachedTrackingId(adid)
            } else {
//                print("[Tracking] Initializing - Tracking ID not available yet")
            }

            if let idfa = await Adjust.idfa() {
//                print("[Tracking] Initializing - IDFA: \(idfa)")
                updateCachedIdfa(idfa)
            } else {
//                print("[Tracking] Initializing - IDFA not available yet")
            }

            if let idfv = await Adjust.idfv() {
//                print("[Tracking] Initializing - IDFV: \(idfv)")
                updateCachedIdfv(idfv)
            } else {
//                print("[Tracking] Initializing - IDFV not available yet")
            }

//            print("[Tracking] Identifier caching completed")
        }
    }

    // MARK: - Cache Update Helpers
    private func updateCachedTrackingId(_ id: String) {
        var shouldNotify = false
        cacheQueue.sync {
            
            let hadId = !(cachedTrackingId ?? "").isEmpty
            cachedTrackingId = id
            
            if !hadId && !id.isEmpty && !hasTrackingIdBeenNotified {
                hasTrackingIdBeenNotified = true
                shouldNotify = true
            }
        }
        if shouldNotify {
            DispatchQueue.main.async {
//                print("[Tracking] Tracking ID available, notifying observers")
                TSManager.shared.onTrackingIdAvailable?()
            }
        }
    }

    private func updateCachedIdfa(_ idfa: String) {
        cacheQueue.sync {
//            print("[Tracking] updateCachedIdfa: \(idfa)")
            cachedIdfa = idfa
//            print("[Tracking] cachedIdfa updated to: \(idfa)")
        }
    }

    private func updateCachedIdfv(_ idfv: String) {
        cacheQueue.sync {
//            print("[Tracking] updateCachedIdfv: \(idfv)")
            cachedIdfv = idfv
//            print("[Tracking] cachedIdfv updated to: \(idfv)")
        }
    }

    // MARK: - AdjustDelegate

    func adjustAttributionChanged(_ attribution: ADJAttribution?) {
        guard let attribution else { return }
        print("[Tracking] Attribution: \(attribution.description)")

        var attributionDict: [String: Any] = [:]
        if let network      = attribution.network      { attributionDict["network"]      = network }
        if let campaign     = attribution.campaign     { attributionDict["campaign"]     = campaign }
        if let adgroup      = attribution.adgroup      { attributionDict["adgroup"]      = adgroup }
        if let creative     = attribution.creative     { attributionDict["creative"]     = creative }
        if let clickLabel   = attribution.clickLabel   { attributionDict["clickLabel"]   = clickLabel }
        if let trackerToken = attribution.trackerToken { attributionDict["trackerToken"] = trackerToken }
        if let trackerName  = attribution.trackerName  { attributionDict["trackerName"]  = trackerName }
        if let costType     = attribution.costType     { attributionDict["costType"]     = costType }
        if let costAmount   = attribution.costAmount   { attributionDict["costAmount"]   = costAmount }
        if let costCurrency = attribution.costCurrency { attributionDict["costCurrency"] = costCurrency }
        if let jsonResponse = attribution.jsonResponse { attributionDict["jsonResponse"] = jsonResponse }

        if let data = try? JSONSerialization.data(withJSONObject: attributionDict),
           let string = String(data: data, encoding: .utf8) {
            UserDefaults.standard.set(string, forKey: "t_a_j")
            DispatchQueue.main.async {
                TSManager.shared.onAttributionChanged?()
            }
        }
    }

    func adjustEventTrackingSucceeded(_ eventSuccessResponseData: ADJEventSuccess?) {
//        NSLog("Event success callback called!")
//        NSLog("Event success data: %@", eventSuccessResponseData ?? "")
    }

    func adjustEventTrackingFailed(_ eventFailureResponseData: ADJEventFailure?) {
//        NSLog("Event failure callback called!")
//        NSLog("Event failure data: %@", eventFailureResponseData ?? "")
    }

    func adjustSessionTrackingSucceeded(_ sessionSuccessResponseData: ADJSessionSuccess?) {
//        NSLog("Session success callback called!")
//        NSLog("Session success data: %@", sessionSuccessResponseData ?? "")
        if let adid = sessionSuccessResponseData?.adid, !adid.isEmpty {
//            print("[Tracking] Session success - Tracking ID: \(adid)")
            updateCachedTrackingId(adid)
        }
    }

    func adjustSessionTrackingFailed(_ sessionFailureResponseData: ADJSessionFailure?) {
//        NSLog("Session failure callback called!")
//        NSLog("Session failure data: %@", sessionFailureResponseData ?? "")
    }

    func adjustDeferredDeeplinkReceived(_ deeplink: URL?) -> Bool {
//        NSLog("Deferred deep link callback called!")
//        NSLog("Deferred deep link URL: %@", deeplink?.absoluteString ?? "")
        setDeepLink(deeplink?.absoluteString ?? "")
        return true
    }

    // MARK: - Helper Methods

    func getInstallReferrer() -> String? {
        //tracking_attribution_json
        UserDefaults.standard.string(forKey: "t_a_j")
    }

    func getDeepLink() -> String? {
        //tracking_deeplink_referrer
        UserDefaults.standard.string(forKey: "t_d_r")
    }

    func setDeepLink(_ deepLink: String) {
        UserDefaults.standard.set(deepLink, forKey: "t_d_r")
    }

    func isFirstOpen() -> Bool {
        //app_has_been_opened
        if let _ = UserDefaults.standard.string(forKey: "opened") {
            return false
        }
        return true
    }

    private func jianChaOneOpen() {
        if let _ = UserDefaults.standard.string(forKey: "opened") {
            UserDefaults.standard.set("opened", forKey: "opened")
            UserDefaults.standard.synchronize()
        }
    }
}


import Security

enum DeviceUtils {

    private static let uuidKey = "com.galaxyEgg.uuid"

    static func save(key: String, data: Data) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query)
        return SecItemAdd(query, nil) == errSecSuccess
    }

    static func load(key: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        return status == errSecSuccess ? dataTypeRef as? Data : nil
    }

    @discardableResult
    static func delete(key: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        let status = SecItemDelete(query)
        return status == errSecSuccess || status == errSecItemNotFound
    }

    // MARK: - UUID Helper Methods

    static func getDeviceUUID() -> String {
        if let data = load(key: uuidKey),
           let uuid = String(data: data, encoding: .utf8),
           !uuid.isEmpty {
            return uuid
        }

        let newUUID = UUID().uuidString
        if let uuidData = newUUID.data(using: .utf8) {
            if save(key: uuidKey, data: uuidData) {
                print("[DeviceUtils] New UUID generated and saved: \(newUUID)")
            } else {
                print("[DeviceUtils] Failed to save UUID to Keychain")
            }
        }
        return newUUID
    }

    @discardableResult
    static func setDeviceUUID(_ uuid: String) -> Bool {
        guard let uuidData = uuid.data(using: .utf8) else { return false }
        return save(key: uuidKey, data: uuidData)
    }
}


enum ALang: String, CaseIterable {
    case english    = "en"
    case spanish    = "es"
    case portuguese = "pt"
    case hongKong   = "hk"

//    var h5PathComponent: String { rawValue }
}

// MARK: - Token Storage

final class TkManager {
    static let shared = TkManager()
    private(set) var token: String

    private init() {
        token = UserDefaults.standard.string(forKey: "token") ?? ""
    }

    func setToken(_ token: String, expireTime: TimeInterval? = nil) {
        self.token = token
        UserDefaults.standard.set(token, forKey: "token")
        if let expireTime = expireTime {
            UserDefaults.standard.set(expireTime, forKey: "expire")
        }
    }

    func clearAllData() {
        token = ""
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "expire")
    }
}

// MARK: - Language Store

final class LangManager {
    static let shared = LangManager()
    private(set) var currentLang: ALang

    private init() {
        if let raw = UserDefaults.standard.string(forKey: "lang"),
           let saved = ALang(rawValue: raw) {
            currentLang = saved
        } else {
            currentLang = .english
        }
    }

    func switchLanguage(to language: ALang) {
        guard currentLang != language else { return }
        currentLang = language
        UserDefaults.standard.set(language.rawValue, forKey: "lang")
//        print("[LanguageStore] Current language switched to: \(language.rawValue)")
    }
}
