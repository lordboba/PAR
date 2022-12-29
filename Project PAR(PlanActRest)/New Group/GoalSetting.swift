//
//  goalSetting.swift
//  Project PAR(PlanActRest)
//
//  Created by Tyler Xiao on 12/21/22.
//

import UIKit

class GoalSetting: UIViewController {
    var focusPeriod = 0 
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            if let data = UserDefaults.standard.data(forKey: "taskBrain") {
                let taskTemp = try JSONDecoder().decode(TaskBrain.self, from: data)
                print(taskTemp)
                taskBrain = taskTemp
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
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    var chosenTasks = ["reallynothinghereatall", "reallynothinghereatall", "reallynothinghereatall"]
    var chosenTaskDex = [-1, -1, -1]
    
    @IBOutlet var chooseTaskOne: UIButton!
    
    @IBOutlet var chooseTaskTwo: UIButton!
    @IBOutlet var chooseTaskThree: UIButton!
    func setButton(taskButton: UIButton, taskDex : Int) {
        let optionClosure =  {(action: UIAction) in
                taskButton.setTitle(action.title, for: .normal)
            
            
            
            
        }
        var actionArray : [UIAction] = []
        //print(taskBrain)
        var index = 0
        for task in taskBrain.tasks {
            
            actionArray.append(UIAction(title: "\(task.name)", handler: optionClosure))
            index += 1
        }
        taskButton.menu = UIMenu(children : actionArray)
        //taskButton.showsMenuAsPrimaryAction = true
        //taskButton.changesSelectionAsPrimaryAction = true
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
