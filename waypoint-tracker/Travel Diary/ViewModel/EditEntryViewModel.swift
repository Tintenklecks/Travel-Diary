 //
 //  Copyright Ingo Böhme Mobil 2020. All rights reserved.
 import SwiftUI
import Combine
import os.log

///
/// # EntryEditViewModel
// swiftlint:disable unused_closure_parameter
// swiftlint:disable file_length


protocol EntryEditViewModelVM {

}


class EntryEditViewModel: ObservableObject {
    @Published var id: String
    @Published var name: String
    
    @Published var headline: String = ""
    @Published var text: String = ""

    init(id: String, name: String, headline: String = "", text: String = "") {
        self.id = id
        self.name = name
        self.headline = headline
        self.text = text
    }
    
}

extension EntryEditViewModel: Hashable {
  
    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
    }
}

extension EntryEditViewModel: Equatable {

  static func == (lhs: EntryEditViewModel, rhs: EntryEditViewModel) -> Bool {
//        return lhs.id == rhs.id
        return true
    }
}


extension EntryEditViewModel {
    // whatever
}
