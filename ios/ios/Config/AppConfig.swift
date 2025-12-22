
//
//import SwiftUI
//
//@Observable
//class AppConfig {
//    @AppStorage("voice.host") var vHost: String = "localhost"
//    @AppStorage("voice.port") var vPort: String = "8080"
//
//    @AppStorage("tracking.host") var tHost: String = "localhost"
//    @AppStorage("tracking.port") var tPort: String = "8081"
//
//    @AppStorage("liveID") var liveID: String = ""
//}

import SwiftUI
import Observation

// ① @MainActor: UIと連動するためメインスレッドで管理
@MainActor
@Observable
class AppConfig {
    
    // ② シングルトン: アプリ全体で「たった1つの設定」を共有する
    static let shared = AppConfig()
    
    // 勝手に新しいインスタンスを作らせない
    private init() {}

    // --- ここから設定値 ---
    
    // Voice Host
    var vHost: String = UserDefaults.standard.string(forKey: "voice.host") ?? "localhost" {
        didSet {
            UserDefaults.standard.set(vHost, forKey: "voice.host")
        }
    }

    // Voice Port
    var vPort: String = UserDefaults.standard.string(forKey: "voice.port") ?? "8080" {
        didSet {
            UserDefaults.standard.set(vPort, forKey: "voice.port")
        }
    }
    
    // Tracking Host
    var tHost: String = UserDefaults.standard.string(forKey: "tracking.host") ?? "localhost" {
        didSet {
            UserDefaults.standard.set(tHost, forKey: "tracking.host")
        }
    }
    
    // Tracking Port
    var tPort: String = UserDefaults.standard.string(forKey: "tracking.port") ?? "8081" {
        didSet {
            UserDefaults.standard.set(tPort, forKey: "tracking.port")
        }
    }
    
    // Live ID
    var liveID: String = UserDefaults.standard.string(forKey: "liveID") ?? "" {
        didSet {
            UserDefaults.standard.set(liveID, forKey: "liveID")
        }
    }
}
