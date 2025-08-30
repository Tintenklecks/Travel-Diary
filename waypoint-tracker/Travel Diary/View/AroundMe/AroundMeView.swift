import Combine
import CoreLocation
import SwiftUI

struct AroundMeView: View {
    @EnvironmentObject var settings: AppState
    @ObservedObject var viewModel = WikipediaViewModel()

    var body: some View {
        IBNavigationView(title: TXT.aroundYourLocation, actionView: Text("")) {
            ScrollView {
                if self.viewModel.state == .loaded {
                    WikipediaListView(wiki: self.viewModel)

                } else if self.viewModel.state == .loading {
                    LoadingView()
                } else if self.viewModel.state == .idle {
                    Text("")
                } else if self.viewModel.state == .error {
                    ErrorView(errormessage: self.viewModel.errorMessage)
                }
                Color.clear.frame(height: 1)
            }
        }

        .onAppear {
            self.viewModel.latitude = Settings.lastLocation.coordinate.latitude
            self.viewModel.longitude = Settings.lastLocation.coordinate.longitude

            self.viewModel.fetchData()
        }
    }
}

struct AroundMeView_Previews: PreviewProvider {
    static var previews: some View {
        AroundMeView()
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            Text(TXT.loadingWikiEntries)
                .foregroundColor(.activityDark)

            ActivityIndicator(type: .spinningCircles).frame(width: 64, height: 64)
                .foregroundColor(.activityDark)
            Spacer()
        }.frame(minHeight: 480)
    }
}

struct ErrorView: View {
    let errormessage: String
    var body: some View {
        Text(errormessage)
    }
}
