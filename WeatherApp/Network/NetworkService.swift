import UIKit

class NetworkService {
    
    private let session = URLSession.shared
    
    func obtainData(url: URL, completion: @escaping (Result<Weather, Error>) -> Void) {
        let request = URLRequest(url: url)
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
        }
        task.resume()
    }
    
}
