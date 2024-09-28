//
//  UserService.swift
//  TripMaster
//
//  Created by Sophia on 22/09/24.
//

import Foundation
import ParthenoKit

struct UserService {
    var p = ParthenoKit()
    let team_code = "PA89X2S478ZH"
    
    public func readUsers() -> [User]{
        let dic = p.readSync(team: team_code, tag: "USER1", key: "%")
        var returnArray: [User] = []
        //print(dic)
        
        dic.values.forEach() {extracted in
            if let jsonData = extracted.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil).data(using: .utf8) {
                do {
                    let savedUser = try JSONDecoder().decode(User.self, from: jsonData)
                    returnArray.append(savedUser)
                } catch {
                    print("Errore nella deserializzazione: \(error)")
                }
            }
        }
        
        return returnArray
    }
    
    public func getUser(username: String) -> User? {
        print("Get user by username: \(username)")
        let dic = p.readSync(team: team_code, tag: "USER1", key: username)
        
        if let extracted = dic[username] { // se esiste l'oggetto lo recupera dal dizionario e lo piazza nella variabile extracted
            if let jsonData = extracted.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil).data(using: .utf8) {
                do {
                    let savedUser = try JSONDecoder().decode(User.self, from: jsonData)
                    return savedUser
                } catch {
                    print("UserService.getUser - error at: \(error)")
                }
            }
        } else {
            print("Not found!")  //Non è stata trovata una persona salvata su cloud con quell'id
        }
        return nil
    }
    
    public func setUser(user: User) -> Bool {
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(user)
            if let jsonString = String(data: jsonData, encoding: .utf8){
                return p.writeSync(team: team_code, tag: "USER1", key: user.username, value: jsonString)
            }
        } catch {
            print("UserService.setUser - error at: \(error)")
        }
        return false
    }
    
    public func deleteUser(username: String) -> Bool {
        return p.writeSync(team: team_code, tag: "USER1", key: username, value: "#DEL")
    }
    
}
