//
import Combine
import SwiftUI
import WatchConnectivity

struct ContentView: View {
    @ObservedObject var diary = WKDiaryViewModel.shared
    private let defaultEntriesCount = 40
    var body: some View {
        VStack {
            if diary.state == .error {
                errorView
            } else if diary.state == .loading {
                loadingView
            } else if diary.start > 0 {
                EntryList
            } else {
                NoEntriesView
            }
        }
        
        .navigationBarTitle(TXT.appName)
        .onAppear {
            self.diary.getNextEntries(count: self.defaultEntriesCount)
        }
    }
    
    var NoEntriesView: some View {
        VStack {
            Text(TXT.noEntriesWatch).font(.footnote)
            Spacer()
            actionButtons
        }
    }
    
    var loadingView: some View {
        ZStack {
            Text(TXT.loadEntries)
                .font(.headline)
                .offset(CGSize(width: 0, height: -32))
            
            ActivityIndicator().frame(width: 64, height: 64)
                .offset(CGSize(width: 0, height: 64))
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(Settings.version)
                        .font(.footnote)
                }
            }
        }
    }
    
    var errorView: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(TXT.error).font(.headline)
            Text(diary.errorMessage)
            Button(action: {
                self.diary.getNextEntries()
            }) {
                Text(TXT.retry)
            }
            Spacer()
        }.padding()
    }
    
    @State private var buttonOpacity: Double = 1
    
    var showButtonsCell: WKDiaryEntryViewModel? {
        self.diary.entries.count > 1 ? self.diary.entries[0] : nil
    }
    
    var hideButtonsCell: WKDiaryEntryViewModel? {
        self.diary.entries.count > 3 ? self.diary.entries[3] : nil
    }
    
    @State var showCompass: Bool = false
    
    var EntryList: some View {
        ZStack {
            List {
                Color.clear.frame(height: 64)
                    .onAppear { self.buttonOpacity = 1 }
                ForEach(self.diary.entries) { entry in
                    NavigationLink(destination:
                        DetailView(entry: entry)) {
                        CellView(entry: entry)
                            .onAppear {
                                if let lastEntry = self.diary.entries.last,
                                    entry == lastEntry {
                                    self.diary.getNextEntries(count: self.defaultEntriesCount)
                                }
                                if let cell = self.showButtonsCell, cell == entry {
                                    self.buttonOpacity = 1
                                }
                                
                                if let cell = self.hideButtonsCell, cell == entry {
                                    self.buttonOpacity = 0
                                }
                            }
                    }
                }
            }
            .listStyle(CarouselListStyle())
            
            VStack {
                actionButtons
                Spacer()
            }
            .opacity(buttonOpacity).animation(.easeOut)
            
            if self.diary.state == .loading {
                ActivityIndicator().frame(width: 64, height: 64)
            }
        }
    }
    
    var actionButtons: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color.action)
                .overlay(
                    VStack {
                        Image("AddLocationSmall").resizable().scaledToFit().frame(width: 24, height: 24)
                        Text(TXT.add)
                    }
                ).onTapGesture {
                    WatchManager.shared.saveCurrentPosition(onSuccess: { _ in
                        self.diary.reload()
                    })
                }
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color.actionSecondary)
                .overlay(
                    VStack {
                        Image(systemName: "arrow.counterclockwise").resizable().scaledToFit().frame(width: 24, height: 24)
                        Text(TXT.sync)
                    }
                ).onTapGesture {
                    self.diary.reload()
                }
        }
        .font(.footnote)
        .frame(height: 64)
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

struct Font_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            VStack {
                Text("headline").font(.headline)
                Text("large title").font(.largeTitle)
                Text("title").font(.title)
                Text("callout").font(.callout)
                Text("subheadline").font(.subheadline)
                Text("footnote").font(.footnote)
            }
            
            ContentView(diary: WKDiaryViewModel().loadDemoEntries(), showCompass: false)
        }
    }
}
