//
//  Route.swift
//  TripMaster
//
//  Created by Sophia on 16/09/24.
//

import Foundation

struct Route: Identifiable, Codable {
    public var id = UUID()
    private var name: String
    private var steps: [Step] //TODO: Da capire la struttura della tappa (se tipo semplice o complesso)
    private var start_time: Double
    private var end_time: Double
}
