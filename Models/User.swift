//
//  User.swift
//  TripMaster
//
//  Created by Sophia on 16/09/24.
//

import Foundation

struct User: Identifiable, Codable {
    public var id = UUID()
    private var name: String
    private var surname: String
    private var preferences: [String]  //TODO: Da aggiustare
}
