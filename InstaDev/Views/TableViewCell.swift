//
//  TableViewCell.swift
//  InstaDev
//
//  Created by apple on 14.06.2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var suitesAvailabilityLabel: UILabel!
    @IBOutlet weak var starsStack: UIStackView!
    
    //MARK: - Methods
    func configure(with hotel: Hotel) {
        nameLabel.text = hotel.name
        addressLabel.text = hotel.address
        distanceLabel.text = "Расстояние до центра \(String(hotel.distance)) м"
        let newSuitesAvailability = (hotel.suitesAvailability.trimmingCharacters(in: .punctuationCharacters)).replacingOccurrences(of: ":", with: ",").stringToArray()
        suitesAvailabilityLabel.text = "Свободных номеров: \(String(newSuitesAvailability.count))"
        starsStack.subviews.forEach { $0.removeFromSuperview() }
        if hotel.stars < 1 {
            let star = UIImageView(image: UIImage(systemName: "star"))
            star.tintColor = .lightGray
            starsStack.addArrangedSubview(star)
        } else if  hotel.stars >= 1 {
            for _ in 1...Int(hotel.stars) {
                let starFill = UIImageView(image: UIImage(systemName: "star.fill"))
                starFill.tintColor = .systemYellow
                starsStack.addArrangedSubview(starFill)
            }
        }
    }
}
