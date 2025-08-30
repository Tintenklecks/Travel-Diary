import SwiftUI

enum TabBarItems: Int {
    case diary = 0
    case aroundMe
    case clusterMap
    case settings
}

struct CustomTabsView: View {
    @Binding var index: TabBarItems
    var keyAction: () -> () = {}
    
    static let radius: CGFloat = 44
    static let height: CGFloat = 52
    
    private var imageWidth: CGFloat {
        return max(CustomTabsView.radius / 2, 16)
    }
    
    private var buttonWidth: CGFloat {
        return CustomTabsView.radius * 3 / 4
    }
    
    var plusButton: some View {
        Button(action: { self.keyAction() }) {
            Image("AddLocation")
                .resizable()
                .scaledToFit()
                .setAccessability(.tabBarPlus)
                .frame(width: buttonWidth, height: buttonWidth)
                .foregroundColor(.actionInvers)
                .padding(CustomTabsView.radius / 2 - 2)
        }
        .background(Color.action)
        .clipShape(Circle())
        .offset(y: -CustomTabsView.radius / 2)
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            HStack {
                TabBarButton(selectedIndex: $index, index: .diary,
                             image: Image(systemName: "house.fill"))
                    .setAccessability(.tabBarHome)
                
                Spacer(minLength: 0)
       
                TabBarButton(selectedIndex: $index, index: .clusterMap,
                             image: Image(systemName: "map.fill"))
                    .setAccessability(.tabBarMap)

                
                Spacer(minLength: 0)
                
                plusButton
                    .setAccessability(.toggleLayout)
                    
                    .offset(x: 0, y: -(CustomTabsView.height - CustomTabsView.radius) / 2)
                
                Spacer(minLength: 0)

                TabBarButton(selectedIndex: $index, index: .aroundMe,
                             image: Image("aroundMe"))
                    .setAccessability(.tabBarAroundme)

                
                Spacer(minLength: 0)
                
                TabBarButton(selectedIndex: $index, index: .settings,
                             image: Image(systemName: "safari"))
                    .setAccessability(.tabBarCompass)
            }
            .frame(height: CustomTabsView.height)
            .padding(.horizontal, CustomTabsView.radius / 2)
            .padding(.top, CustomTabsView.radius)
            .background(Color.neoWhite)
            .clipShape(CShape())
            
            if !Fastlane.isScreenshotMode {
                Text(Settings.version).font(Font.system(size: 8, weight: .light, design: .monospaced)).foregroundColor(.red).padding(.trailing, 2)
            }
        }
    }
}

struct TabBarButton: View {
    @Binding var selectedIndex: TabBarItems
    let index: TabBarItems
    let image: Image
    let imageWidth = max(CustomTabsView.radius / 2, 16)
    var body: some View {
        Button(action: { self.selectedIndex = self.index }) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: imageWidth, height: imageWidth)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
        }
        .foregroundColor((self.index == self.selectedIndex) ? .highlight : .action)
        //        .foregroundColor(Color.primaryText.opacity(self.index == self.selectedIndex ? 1 : 0.3))
    }
}

struct CShape: Shape {
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: CustomTabsView.radius))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: CustomTabsView.radius))
            
            path.addArc(center: CGPoint(x: rect.width / 2, y: CustomTabsView.radius),
                        radius: CustomTabsView.radius,
                        startAngle: .zero,
                        endAngle: .init(degrees: 180),
                        clockwise: true)
        }
    }
}
