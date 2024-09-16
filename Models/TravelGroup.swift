//
//  TravelGroup.swift
//  TripMaster
//
//  Created by Sophia on 16/09/24.
//

import Foundation

struct TravelGroup: Identifiable, Codable {
    public var id = UUID()
    private var name: String
    private var members: [User]
}
