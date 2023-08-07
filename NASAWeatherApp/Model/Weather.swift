//
//  Created by Mihlali Mazomba on 2023/08/05.
//

import Foundation

struct Weather: Decodable {
    var lastUpdated: String
    var weatherStation: String
    var forecasts: [ForeCast]
}

struct ForeCast: Decodable {
    var date: String
    var temperature: Double
    var humidity: Int
    var windSpeed:Int
    var safe: Bool
    
    enum CodingKeys: String, CodingKey {
        case date
        case temperature = "temp"
        case humidity
        case windSpeed
        case safe
    }
}
