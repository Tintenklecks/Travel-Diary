import Combine
import Network

enum NetworkConnectionStatus {
    case wifi
    case cellular
    case wiredEthernet
    case loopback
    case other
    case none

    static func networkType(status: NWInterface.InterfaceType?) -> NetworkConnectionStatus {
        guard let status = status else {
            return .none
        }
        switch status {
        case .wifi: return .wifi
        case .cellular: return .cellular
        case .wiredEthernet: return .wiredEthernet
        case .loopback: return .loopback
        default:
            return .other
        }
    }

    var description: String {
        switch self {
        case .wifi: return "WiFi"
        case .cellular: return "Cellular"
        case .wiredEthernet: return "Ethernet"
        case .loopback: return "Loopback"
        default: return "other"
        }
    }
}

typealias NetworkStatus = (Bool, NetworkConnectionStatus)

class NetworkStatusViewModel: NSObject, ObservableObject {
    let networkStatusPublisher = PassthroughSubject<NetworkStatus, Never>()
    @Published var status: NetworkConnectionStatus = .none
    @Published var isOnline: Bool = false

    override init() {
        super.init()
        NetStatus.shared.netStatusChangeHandler = {
            DispatchQueue.main.async {
                self.status = NetworkConnectionStatus.networkType(status: NetStatus.shared.interfaceType)
                self.isOnline = NetStatus.shared.isConnected
                self.networkStatusPublisher.send(
                    (NetStatus.shared.isConnected,
                     NetworkConnectionStatus.networkType(status: NetStatus.shared.interfaceType))
                )
            }
        }
        NetStatus.shared.startMonitoring()
    }
    
    func start() {
           if !NetStatus.shared.isMonitoring {
               NetStatus.shared.startMonitoring()
           }
       }
    func stop() {
           if NetStatus.shared.isMonitoring {
               NetStatus.shared.stopMonitoring()
           }
       }
}
