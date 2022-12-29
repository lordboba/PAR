//
//  Task.swift
//  Project PAR(PlanActRest)
//
//  Created by Tyler Xiao on 12/21/22.
//

import Foundation
struct Task : Codable{
    //name of task and time in minutes
    var name = "";
    var time = 0;
    enum CodingKeys: String, CodingKey {
        case name
        case time = "time"
    }
}
