//
//  Created by Mihlali Mazomba on 2023/08/06.
//

import Foundation
import UIKit

class WeatherCollectionViewCellViewModel {
    
    private var weatherForCast: ForeCast
    
    init(weatherForCast: ForeCast) {
        self.weatherForCast = weatherForCast
    }
    
    var isSafe: Bool {
        return weatherForCast.safe
    }
    
    var dangerString: String {
        return "NOT SAFE"
    }
    
    var backGroundColor: UIColor? {
        if !isSafe {
            return .red
        }
        
        return nil
    }
    
    var icon: UIImage {
        guard let correctImage = UIImage(named: "correct"),
              let warningImage = UIImage(named: "exclamation") else { return UIImage()}
        
        return isSafe ? correctImage : warningImage
    }
    
    var temperatureValue: String {
        return "\(Int(weatherForCast.temperature))°"
    }
    
    var dateForForcast: String  {
        return weatherForCast.date.convertToCorrectFormat()
    }
    
    var humidity: String {
        return weatherForCast.humidity.description
    }
    
    var wind: String {
        return weatherForCast.windSpeed.description
    }
}
