//

import Foundation

import WatchConnectivity

enum WKError: Error {
    case invalidData
    case invalidSession
    case invalidResponse

    var localizedDescription: String {
        switch self {
        case .invalidData:
            return "Invalid data structure"
        case .invalidSession:
            return "Invalid phone-watch-session"
        case .invalidResponse:
            return "Error while receiving data"
        }
    }
}

class WatchManager: NSObject, WCSessionDelegate {
    static let shared = WatchManager()

    var session: WCSession?

    override init() {
        super.init()

        if WCSession.isSupported() {
            self.session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
}

// MARK: - Sending Data iPhone <-> Watch

extension WatchManager {
    func sendRequest(endpoint: String,
                     parameter: [String: Any],
                     reply: ((Any) -> Void)? = nil,
                     error: ((Error) -> Void)? = nil) {
        guard let session = session else { return }
        #if os(iOS)
        guard session.isPaired, session.isWatchAppInstalled else { return }
        #endif

        session.sendMessage([endpoint: parameter],
                            replyHandler: { result in
                                reply?(["result": result])
                            },
                            errorHandler: { error in
                                reply?(["error": error.localizedDescription])
        })
    }
}

// MARK: - WatchOS WCSessionDelegate methods

typealias WKActionType = [String: [String: Any]]

extension WatchManager {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        #if os(iOS)
        print("iPhone: Watch connection activated")
        #else
        print("WATCH: phone connection activated")
        #endif
    }

    #if os(iOS)

    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {}

    #endif

    func session(_ session: WCSession, didReceiveMessage: [String: Any]) {
        #if os(iOS)

        #else

        #endif
    }

    func session(_ session: WCSession,
                 didReceiveMessage message: [String: Any],
                 replyHandler: @escaping ([String: Any]) -> Void) {
        #if os(iOS)

        guard session.isPaired, session.isWatchAppInstalled else {

            replyHandler(["error": WKError.invalidSession.localizedDescription])
            return
        }
        #endif

        if let requests = message as? WKActionType {
            dispatchRequest(
                with: requests,
                onSuccess: { result in
                    if let json = String(data: result, encoding: .utf8) {

                        replyHandler(["success": json])
                    } else {

                        replyHandler(["error": WKError.invalidData.localizedDescription])
                    }
                }, onError: { error in
                    replyHandler(["error": error.localizedDescription])
            })
        }
        #if os(iOS)

        replyHandler(["von ios": "Data"])
//        #elseif os(watchOS)
//        replyHandler(["von watchos": "Data"])
        #endif
    }

    func sessionWatchStateDidChange(_ session: WCSession) {}

    func sessionReachabilityDidChange(_ session: WCSession) {}

    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {}

    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {}

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {}

    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {}

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {}

    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {}

    func session(_ session: WCSession, didReceive file: WCSessionFile) {}
}
