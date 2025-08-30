import SwiftUI

struct IBTextField: View {
    var title: String = ""
    @Binding var text: String

    var icon: Image?

    var showKeyboardButton: Bool = false
    var showClearButton: Bool = false
    var setFocus: Bool = false
    var keyboardType: UIKeyboardType = UIKeyboardType.alphabet

    var horizontalPadding: CGFloat = 8
    var verticalPadding: CGFloat = 8

    var onCommit: () -> () = {}

    @State private var firstTime = true
    @State private var hasFocus = true
    @State private var hideKeyboard = false

    var body: some View {
        VStack(spacing: verticalPadding) {
            HStack(alignment: .center) {
                if icon != nil {
                    icon!
                }

                TextField(title, text: $text, onCommit: {
                    self.hasFocus = false
                    self.onCommit()

                }).keyboardType(keyboardType)
                    .introspectTextField { textField in
                        if self.hideKeyboard {
                            textField.resignFirstResponder()
                            self.hideKeyboard = false
                        }
//                        if !self.hasFocus {
//                            textField.resignFirstResponder()
//                        } else if self.setFocus, self.firstTime {
////                            textField.becomeFirstResponder()
////                            self.firstTime = false
//                        }
                    }

                if self.showKeyboardButton {
                    Button(action: {
                        self.hideKeyboard = true
//                        self.hasFocus.toggle()
                    }) {
                        Image(systemName: "keyboard.chevron.compact.down")
                            .foregroundColor(.action)
                            .setAccessability(.hideKeyboard)
                            .offset(x: 0, y: 2)
                            .padding(.leading, 4)
                    }
                }

                if self.showClearButton {
                    if !text.isEmpty {
                        Button(action: {
                            self.text = ""

                        }) {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.action)
                                .setAccessability(.clearTextField)
                                .padding(.leading, 4)
                        }
                    }
                }
            }
            .padding(.horizontal, self.horizontalPadding)
            Color.info.frame(height: 0.5)
        }.onAppear {
            self.hasFocus = self.setFocus
        }
    }
}
