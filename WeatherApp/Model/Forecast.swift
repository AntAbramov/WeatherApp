// MARK: - Forecast
struct Forecast: Decodable {
    let cod: String?
    let message, cnt: Int?
    let list: [ListForecast]?
    let city: CityForecast?
}

struct CityForecast: Decodable {
    let id: Int?
    let name: String?
    let coord: CoordForecast?
    let country: String?
    let population, timezone, sunrise, sunset: Int?
}

struct CoordForecast: Decodable {
    let lat, lon: Double?
}

struct ListForecast: Decodable {
    let dt: Int?
    let main: MainForecast?
    let weather: [WeatherForecast]?
    let clouds: CloudsForecast?
    let wind: WindForecast?
    let visibility: Int?
    let pop: Double?
    let rain: RainForecast?
    let sys: SysForecast?
    let dtTxt: String?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}

struct CloudsForecast: Decodable {
    let all: Int?
}

struct MainForecast: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, seaLevel, grndLevel, humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

struct RainForecast: Decodable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

struct SysForecast: Decodable {
    let pod: String?
}

struct WeatherForecast: Decodable {
    let id: Int?
    let main, description, icon: String?
}

struct WindForecast: Decodable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}


// MARK: - Models for cells
struct HourlyForecastInfo {
    let time: String
    let icon: String
    let temp: String
}

struct FiveDaysForecastInfo {
    let dayTemp: String
    let nightTemp: String
    var iconName: String
    var weekDay: String
}
