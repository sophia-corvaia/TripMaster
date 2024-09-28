//
//  Route.swift
//  TripMaster
//
//  Created by Sophia on 16/09/24.
//

import Foundation

enum Category: String, Codable, CaseIterable {
    case culture, food, bynight, relax, adventure
}

struct Route: Identifiable, Codable {
    var id = UUID()
    var name: String
    var steps: [Step] 
    var start_time: String
    var end_time: String
    var description: String?
    let category: String
    var image: String?
}



