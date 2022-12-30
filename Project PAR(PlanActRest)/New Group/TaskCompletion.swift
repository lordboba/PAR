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
    var breakMins = [5,10,15]
    override func viewDidLoad() {
        let minFocus = UserDefaults.standard.integer(forKey: "ACTUAL_FOCUS_TIME") / 60
        congratsText.text = "You were focused for \(minFocus) min. Take your well deserved break!"
        chosenTasks = (userDefaults.object(forKey: "CHOSEN_TASKS") as? [String])!
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
