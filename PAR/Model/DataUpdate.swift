//
//  DataUpdate.swift
//  PAR
//
//  Created by Tyler Xiao on 1/7/23.
//

import Foundation
struct DataUpdate : Hashable, Codable{
    var coins : Int = 0
    var donations : [[String:String]] = [[:]]
    var tasks : [[String:String]] = [[:]]
    var sessions : [[String:String]] = [[:]]
    
}
