// MARK: - Weather
struct Weather: Decodable {
    let coord: Coordinate
    let weather: [WeatherElement]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let rain: Rain?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

// MARK: - Coordinate
struct Coordinate: Codable {
    let lon, lat: Double
}

struct Clouds: Decodable {
    let all: Int?
}

struct Main: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

struct Rain: Decodable {
    let the1H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

struct Sys: Decodable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
}

struct WeatherElement: Decodable {
    let id: Int?
    let main, description, icon: String?
}

struct Wind: Decodable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}
