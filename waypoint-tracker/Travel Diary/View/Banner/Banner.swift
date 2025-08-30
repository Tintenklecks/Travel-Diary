#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif
import SwiftUI
import UIKit

struct Banner: View {
    #if canImport(GoogleMobileAds)
    @State private var showFullVersionSheet = false
    var body: some View {
        VStack {
            if Settings.numberOfStarts > 20 {
                HStack {
                    Spacer()
                    BannerVC().frame(width: 320, height: 50, alignment: .center)
                    Spacer()
                }
                Button(TXT.noAds) {
                    self.showFullVersionSheet.toggle()
                }
                .font(.callout)
                .padding(.bottom, 16)
            } else {
                Color.clear.frame(width: 1, height: 1)
            }
        }
        .sheet(isPresented: self.$showFullVersionSheet) {
            BuyFullVersionView()
        }
    }

    #else
    var body: some View {
        Color.clear.frame(width: 0, height: 0)
    }
    #endif
}

#if canImport(GoogleMobileAds)

private final class BannerVC: UIViewControllerRepresentable {
    #if DEBUG
    let bannerId = "ca-app-pub-3940256099942544/2934735716" // TEST ADD
    #else
    let bannerId = "ca-app-pub-2982630728254770/6668756728" // Just a Banner
    #endif

    func makeUIViewController(context: Context) -> UIViewController {
        var testDeviceIdentifiers: [String] = []

        #if targetEnvironment(simulator)
        if let simulatorId = kGADSimulatorID as? String {
            testDeviceIdentifiers.append(simulatorId)
        }
        #else
        testDeviceIdentifiers.append("fc4d29a91ccb24ce4e3cc0e3b32d968e") // FAT LADY
        #endif

        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = testDeviceIdentifiers

        let view = GADBannerView(adSize: kGADAdSizeBanner)

        let viewController = UIViewController()
        view.adUnitID = bannerId
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: kGADAdSizeBanner.size)
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
#endif

struct Banner_Previews: PreviewProvider {
    static var previews: some View {
        Banner()
    }
}
