//
//  TravelGroup.swift
//  TripMaster
//
//  Created by Sophia on 16/09/24.
//

import Foundation

struct TravelGroup: Identifiable, Codable {
    public var id = UUID()
    var name: String
    var image: String = ""
    var members: [User]
    var group_routes: [Route] = []
}
