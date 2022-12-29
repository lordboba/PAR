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
    func taskExists(task : Task) -> Bool{
        for t in tasks {
            if t.name == task.name {
                return true
            }
        }
        return false
    }
    func getIndex(task : Task) -> Int {
        //returns -1 if invalid
        var index = 0
        for t in tasks {
            if t.name == task.name {
                return index
            }
            index += 1
        }
        return -1
    }
    enum CodingKeys: String, CodingKey {
            case tasks
    }
}
