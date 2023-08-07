//
//  Created by Mihlali Mazomba on 2023/08/07.
//

@testable import NASAWeatherApp

final class MockWeatherService: CreditScoreProtocol {
    
    var result: Result<Weather, ServiceError>?
    
    func fetchWeatherData(
        completion: @escaping (Result<Weather, ServiceError>) -> Void) {
            guard let result = result  else { return }
            completion(result)
        }
}
