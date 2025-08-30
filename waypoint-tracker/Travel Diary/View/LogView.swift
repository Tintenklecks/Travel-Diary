 //  Travel-Diary
//
 //  Copyright © 2020 Ingo Böhme. All rights reserved.
 import CoreLocation
import SwiftUI

struct LogView: View {
    @State private var text = ""
    @ObservedObject var locationPublisher = LocationPublisher()

    var body: some View {
        ScrollView {
            Text(locationPublisher.status.name).foregroundColor(Color.red)
            HStack {
                Text("Log File").font(.headline)
                Spacer()
                Button(action: {
                    self.text = String.readFromLog()

                }) {
                    Text("Reload")
                }
            }
            Text(text)
                .font(.caption)
                .lineLimit(99999)
                .layoutPriority(100)
        }
        .sheet(isPresented: $locationPublisher.statusChanged, onDismiss: {
            self.locationPublisher.checkState()
        }) {
            Text("Here we go")
        }
        .padding()
        .onAppear {
            self.text = Date().longTime + "\n" + String.readFromLog()
        }
    
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
