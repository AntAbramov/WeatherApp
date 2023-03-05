import UIKit

enum UrlType {
    case weather
    case forecast
    
    var baseUrl: String {
        return "https://api.openweathermap.org"
    }
    
    var path: String {
        switch self {
        case .weather:  return "/data/2.5/weather?"
        case .forecast: return "/data/2.5/forecast?"
        }
    }
    
    var apiKey: String {
        return "apiKey"
    }
    
    func configureUrl(with coordinate: Coordinate) -> URL? {
        let lat = "lat=\(coordinate.lat)"
        let lon = "&lon=\(coordinate.lon)"
        let appid = "&appid="
        let units = "&units=metric"
        let urlString = baseUrl + path + lat + lon + appid + apiKey + units
        return URL(string: urlString)
    }
    
}
