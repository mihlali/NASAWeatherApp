//
//  Created by Mihlali Mazomba on 2023/08/06.
//

import UIKit

final class ForeCastViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var safetyIcon: UIImageView!
    @IBOutlet private var temperatureLabel: UILabel!
    @IBOutlet private var windLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var humidityLabel: UILabel!
    @IBOutlet private var dangerLabel: UILabel!
    
    
    var cornerRadius: CGFloat = 14.0
    
    var viewModel: WeatherCollectionViewCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    }
    
    private func configureUI() {
        
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.30
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
    }
    
    private func configureLayout() {
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
    }
    
    func configure(with weatherForecast: ForeCast) {
        viewModel = WeatherCollectionViewCellViewModel(weatherForCast: weatherForecast)
        safetyIcon.image = viewModel?.icon
        temperatureLabel.text = viewModel?.temperatureValue
        windLabel.text = viewModel?.wind
        dateLabel.text = viewModel?.dateForForcast
        humidityLabel.text = viewModel?.humidity
        contentView.backgroundColor = viewModel?.backGroundColor
        dangerLabel.isHidden = viewModel?.isSafe ?? true
        dangerLabel.text = viewModel?.dangerString
    }
}
