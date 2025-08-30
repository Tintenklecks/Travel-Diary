import SwiftUI
import IBExtensions

public struct GeoPickerView: View {
    @Binding var degreeValue: Double
    var isLatitude: Bool
    
    public init(degree value: Binding<Double>, isLatitude: Bool) {
        self._degreeValue = value
        self.isLatitude = isLatitude
    }
    
    @State private var initialized = false
    
    @State private var degree: Int = 0
    @State private var sign: Int = 0
    @State private var minute: Int = 0
    @State private var second: Int = 0
    
    private let latitudeRange = Range(0...89)
    private let longitudeRange = Range(0...179)
    private let fragmentRange = Range(0...59)
    
    private func updateDegree() {
        let arcSecond: Double = 1 / 3600
        if initialized {
            
            let newDegree = Double(sign: sign, degree: degree, minute: minute, second: second)
            if abs(newDegree - degreeValue) > arcSecond {
                degreeValue = newDegree
            }
        }
    }
    
    private func initialize() {
        (sign, degree, minute, second) = degreeValue.degree
        initialized = true
    }
    
    public var body: some View {
        HStack {
            Picker("Latitude", selection: self.$degree) {
                ForEach(self.isLatitude ? self.latitudeRange : self.longitudeRange) { degree in
                    Text("\(degree)°").tag(degree)
                }
            }
            .labelsHidden()
            .frame(width: 60)
            .clipped()
            .onAppear {
                self.initialize()
            }
            .onReceive([self.degree].publisher, perform: { _ in self.updateDegree() })
            
            Picker("North or South", selection: self.$sign) {
                Text(self.isLatitude ? "N" : "E").tag(1)
                Text(self.isLatitude ? "S" : "W").tag(-1)
            }
            .labelsHidden()
            .frame(width: 40)
            .clipped()
            .onReceive([self.sign].publisher, perform: { _ in self.updateDegree() })
            
            Picker("Minutes", selection: self.$minute) {
                ForEach(self.fragmentRange) { minute in
                    Text("\(minute)'").tag(minute)
                }
            }
            .labelsHidden()
            .frame(width: 60)
            .clipped()
            .onReceive([self.minute].publisher, perform: { _ in self.updateDegree() })
            
            Picker("Seconds", selection: self.$second) {
                ForEach(self.fragmentRange) { second in
                    Text("\(second)\"").tag(second)
                }
            }
            .labelsHidden()
            .frame(width: 60)
            .clipped()
            .onReceive([self.second].publisher, perform: { _ in self.updateDegree() })
        }
    }
}

@available(iOS 13.0.0, *)
struct GeoPicker_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GeoPickerView(degree: .constant(48.566), isLatitude: true)
            GeoPickerView(degree: .constant(7.48), isLatitude: false)
        }
    }
}
