//
//  Created by Mihlali Mazomba on 2023/08/05.
//

import Foundation

enum ServiceError: Error {
    case serviceError
    case decodingError
    case corruptData
    case badURL
}

protocol CreditScoreProtocol {
    func fetchWeatherData(completion: @escaping(Result<Weather, ServiceError>) -> Void)
}

final class WeatherDataInteractor: CreditScoreProtocol  {
    
    private let scoreURL = "https://run.mocky.io/v3/1fd068d7-cbb2-4ceb-b697-da7fcc1c520b"
    
    func fetchWeatherData(
        completion: @escaping (Result<Weather, ServiceError>) -> Void) {
            
            guard let url = URL(string:  scoreURL) else {
                completion(.failure(.badURL))
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    completion(.failure(.serviceError))
                    return
                }
                guard let data = data else {
                    completion(.failure(.corruptData))
                    return
                }
                
                let decoder = JSONDecoder()
                
                guard let decodedWeatherData = try? decoder.decode(Weather.self, from: data) else {
                    completion(.failure(.decodingError))
                    return
                }
                completion(.success(decodedWeatherData))
                
            }.resume()
        }
}
