//
//  Created by Mihlali Mazomba on 2023/08/06.
//

import Foundation
import Combine

protocol ErrorHandlingDelegate: NSObject {
    func showFailureMessage(withError error: ServiceError)
}

final class MarsWeatherViewModel {
    
    private var interactor: CreditScoreProtocol
    private(set) var weatherData: Weather?
    private(set) var refreshForecastListSubject =  CurrentValueSubject<[ForeCast], Never>([])
    private weak var delegate: ErrorHandlingDelegate?
    
    init(interactor: CreditScoreProtocol, delegate: ErrorHandlingDelegate?) {
        self.interactor = interactor
        self.delegate = delegate
    }
    
    var forecastList: [ForeCast]? {
       return refreshForecastListSubject.value
    }
    
    var weatherStationName: String {
        return weatherData?.weatherStation ?? "NASA Mars North Weather Station"
    }
    
    func fetchWeatherData() {
        interactor
            .fetchWeatherData { [weak self] result in
                switch result {
                case .success(let data):
                    self?.weatherData = data
                    self?.refreshForecastListSubject.send(data.forecasts)
                case .failure(let error):
                    self?.delegate?.showFailureMessage(withError: error)
                }
            }
    }
}
