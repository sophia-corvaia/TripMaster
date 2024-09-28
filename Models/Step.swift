//
//  Step.swift
//  TripMaster
//
//  Created by Sophia on 16/09/24.
//

import Foundation

struct Step: Identifiable, Codable {
    var id = UUID()
    var name: String
    var open_time: String?
    var closing_time: String?
    var description: String?
    var info: String?
    var image: String?
}
