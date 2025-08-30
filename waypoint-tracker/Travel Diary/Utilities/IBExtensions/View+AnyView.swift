import SwiftUI

@available(watchOS 6.0, *)
public extension View {
    /// Returns self as AnyView
    func asAnyView() -> AnyView {
        AnyView(self)
    }
}
