import Foundation

class WIKIService {
    private func url(language: String = "en", latitude: Double, longitude: Double) -> URL? {
        return URL(
            string: "https://\(language).wikipedia.org/w/api.php?ggscoord=\(latitude)|\(longitude)&action=query&prop=coordinates|pageimages|pageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json".replacingOccurrences(of: "|", with: "%7C")
        )
    }
    
    func fetchAPIData(at latitude: Double, longitude: Double, completion: @escaping (WIKIResult?) -> ()) {
        guard let url = url(latitude: latitude, longitude: longitude) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let model = try JSONDecoder().decode(WIKIResult.self, from: data)
                completion(model)
            } catch let error  {
                print("#\(error)")
                completion(nil)
            }
            
        }.resume()
    }
}
