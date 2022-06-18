//
//  DetailViewController.swift
//  InstaDev
//
//  Created by apple on 15.06.2022.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {

    //MARK: - Properties
    public var detail: HotelInfo?
    private var activityIndicator: UIActivityIndicatorView!
    private let hotel: Hotel
    
    //MARK: - Init
    init(hotel: Hotel) {
        self.hotel = hotel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDetail()
        fetchImage()
        activityIndicator = showSpinner(in: view)
    }
    
    //MARK: - Elements
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        return nameLabel
    }()
    
    private let addressLabel: UILabel = {
        let addressLabel = UILabel()
        addressLabel.numberOfLines = 0
        return addressLabel
    }()
    
    private let distanceLabel: UILabel = {
        let distanceLabel = UILabel()
        return distanceLabel
    }()
    
    private let suitesAvailabilityLabel: UILabel = {
        let suitesAvailabilityLabel = UILabel()
        suitesAvailabilityLabel.numberOfLines = 0
        return suitesAvailabilityLabel
    }()
    
    //MARK: - Methods
    func configureDetail() {
        
        self.view.backgroundColor = .white
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.equalTo(safeArea).inset(16)
            make.top.equalTo(safeArea).inset(16)
            make.height.equalTo((UIScreen.main.bounds.width - 32) * 0.56)
        }
        
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(safeArea).inset(16)
            make.top.equalTo(imageView.snp.bottom).inset(-16)
        }
        
        self.view.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.left.right.equalTo(safeArea).inset(16)
            make.top.equalTo(nameLabel.snp.bottom).inset(-16)
        }
        
        self.view.addSubview(distanceLabel)
        distanceLabel.snp.makeConstraints { make in
            make.left.right.equalTo(safeArea).inset(16)
            make.top.equalTo(addressLabel.snp.bottom).inset(-16)
        }
        
        self.view.addSubview(suitesAvailabilityLabel)
        suitesAvailabilityLabel.snp.makeConstraints { make in
            make.left.right.equalTo(safeArea).inset(16)
            make.top.equalTo(distanceLabel.snp.bottom).inset(-16)
        }
    
        let detailVC = DetailViewController(hotel: hotel)
        let request = URL(string: "https://bitbucket.org/instadevteam/tests/raw/63a9ecea18ca79c275a2eeafd95bc37f857cf2ec/1.2/\(String(describing: hotel.id)).json")
        let task = URLSession.shared.dataTask(with: request!) { [weak self] data, response, error in
            
            if let data = data, let hotelInfo = try? JSONDecoder().decode(HotelInfo.self, from: data) {
                detailVC.detail = hotelInfo
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.activityIndicator.stopAnimating()
                    self.nameLabel.text = self.hotel.name //self.detail?.name //String(hotel.id)
                    self.addressLabel.text = self.hotel.address //self.detail?.address
                    self.distanceLabel.text = "Расстояние до центра \(self.detail?.distance ?? 0) м"
                    let newSuitesAvailability = (self.detail?.suitesAvailability?.trimmingCharacters(in: .punctuationCharacters) ?? "Отсутствуют").replacingOccurrences(of: ":", with: ", ")
                    self.suitesAvailabilityLabel.text = "Свободны номерa: \(newSuitesAvailability)"
                }
            }
        }
        task.resume()
    }
    
    private func showSpinner(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        return activityIndicator
    }
    
    func fetchImage() {
        guard let url = URL(string: "https://bitbucket.org/instadevteam/tests/raw/63a9ecea18ca79c275a2eeafd95bc37f857cf2ec/1.2/\(detail?.image ?? "1")")
        else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.activityIndicator.stopAnimating()
                    let croppedImage = image.cropImage()
                    self.imageView.image = croppedImage
                }
            }
        }
        task.resume()
    }
}



