//
//  goalSetting.swift
//  Project PAR(PlanActRest)
//
//  Created by Tyler Xiao on 12/21/22.
//

import UIKit

class GoalSetting: UIViewController {
    var focusPeriod = 0
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            if let data = UserDefaults.standard.data(forKey: "taskBrain") {
                let taskTemp = try JSONDecoder().decode(TaskBrain.self, from: data)
                print(taskTemp)
                taskBrain = taskTemp
                for _ in 0...taskBrain.tasks.count {
                    selected.append(false)
                }
                setButton(taskButton: chooseTaskOne, taskDex: 0)
                setButton(taskButton: chooseTaskTwo,taskDex: 1)
                setButton(taskButton: chooseTaskThree,taskDex: 2)
                
                
            }
        } catch let error {
            print("Error decoding: \(error)")
        }
        // Do any additional setup after loading the view.
    }
    var taskBrain: TaskBrain!
    @IBAction func toFocusPeriod(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FocusTimer") as! FocusTimer
        vc.focusPeriod = focusPeriod
        UserDefaults.standard
            .set(chosenTasks, forKey: "CHOSEN_TASKS")
        UserDefaults.standard
            .set(chosenTaskDex, forKey: "CHOSEN_TASK_DEX")
        /*
        do {
            //let tempData = try JSONEncoder().encode(chosenTasks)
            UserDefaults.standard
                .set(chosenTasks, forKey: "CHOSEN_TASKS")
            print("default set!")
        } catch let error {
            print("Error encoding: \(error)")
        }
        do {
            //let tempData = try JSONEncoder().encode(chosenTaskDex)
            UserDefaults.standard
                .set(chosenTaskDex, forKey: "CHOSEN_TASK_DEX")
        } catch let error {
            print("Error encoding: \(error)")
        }*/
        self.navigationController?.pushViewController(vc, animated: true)

    }
    var chosenTasks = ["reallynothinghereatall", "reallynothinghereatall", "reallynothinghereatall"]
    var chosenTaskDex = [-1, -1, -1]
    var selected : [Bool] = []
    @IBOutlet var chooseTaskOne: UIButton!
    
    @IBOutlet var chooseTaskTwo: UIButton!
    @IBOutlet var chooseTaskThree: UIButton!
    func setButton(taskButton: UIButton, taskDex : Int) {
        //let optionClosure =  {(action: UIAction) in
        //        taskButton.setTitle(action.title, for: .normal)}
        let optionClosure =  {(action: UIAction) in
            self.selectedTask(taskButton: taskButton, action: action, taskDex: taskDex)}
        var actionArray : [UIAction] = []
        //print(taskBrain)
        var index = 0
        for task in taskBrain.tasks {
            if !selected[index] {
                actionArray.append(UIAction(title: "\(task.name)", handler: optionClosure))
            }
            index += 1
        }
        taskButton.menu = UIMenu(children : actionArray)
        //taskButton.showsMenuAsPrimaryAction = true
        //taskButton.changesSelectionAsPrimaryAction = true
    }
    func selectedTask(taskButton: UIButton, action: UIAction, taskDex : Int) {
        taskButton.setTitle(action.title, for: .normal)
        let currentlySelectedTask = chosenTaskDex[taskDex]
        if currentlySelectedTask != -1 {
            selected[currentlySelectedTask] = false
        }
        let temp = Task(name: action.title,time:0)
        let selectDex = taskBrain.getIndex(task: temp)
        selected[selectDex] = true
        chosenTaskDex[taskDex] = selectDex
        chosenTasks[taskDex] = action.title
        setButton(taskButton: chooseTaskOne, taskDex: 0)
        setButton(taskButton: chooseTaskTwo,taskDex: 1)
        setButton(taskButton: chooseTaskThree,taskDex: 2)
        /*
        if taskDex == 0 {
            setButton(taskButton: chooseTaskTwo,taskDex: 1)
            setButton(taskButton: chooseTaskThree,taskDex: 2)
        } else if taskDex == 1 {
            setButton(taskButton: chooseTaskOne, taskDex: 0)
            setButton(taskButton: chooseTaskThree,taskDex: 2)
        } else {
            setButton(taskButton: chooseTaskOne, taskDex: 0)
            setButton(taskButton: chooseTaskTwo,taskDex: 1)
        }*/
    }
    /*
    @IBOutlet var menu1: UIMenu!
    @IBAction func chooseTaskOne(_ sender: Any) {
        print("bruh")
        
         do {
         if let data = UserDefaults.standard.data(forKey: "taskBrain") {
         let taskTemp = try JSONDecoder().decode(TaskBrain.self, from: data)
         print(taskTemp)
         }
         } catch let error {
         print("Error decoding: \(error)")
         }
         
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
