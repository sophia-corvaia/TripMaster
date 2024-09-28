//
//  RouteService.swift
//  TripMaster
//
//  Created by Sophia on 22/09/24.
//

import Foundation
import ParthenoKit

struct RouteService {
    var p = ParthenoKit()
    let team_code = "PA89X2S478ZH"
    
    public func readRoutes(forCategory category: String) -> [Route] {
        let dic = p.readSync(team: team_code, tag: "ROUTE", key: "%")
        var returnArray: [Route] = []
        
        dic.values.forEach { extracted in
            if let jsonData = extracted.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil).data(using: .utf8) {
                do {
                    let savedRoute = try JSONDecoder().decode(Route.self, from: jsonData)
                    
                    if savedRoute.category == category {
                        returnArray.append(savedRoute)
                    }
                } catch {
                    print("Errore nella deserializzazione: \(error)")
                }
            }
        }
        
        return returnArray
    }
    
    public func getRoute(name: String) -> Route? {
        print("Get route by username: \(name)")
        let dic = p.readSync(team: team_code, tag: "ROUTE", key: name)
        
        if let extracted = dic[name] { // se esiste l'oggetto lo recupera dal dizionario e lo piazza nella variabile extracted
            if let jsonData = extracted.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil).data(using: .utf8) {
                do {
                    let savedRoute = try JSONDecoder().decode(Route.self, from: jsonData)
                    return savedRoute
                } catch {
                    print("RouteService.getUser - error at: \(error)")
                }
            }
        } else {
            print("Not found!")  //Non è stata trovata una persona salvata su cloud con quell'id
        }
        return nil
    }
    
    public func setRoute(route: Route) -> Bool {
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(route)
            if let jsonString = String(data: jsonData, encoding: .utf8){
                return p.writeSync(team: team_code, tag: "ROUTE", key: route.name, value: jsonString)
            }
        } catch {
            print("RouteService.setUser - error at: \(error)")
        }
        return false
    }
    
    public func deleteRoute(name: String) -> Bool {
        return p.writeSync(team: team_code, tag: "ROUTE", key: name, value: "#DEL")

    }
}

