import IBGeoSelection
import SwiftUI

struct GeoSelectionView: View {
    @Binding var selected: DestinationEditSelection
    let type: DestinationEditSelection
    @Binding var value: Double
    @State private var text: String = ""
    @State private var numericField: Bool = false
    var body: some View {
        VStack {
            HStack {
                Text(type.text).font(.headline).foregroundColor(Color.highlight)
                Spacer()
                if self.numericField {
                    IBTextField(
                        title: self.type.text,
                        text: $text,
                        showKeyboardButton: false,
                        showClearButton: true,
                        setFocus: false,
                        keyboardType: .decimalPad,
                        verticalPadding: 4
                    ) {
                        self.numericField = false
                        if let number = Double(self.text) {
                            self.value = number
                        } else {
                            self.text = String(self.value)
                        }
                    }
                    .frame(width: 128, height: 44)
                    .multilineTextAlignment(.trailing)
                    .onAppear {
                        self.text = self.value.roundedToSecondsString
                    }
                } else {
                    Button(action: {
                        withAnimation(Animation.easeOut(duration: 0.4)) {
                            self.selected = self.selected == self.type ? .none : self.type
                        }
                        
                    }) {
                        Text(type == .latitude ? value.latitudeString : value.longitudeString)
                            .padding(.trailing, 8)
                    }
                    .frame(height: 44)
                }
                
                Button(action: {
                    self.numericField.toggle()
                    self.selected = .none
                }) {
                    Image(systemName: self.numericField ? "keyboard.chevron.compact.down" : "keyboard")
                }
                
                Button(action: {
                    withAnimation(Animation.easeOut(duration: 0.4)) {
                        self.selected = self.selected == self.type ? .none : self.type
                        self.numericField = false
                    }
                    
                }) {
                    Image(systemName: self.selected == self.type ? "chevron.up" : "chevron.right")
                        .frame(width: 24)
                }
            }
            
            if self.selected == self.type {
                HStack {
                    Spacer()
                    GeoPickerView(degree: $value, isLatitude: self.selected == .latitude)
                }
                .onAppear {
                    self.numericField = false
                }
            }
        }
    }
}
