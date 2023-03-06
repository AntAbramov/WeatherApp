import UIKit

class NetworkService {
    
    private let session = URLSession.shared
    
    func obtainWeather(url: URL, completion: @escaping (Result<Weather, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = session.dataTask(with: request) { data, _, error in
            guard let data = data else {
                completion(.failure(APIError.invalidData))
                return
            }
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let weather = try? JSONDecoder().decode(Weather.self, from: data) {
                completion(.success(weather))
            } else {
                completion(.failure(APIError.decodingFailed))
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func obtainForecast(url: URL, completion: @escaping (Result<Forecast, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = session.dataTask(with: request) { data, _, error in
            guard let data = data else {
                completion(.failure(APIError.invalidData))
                return
            }
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let forecast = try? JSONDecoder().decode(Forecast.self, from: data) {
                completion(.success(forecast))
            } else {
                completion(.failure(APIError.decodingFailed))
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
}
