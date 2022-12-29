//
//  TaskBrain.swift
//  Project PAR(PlanActRest)
//
//  Created by Tyler Xiao on 12/21/22.
//

import Foundation
struct TaskBrain : Codable{
    var tasks : [Task] = []
    mutating func addTask(task : Task) {
        tasks.append(task)
    }
    mutating func removeTask(task : Task) {
        var index = 0
        for t in tasks {
            if task.name == t.name && task.time == t.time {
                break
            }
            index += 1
        }
        if index != tasks.count {
            tasks.remove(at: index)
        } else {
            print("Task not found!")
        }
    }
    enum CodingKeys: String, CodingKey {
            case tasks
    }
}
