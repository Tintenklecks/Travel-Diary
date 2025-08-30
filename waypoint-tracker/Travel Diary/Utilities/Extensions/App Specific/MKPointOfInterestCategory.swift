
import MapKit

extension MKPointOfInterestCategory {
    static var all: [MKPointOfInterestCategory] {
        return loadLocal() ??
            [airport,
             amusementPark,
             aquarium,
             atm,
             bakery,
             bank,
             beach,
             brewery,
             cafe,
             campground,
             carRental,
             evCharger,
             fireStation,
             fitnessCenter,
             foodMarket,
             gasStation,
             hospital,
             hotel,
             laundry,
             library,
             marina,
             movieTheater,
             museum,
             nationalPark,
             nightlife,
             park,
             parking,
             pharmacy,
             police,
             postOffice,
             publicTransport,
             restaurant,
             restroom,
             school,
             stadium,
             store,
             theater,
             university,
             winery,
             zoo].sorted { $0.localized < $1.localized }
    }
    
    var localized: String {
        switch self {
        case .airport: return TXT.poiAirport
        case .amusementPark: return TXT.poiAmusementPark
        case .aquarium: return TXT.poiAquarium
        case .atm: return TXT.poiAtm
        case .bakery: return TXT.poiBakery
        case .bank: return TXT.poiBank
        case .beach: return TXT.poiBeach
        case .brewery: return TXT.poiBrewery
        case .cafe: return TXT.poiCafe
        case .campground: return TXT.poiCampground
        case .carRental: return TXT.poiCarRental
        case .evCharger: return TXT.poiEvCharger
        case .fireStation: return TXT.poiFireStation
        case .fitnessCenter: return TXT.poiFitnessCenter
        case .foodMarket: return TXT.poiFoodMarket
        case .gasStation: return TXT.poiGasStation
        case .hospital: return TXT.poiHospital
        case .hotel: return TXT.poiHotel
        case .laundry: return TXT.poiLaundry
        case .library: return TXT.poiLibrary
        case .marina: return TXT.poiMarina
        case .movieTheater: return TXT.poiMovieTheater
        case .museum: return TXT.poiMuseum
        case .nationalPark: return TXT.poiNationalPark
        case .nightlife: return TXT.poiNightlife
        case .park: return TXT.poiPark
        case .parking: return TXT.poiParking
        case .pharmacy: return TXT.poiPharmacy
        case .police: return TXT.poiPolice
        case .postOffice: return TXT.poiPostOffice
        case .publicTransport: return TXT.poiPublicTransport
        case .restaurant: return TXT.poiRestaurant
        case .restroom: return TXT.poiRestroom
        case .school: return TXT.poiSchool
        case .stadium: return TXT.poiStadium
        case .store: return TXT.poiStore
        case .theater: return TXT.poiTheater
        case .university: return TXT.poiUniversity
        case .winery: return TXT.poiWinery
        case .zoo: return TXT.poiZoo
        default:
            return ""
        }
    }
    
    static func loadLocal() -> [MKPointOfInterestCategory]? {
        let fileURL = FileManager.documentDirectoryURL.appendingPathComponent("pois")
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        guard let poiString = try? String(contentsOf: fileURL, encoding: .utf8) else {
            return nil
        }
        
        let poiArray = poiString.split(separator: ",")
            .map { MKPointOfInterestCategory(rawValue: String($0)) }
            .compactMap { $0 }
        
        if poiArray.count > 0 {
            return poiArray
        }
        
        return nil
    }
    
    static func saveLocal(pois: [MKPointOfInterestCategory]) {
        let fileURL = FileManager.documentDirectoryURL.appendingPathComponent("pois")
        let poiString = pois
            .map { $0.rawValue }
            .joined(separator: ",")
        try? poiString.write(to: fileURL, atomically: true, encoding: .utf8)
    }
}
