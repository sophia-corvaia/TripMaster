//
//  GroupService.swift
//  TripMaster
//
//  Created by Sophia on 22/09/24.
//

import Foundation

import Foundation
import ParthenoKit

struct GroupService {
    var p = ParthenoKit()
    let team_code = "PA89X2S478ZH"

    public func readGroups(username: String) -> [TravelGroup] {
        let dic = p.readSync(team: team_code, tag: "GROUPS1", key: "%")
        var returnArray: [TravelGroup] = []
        //print(dic)
        
        dic.values.forEach { extracted in
            if let jsonData = extracted.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil).data(using: .utf8) {
                do {
                    let savedGroup = try JSONDecoder().decode(TravelGroup.self, from: jsonData)
                    returnArray.append(savedGroup)
                    let filteredGroups = returnArray.filter { group in
                        group.members.contains { user in
                            user.username == username
                        }
                    }
                    returnArray = filteredGroups
                } catch {
                    print("Errore nella deserializzazione: \(error)")
                }
            }
        }
        
        return returnArray
    }
    
    public func getGroup(name: String) -> TravelGroup? {
        print("Get gruop by name: \(name)")
        let dic = p.readSync(team: team_code, tag: "GROUPS1", key: name)
        
        if let extracted = dic[name] { // se esiste l'oggetto lo recupera dal dizionario e lo piazza nella variabile extracted
            if let jsonData = extracted.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil).data(using: .utf8) {
                do {
                    let savedGroup = try JSONDecoder().decode(TravelGroup.self, from: jsonData)
                    return savedGroup
                } catch {
                    print("GroupService.getGroup - error at: \(error)")
                }
            }
        } else {
            print("Not found!")  //Non è stata trovata una persona salvata su cloud con quell'id
        }
        return nil
    }
    
    public func setGroup(group: TravelGroup) -> Bool {
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(group)
            if let jsonString = String(data: jsonData, encoding: .utf8){
                return p.writeSync(team: team_code, tag: "GROUPS1", key: group.name, value: jsonString)
            }
        } catch {
            print("GroupService.setGroup - error at: \(error)")
        }
        return false
    }
    
}
