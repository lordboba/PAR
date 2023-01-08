//
//  DataUpdate.swift
//  Project PAR(PlanActRest)
//
//  Created by Tyler Xiao on 1/7/23.
//

import Foundation
struct DataUpdate : Codable{
    var coins : Int = 0
    var donations : [String:String] = [:]
    var tasks : [String:String] = [:]
    var sessions : [[String:String]] = [[:]]
    
}
