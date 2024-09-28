//
//  User.swift
//  TripMaster
//
//  Created by Sophia on 16/09/24.
//

import Foundation

struct User: Identifiable, Codable {
    var id = UUID()
    var username: String
    var password: String
    var preferences: [Int] = [0, 0, 0, 0, 0] 
    var details: String?
    var image: String?
    var liked: [Route] = []
    var recommended: [Route] = []
}
