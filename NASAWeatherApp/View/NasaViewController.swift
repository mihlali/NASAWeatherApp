//
//  ViewController.swift
//  NASAWeatherApp
//
//  Created by Mihlali Mazomba on 2023/08/06.
//

import UIKit
import Combine

enum Style {
    static var backgroundColor = UIColor(named: "BlueBackGroundColor")
    
    static func viewSize(frameWidth: CGFloat) -> CGSize {
        let width = (frameWidth - 30) / 2
        let height = width
        return CGSize(width: width , height: height)
    }
}

class NasaViewController: UIViewController {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    
    private var cancellables = Set<AnyCancellable>()
    
    lazy var viewModel = MarsWeatherViewModel(
        interactor: WeatherDataInteractor(),
        delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        registerCell()
        bind()
        viewModel.fetchWeatherData()
    }
    
    private func bind() {
        viewModel
            .refreshForecastListSubject
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    private func configureView() {
        titleLabel.text = viewModel.weatherStationName
        self.view.backgroundColor = Style.backgroundColor
        self.collectionView.backgroundColor = Style.backgroundColor
    }
    
    private func registerCell() {
        let customCellNib = UINib(nibName: "ForeCastViewCollectionViewCell", bundle: .main)
        collectionView.register(customCellNib, forCellWithReuseIdentifier: "CustomCell")
    }
}

extension NasaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.forecastList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: "CustomCell",
                for: indexPath) as? ForeCastViewCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let list = viewModel.forecastList else { return UICollectionViewCell() }
        cell.configure(with: list[indexPath.row])
        
        return cell
    }
}

extension NasaViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            return Style.viewSize(frameWidth: view.frame.size.width)
        }
}

extension NasaViewController: ErrorHandlingDelegate {
    
    func showFailureMessage(withError error: ServiceError) {
        
        var errorMessage = ""
        switch error {
        case .serviceError:
            errorMessage = "We can not process your request right now, please Wait while we try again "
        default:
            errorMessage = "Something has gone wrong,please Wait while we try again"
        }
        
        let message = UIAlertController(title: "Error" , message: errorMessage, preferredStyle: .alert)
        
        let OkAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if error == .serviceError  {
                self?.viewModel.fetchWeatherData()
            }
        }
        message.addAction(OkAction)
        self.present(message, animated: true, completion: nil)
    }
}
