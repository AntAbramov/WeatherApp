import UIKit

class NetworkService {
    
    private let session = URLSession.shared
    
    func obtainData(url: URL, completion: @escaping (Result<Weatherr, Error>) -> Void) {
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, _, error in
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let weather = try? JSONDecoder().decode(Weatherr.self, from: data) {
                completion(.success(weather))
            } else {
                completion(.failure(NetworkError.decodingFailed))
            }
        }
        task.resume()
        
    }
    
    func obtainDataSync(urls: [URL], completion: @escaping (Result<[Weatherr], NetworkError>) -> Void) {
        
    }
    
}
