
import SwiftUI

struct TabBarView: View {
    @Binding var selectedItem: TabBarViews

    var tabBarItems: [TabBarItemView]

    var body: some View {
        HStack {
            Spacer()
            ForEach(tabBarItems, id: \.uuid) { item in
                HStack {
                    item

                    Spacer()
                }
            }
        }
        .padding(.top, 11)
        .padding(.bottom, 22)
        .background(Color.neoWhite.opacity(0.95))
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(
            selectedItem: .constant(.waypoints),
            tabBarItems: [
                TabBarItemView(
                    selectedItem: .constant(.waypoints),
                    smartView: .waypoints,
                    icon: "pencil.tip"),
                TabBarItemView(
                    selectedItem: .constant(.waypoints),
                    smartView: .logs,
                    icon: "alarm"),
                TabBarItemView(
                    selectedItem: .constant(.waypoints),
                    smartView: .settings,
                    icon: "gear")
            ])
    }
}
