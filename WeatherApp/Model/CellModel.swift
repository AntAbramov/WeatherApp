// MARK: - Models for cells
struct HourlyForecast {
    let time: String
    let icon: String
    let temp: String
}

struct DailyForecast {
    let dayTemp: String
    let nightTemp: String
    var iconName: String
    var weekDay: String
}
