//
//  goalSetting.swift
//  Project PAR(PlanActRest)
//
//  Created by Tyler Xiao on 12/21/22.
//

import UIKit

class GoalSetting: UIViewController, UITextFieldDelegate{
    var focusPeriod = 0
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        userQuote.delegate = self
        animateInTut(desiredView: bubbleView, x: x_pos[i], y: y_pos[i])
        bubbleText.text = textList[i]
        let steven = userDefaults.string(forKey: "User_Quote")
        if steven != nil {
            userQuote.text = steven
        }
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    var taskBrain: TaskBrain!
    @IBAction func toFocusPeriod(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FocusTimer") as! FocusTimer
        vc.focusPeriod = focusPeriod
        UserDefaults.standard
            .set(chosenTasks, forKey: "CHOSEN_TASKS")
        UserDefaults.standard
            .set(chosenTaskDex, forKey: "CHOSEN_TASK_DEX")
        UserDefaults.standard.set(userQuote.text, forKey: "User_Quote")
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
    
    @IBOutlet var tipView: UIView!
    @IBOutlet var tipText: UILabel!
    //var tips = ["eat salad", "eat pizza"]
    @IBAction func exitFromTip(_ sender: Any) {
        animateOut(desiredView: tipView)
    }
    @IBAction func suggestTips(_ sender: Any) {
        //pops up the tips
        animateIn(desiredView: tipView)
        //tipText.text = tips.randomElement()
    }
    func animateIn(desiredView: UIView) {
        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center
        
        UIView.animate(withDuration: 0.3, animations: {
            
            desiredView.transform = CGAffineTransform(scaleX: 1, y: 1)
            desiredView.alpha = 1
            
        })
        
    }
    
    func animateOut(desiredView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: { _ in
            desiredView.removeFromSuperview()
        })
    }
    
    var textList = ["Step 2 is goal setting!🎯","Rank your top 3️⃣ tasks","Who is your role model? How would they encourage you?", "Follow this checklist. Very important‼️", "You are all set! Time to get some work done💪"]
    var i = 0
    var x_pos = [270, 280, 170, 170, 170]
    var y_pos = [110, 220, 470, 595, 680]

    
    @IBOutlet weak var nextTip: UIButton!
    @IBOutlet var bubbleView: UIView!
    @IBOutlet weak var bubbleText: UILabel!
    @IBAction func nextButton(_ sender: Any) {
        if i < 4 {
            i+=1
            bubbleText.text = textList[i]
            //animateOut(desiredView: bubbleView)
            animateInTut(desiredView: bubbleView, x: x_pos[i], y: y_pos[i])
        }
        
        if i == 4 {
            nextTip.setTitle("", for: .normal)
        }
    }
    
    func animateInTut(desiredView: UIView, x: Int, y: Int) {
        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = CGPoint(x: x, y:y)
        //desiredView.center = backgroundView.center
        
        UIView.animate(withDuration: 0.3, animations: {
            
            desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            desiredView.alpha = 1
            
        })
        
    }
    func animateOutTut(desiredView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: { _ in
            desiredView.removeFromSuperview()
        })
    }
    
    
    
    
    
    @IBOutlet weak var userQuote: UITextField!
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
