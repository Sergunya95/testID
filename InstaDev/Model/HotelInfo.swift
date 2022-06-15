//
//  HotelInfo.swift
//  InstaDev
//
//  Created by apple on 15.06.2022.
//

import Foundation

// MARK: - HotelInfo
struct HotelInfo: Codable {
    let id: Int
    let name: String
    let address: String
    let stars: Double
    let distance: Double
    var image: String
    let suitesAvailability: String
    let lat: Double
    let lon: Double

    enum CodingKeys: String, CodingKey {
        case id, name, address, stars, distance, image
        case suitesAvailability = "suites_availability"
        case lat, lon
    }
}
