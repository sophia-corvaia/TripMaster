//
//  Friend.swift
//  TripMaster
//
//  Created by Sophia on 20/09/24.
//

import Foundation


struct Friend: Identifiable, Codable, Hashable {
    var id = UUID()
    var username: String
    var friend_of: String //username of friend user
}
