//
import Combine
//  Copyright Ingo Böhme Mobil 2020. All rights reserved.
import SwiftUI

struct EntryEditView: View {
    @ObservedObject var viewModel: EntryEditViewModel
    var onlyLocation: Bool = true
    @Binding var toggle: Bool
    @State var firstTime = true

    @EnvironmentObject var diaryEntry: DiaryEntryViewModel

    @State private var keyboardHeight: CGFloat = 0
    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
                .map { $0.height },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        ).eraseToAnyPublisher()
    }

    var body: some View {
        VStack(spacing: 0) {
            actionSheetHeader
            ScrollView {
                VStack(alignment: .leading) {
                    Text(TXT.locationName)
                        .font(.headline)

                    IBTextField(title: TXT.locationDescription,
                                text: self.$viewModel.name,
                                showKeyboardButton: false,
                                showClearButton: true,
                                setFocus: false) {
                                    self.save()
                                    self.toggle.toggle()
                    }

                    if !onlyLocation {
                        Divider().padding(32)
                        Text(TXT.headline).font(.headline)

                        IBTextField(title: TXT.headlineForYourNote,
                                    text: self.$viewModel.headline,
                                    showClearButton: true) {
                                        self.save()
                                        self.toggle.toggle()
                        }

                        Text(TXT.notes).font(.headline)
                        UITextViewWrapper(text: self.$viewModel.text) {}
                            .modifier(TextFieldModifier())
                            .modifier(ClearButtonModifier(text: self.$viewModel.text))
                            .frame(height: 200)
                    }
                }
                .padding(32)
                .padding(.bottom, keyboardHeight)
                .onReceive(keyboardHeightPublisher) { self.keyboardHeight = $0 }
            }
        }
        .background(Color.neoWhite.edgesIgnoringSafeArea(.all))
    }

    func save() {
        if self.viewModel.name != self.diaryEntry.locationName {
            Location.update(location: self.viewModel.id, with: self.viewModel.name)
        }

        if self.diaryEntry.text != self.viewModel.text ||
            self.diaryEntry.headline != self.viewModel.headline {
            self.diaryEntry.text = self.viewModel.text
            self.diaryEntry.headline = self.viewModel.headline
            self.diaryEntry.save()
        }
    }

    var actionSheetHeader: ActionSheetHeader {
        ActionSheetHeader(
            title: self.viewModel.name,
            leftButtonSystemImage: "xmark",
            leftAccessability: .closeDialogButton,
            rightButtonSystemImage: "checkmark",
            rightAccessability: .saveEntryButton
        ) { button in
            if button == ActionSheetHeader.Buttons.right {
                self.save()
            }

            self.toggle.toggle()
        }
    }
}
