
import SwiftUI

struct WikipediaListView: View {
    let wiki: WikipediaViewModel
   // @EnvironmentObject var locationPoint: LocationPoint

    var body: some View {
        VStack {
            ForEach(wiki.pages) { page in

                WikiEntryView(page: page) //.environmentObject(self.locationPoint)

                Divider().padding(.leading, 64)
            }
        }
        .padding()
    }
}
