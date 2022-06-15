//
//  HotelsList.swift
//  InstaDev
//
//  Created by apple on 13.06.2022.
//

import Foundation

typealias Hotels = [Hotel]

struct Hotel: Codable {
    let id: Int
    let name: String
    let address: String
    let stars: Double
    let distance: Double
    let suitesAvailability: String

    enum CodingKeys: String, CodingKey {
        case id, name, address, stars, distance
        case suitesAvailability = "suites_availability"
    }
}
