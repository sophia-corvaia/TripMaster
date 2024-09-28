//
//  FriendService.swift
//  TripMaster
//
//  Created by Sophia on 22/09/24.
//

import Foundation
import ParthenoKit

struct FriendService {
    var p = ParthenoKit()
    let team_code = "PA89X2S478ZH"
    
    func reset() {
            print("INIZIO RESET")
            let dic = p.readSync(team: team_code, tag: "EVENTS", key: "%")
            //print(dic.count)
            dic.keys.forEach(){key in
                print(key)
                p.writeSync(team: team_code, tag: "EVENTS", key: key, value: "#DEL#")
            }
            print("FINE RESET")
    }
    
    public func readAllFriend() -> [Friend]{
        let dic = p.readSync(team: team_code, tag: "FRIEND3", key: "%")
        var returnArray: [Friend] = []
        //print(dic)
        
        dic.values.forEach() {extracted in
            if let jsonData = extracted.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil).data(using: .utf8) {
                do {
                    let savedUser = try JSONDecoder().decode(Friend.self, from: jsonData)
                    returnArray.append(savedUser)
                } catch {
                    print("Errore nella deserializzazione: \(error)")
                }
            }
        }
        
        return returnArray
    }
    
    public func deleteAllFriends(){
        var friends = readAllFriend()
        for friend in friends {
            p.writeSync(team: team_code, tag: "FRIEND3", key: friend.username, value: "#DEL")
        }
    }

    public func readFriend(username: String) -> [Friend]{
        let dic = p.readSync(team: team_code, tag: "FRIEND3", key: "%")
        var returnArray: [Friend] = []
        //print(dic)
        
        dic.values.forEach() {extracted in
            if let jsonData = extracted.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil).data(using: .utf8) {
                do {
                    let savedUser = try JSONDecoder().decode(Friend.self, from: jsonData)
                    returnArray.append(savedUser)
                    let filteredFriends: [Friend] = returnArray.filter { $0.friend_of == username }
                    returnArray = filteredFriends
                } catch {
                    print("Errore nella deserializzazione: \(error)")
                }
            }
        }
        
        return returnArray
    }
    
    public func getFriend(username: String) -> Friend? {
        print("Get friend by username: \(username)")
        let dic = p.readSync(team: team_code, tag: "FRIEND3", key: username)
        
        if let extracted = dic[username] { // se esiste l'oggetto lo recupera dal dizionario e lo piazza nella variabile extracted
            if let jsonData = extracted.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil).data(using: .utf8) {
                do {
                    let savedFriend = try JSONDecoder().decode(Friend.self, from: jsonData)
                    return savedFriend
                } catch {
                    print("FriendService.getFriend - error at: \(error)")
                }
            }
        } else {
            print("Not found!")  //Non è stata trovata una persona salvata su cloud con quell'id
        }
        return nil
    }
    
    public func setFriend(friend: Friend) -> Bool {
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(friend)
            if let jsonString = String(data: jsonData, encoding: .utf8){
                return p.writeSync(team: team_code, tag: "FRIEND3", key: friend.username, value: jsonString)
            }
        } catch {
            print("FriendUser.setFriend - error at: \(error)")
        }
        return false
    }
    
    public func removeFriend(username: String) -> Bool {
        return p.writeSync(team: team_code, tag: "FRIEND3", key: username, value: "#DEL")
    }
    
}
