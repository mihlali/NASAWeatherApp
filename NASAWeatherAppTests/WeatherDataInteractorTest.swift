//
//  Created by Mihlali Mazomba on 2023/08/07.
//

import XCTest

@testable import NASAWeatherApp

final class WeatherDataInteractorTest: XCTestCase {
    
    private var interactor: MockWeatherService!
    
    override func setUp() {
        super.setUp()
        interactor = MockWeatherService()
    }
    
    override func tearDown() {
        interactor = nil
        super .tearDown()
    }
    
    func testFetchWeatherEmptyUrl() {
        let testExpectation = expectation(description: "Fetching Weather Failed bad URL")
        interactor.result = .failure(.badURL)
        interactor.fetchWeatherData(completion: { result in
            switch result {
            case .failure(let error):
                guard error == .badURL else {
                    testExpectation.fulfill()
                    return
                }
            case .success(_):
                XCTFail()
                testExpectation.fulfill()
            }
            testExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchWeathersWithFailure() {
        let testExpectation = expectation(description: "Fetching Events Failed")
        interactor.result = .failure(.serviceError)
        interactor.fetchWeatherData(completion: { result in
            switch result {
            case .failure(let error):
                guard error == .serviceError else {
                    testExpectation.fulfill()
                    return
                }
            case .success(_):
                XCTFail("should have been a failure")
                testExpectation.fulfill()
            }
            testExpectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchEventsWithSuccess() {
        let testExpectation = expectation(description: " Success")
        interactor.result = .success(weatherItem)
        interactor
            .fetchWeatherData(completion: { results in
                switch results {
                case.success(_) :
                    testExpectation.fulfill()
                case .failure(_):
                    testExpectation.fulfill()
                }
            })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    let weatherItem = Weather(
        lastUpdated: "2020-11-07T22:00:00.000+0000",
        weatherStation: "NASA Mars North Weather Station",
        forecasts: [ForeCast(
            date: "2020-11-08T22:00:00.000+0000",
            temperature: 56.0,
            humidity: 20,
            windSpeed: 250,
            safe: true)])
}
