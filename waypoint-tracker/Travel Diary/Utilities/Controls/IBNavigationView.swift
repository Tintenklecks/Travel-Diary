//
//  IBNavigationView.swift
//  Pods-Travel Diary
//
//  Created by Ingo Böhme on 12.06.20.
//

import SwiftUI

struct IBNavigationView<Content, ActionView>: View where Content: View, ActionView: View {
    var title: String
    var actionView: ActionView
    let content: () -> Content

    var body: some View {
        NavigationView {
            ZStack {
                Color.neoWhite.edgesIgnoringSafeArea(.all)
                content()
                    .navigationBarTitle(
                        Text(" "), displayMode: .inline
                    )
                    .navigationBarItems(
                        leading: Text(title)
                            .modifier(HeadlineStyleModifier()),

                        trailing: actionView
                            .foregroundColor(.action)
                    )
            }
        }
    }
}

struct IBNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        IBNavigationView(title: "Hello World", actionView: Text("dsfs")) {
            Text("here I am")
        }
    }
}
