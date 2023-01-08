//
//  TaskCompletion.swift
//  Project PAR(PlanActRest)
//
//  Created by Tyler Xiao on 12/29/22.
//

import UIKit

class TaskCompletion: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {

    @IBOutlet var taskOne: UILabel!
    @IBOutlet var taskTwo: UILabel!
    @IBOutlet var taskThree: UILabel!
    @IBOutlet var congratsText: UILabel!
    let userDefaults = UserDefaults.standard
    var chosenTasks : [String] = []
    var chosenTaskDex : [Int] = []
    var breakMins = [1,5,10,15]
    override func viewDidLoad() {
        let minFocus = UserDefaults.standard.integer(forKey: "ACTUAL_FOCUS_TIME") / 60
        congratsText.text = "You were focused for \(minFocus) min. Take your well deserved break!"
        chosenTasks = (userDefaults.object(forKey: "CHOSEN_TASKS") as? [String])!
        chosenTaskDex = (userDefaults.object(forKey: "CHOSEN_TASK_DEX") as? [Int])!

        //chosenTaskDex = (userDefaults.object(forKey: "CHOSEN_TASK_DEX") as? [Int])!
        var dex = 0
        //print(chosenTasks)
        for a in chosenTasks {
            if a == "reallynothinghereatall" {
                chosenTasks[dex] = "N/A"
            }
            dex += 1
        }
        print(chosenTasks[2])
        taskOne.text = "1. \(chosenTasks[0])"
        taskTwo.text = "2. \(chosenTasks[1])"
        taskThree.text = "3. \(chosenTasks[2])"
        
        super.viewDidLoad()
        animateInTut(desiredView: bubbleView, x: x_pos[i], y: y_pos[i])
        bubbleText.text = textList[i]
        
        // Do any additional setup after loading the view.
    }
    let scWidth = UIScreen.main.bounds.width - 10
    let scHeight = UIScreen.main.bounds.height / 2
    var selectedRow = 0
    var selectedMinRow = 0
    var selectedFocusRow = 0
    @objc(numberOfComponentsInPickerView:) func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breakMins.count
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: scWidth, height: 30))
        
        label.text = "\(breakMins[row]) minutes"
        label.sizeToFit()
        return label
    }
    @IBOutlet var breakMin: UILabel!
    @IBAction func selectBreak(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: scWidth, height: scHeight)
        let pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: scWidth, height: scHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(selectedFocusRow, inComponent: 0, animated: false)
        //print("bruh")
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select Time", message: "", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = pickerView
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: { (UIAlertAction) in }))
        alert.addAction(UIAlertAction(title: "Select", style: .default,handler: { [self] (UIAlertAction) in
            self.selectedFocusRow = pickerView.selectedRow(inComponent: 0)
            let selectedMin = self.breakMins[self.selectedFocusRow]
            breakMin.text = "\(selectedMin)"
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet var oneSwitch: UISwitch!
    @IBOutlet var twoSwitch: UISwitch!
    @IBOutlet var threeSwitch: UISwitch!
    var taskBrain = TaskBrain()
    var endTime:Date?
    let endKey = "ENDKEY"
    let startKey = "STARTKEY"
    var counter = 0
    @IBAction func startBreak(_ sender: Any) {
        let timeBreak = Int(breakMin.text!)
        userDefaults.set(timeBreak, forKey: "BREAK_TIME")
        
        counter = timeBreak! * 60
        let startDate = Date()
        endTime = startDate + TimeInterval(Double(counter))
        userDefaults.set(endTime, forKey: endKey)
        userDefaults.set(startDate, forKey: startKey)
        let temp = UserDefaults.standard.data(forKey: "taskBrain")
        if temp != nil {
            do {let bob = try JSONDecoder().decode(TaskBrain.self, from: temp!)
                taskBrain = bob
                //print(bob)
            
            } catch let error {
                print("Error decoding: \(error)")
            
            }
        }
        if oneSwitch.isOn && chosenTaskDex[0] != -1 {
            taskBrain.tasks[chosenTaskDex[0]].name = "thistaskhasbeencompletedyesithas"
        }
        if twoSwitch.isOn && chosenTaskDex[1] != -1 {
            taskBrain.tasks[chosenTaskDex[1]].name = "thistaskhasbeencompletedyesithas"
        }
        if threeSwitch.isOn && chosenTaskDex[2] != -1 {
            taskBrain.tasks[chosenTaskDex[1]].name = "thistaskhasbeencompletedyesithas"
        }
        //var dex = 0
        for t in taskBrain.tasks {
            if t.name == "thistaskhasbeencompletedyesithas" {
                taskBrain.removeTask(task: t)
            }
        }
        do {
            let tempData = try JSONEncoder().encode(taskBrain)
            UserDefaults.standard
                .set(tempData, forKey: "taskBrain")
            //print(tempData)
            //print("almost done ish")
        } catch let error {
            print("Error encoding: \(error)")
        }
        //resets the array
        var chosenTasks = ["reallynothinghereatall", "reallynothinghereatall", "reallynothinghereatall"]
        var chosenTaskDex = [-1, -1, -1]
        UserDefaults.standard
            .set(chosenTasks, forKey: "CHOSEN_TASKS")
        UserDefaults.standard
            .set(chosenTaskDex, forKey: "CHOSEN_TASK_DEX")
        //store and save task completon data to database
        
    }
    
    @IBOutlet var bubbleView: UIView!
    @IBOutlet weak var bubbleText: UILabel!
    @IBOutlet weak var nextTip: UIButton!
    @IBAction func nextButton(_ sender: Any) {
        //print("yo")
        if i < 2 {
            i+=1
            bubbleText.text = textList[i]
            //print("yo()mom")

            //animateOut(desiredView: bubbleView)
            animateInTut(desiredView: bubbleView, x: x_pos[i], y: y_pos[i])
        }
        //print("yo()mom")

        if i == 2 {
            nextTip.setTitle("", for: .normal)
        }
    }
    
    var textList = ["You were focused for so long! Check off any tasks you completed! ","Choose your break time. 5-15 minutes is a good range","Woohoo! Press this button!"]
    var i = 0
    var x_pos = [280, 120, 170]
    var y_pos = [180, 460, 640]

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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
