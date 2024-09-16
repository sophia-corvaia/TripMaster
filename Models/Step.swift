//
//  Step.swift
//  TripMaster
//
//  Created by Sophia on 16/09/24.
//

import Foundation

struct Step: Identifiable, Codable {
    public var id = UUID()
    private var name: String
    private var open_time: Double
    private var closing_time: Double
}
