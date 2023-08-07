//
//  Created by Mihlali Mazomba on 2023/08/07.
//

import SnapshotTesting
import XCTest

@testable import NASAWeatherApp

class WeatherControllerTests: XCTestCase {
    
    var sut: NasaViewController!
    
    override func setUpWithError() throws {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyBoard.instantiateViewController(withIdentifier: "WeatherView") as? NasaViewController
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testViewControllerBackgroundColor() {
        assertSnapshot(matching: sut, as: .image)
    }
    
    func testSafeCollectionViewCell() {
        // given
        let cell = registerNib()
        
        // when
        cell.configure(
            with: ForeCast(
                date: "2023-12-09T22:00:00.000+0000",
                temperature: 78.0,
                humidity: 60,
                windSpeed: 3003,
                safe: true))
        
        // then
        assertSnapshot(matching: cell, as: .image)
    }
    
    func testNotSafeCollectionViewCell() {
        // given
        let cell = registerNib()
        
        // when
        cell.configure(
            with: ForeCast(
                date: "2024-13-09T22:00:00.000+0000",
                temperature: 78.0,
                humidity: 50,
                windSpeed: 3053,
                safe: false))
        
        // then
        assertSnapshot(matching: cell, as: .image)
    }
    
    private func registerNib() -> ForeCastViewCollectionViewCell {
        let viewFromXib = Bundle.main.loadNibNamed("ForeCastViewCollectionViewCell", owner: nil)?.first
        return viewFromXib as! ForeCastViewCollectionViewCell
    }
    
}
