//
//  Created by Mihlali Mazomba on 2023/08/07.
//

import Combine
import XCTest

@testable import NASAWeatherApp


final class WeatherDataViewModelTest: XCTestCase {
    
    private var viewModel: MarsWeatherViewModel!
    private var interactor: MockWeatherService!
    private var delegate: MockDelegate!
    private var disposable = Set<AnyCancellable>()
    
    class MockDelegate: NSObject, ErrorHandlingDelegate {
        
        var didShowFailure = false
        var didRefreshView = false
        
        func showFailureMessage(withError error: ServiceError) {
            didShowFailure = true
        }
    }
    
    override func setUp()  {
        super.setUp()
        interactor = MockWeatherService()
        delegate = MockDelegate()
        viewModel = MarsWeatherViewModel(interactor: MockWeatherService(),
                                         delegate: delegate)
    }
    
    override func tearDown() {
        interactor = nil
        delegate = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testServiceErrorFailure() {
        let mockInteractor = MockWeatherService()
        mockInteractor.result = .failure(.serviceError)
        viewModel = MarsWeatherViewModel(interactor: mockInteractor, delegate: delegate)
        viewModel.fetchWeatherData()
        XCTAssertTrue(delegate.didShowFailure)
    }
    
    func testRefreshScreen() {
        var screenRefreshed = false
        viewModel
            .refreshForecastListSubject
            .sink { _ in
                screenRefreshed = true
            }
            .store(in: &disposable)
        interactor.result = .success(weatherItem)
        viewModel.fetchWeatherData()
        
        XCTAssertTrue(screenRefreshed)
    }
    
    let weatherItem = Weather(
        lastUpdated: "2022-13-07T22:00:00.000+0000",
        weatherStation: "NASA  Station",
        forecasts: [ForeCast(
            date: "2023-08-08T22:00:00.000+0000",
            temperature: 67.0,
            humidity: 40,
            windSpeed: 450,
            safe: false)])
}
