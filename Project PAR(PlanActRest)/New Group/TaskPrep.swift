//
//  TaskPrep.swift
//  Project PAR(PlanActRest)
//
//  Created by Tyler Xiao on 12/20/22.
//

import UIKit

class TaskPrep: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,  UITableViewDelegate, UITableViewDataSource {
    
    let hourNums = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
    let minNums = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]
    let focusMin = [1,15,20,25,30,35,40,45,50,55,60,65]
    
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var minutes: UILabel!
    @IBOutlet weak var focusTimes: UILabel!
    let scWidth = UIScreen.main.bounds.width - 10
    let scHeight = UIScreen.main.bounds.height / 2
    var selectedRow = 0
    var selectedMinRow = 0
    var selectedFocusRow = 0
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            if component == 0 {
                return hourNums.count
            }
            return minNums.count
        case 2:
            return focusMin.count

        default:
            return 1
        }
        

        
        
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: scWidth, height: 30))
        switch pickerView.tag {
        case 1:
            if component == 0 {
                label.text = "\(hourNums[row]) hours"
            } else {
                label.text = "\(minNums[row]) minutes"
            }
        case 2:
            label.text = "\(focusMin[row]) minutes"
        default:
            label.text = "Data not found!"
        }
        
        label.sizeToFit()
        return label
    }
    
    @IBAction func focusTimeChange(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: scWidth, height: scHeight)
        let pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: scWidth, height: scHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.tag = 2
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
            let selectedMin = self.focusMin[self.selectedFocusRow]
            focusTimes.text = "\(selectedMin)"
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func timeChange(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: scWidth, height: scHeight)
        let pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: scWidth, height: scHeight))
        
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.tag = 1
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        //print("bruh")
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select Time", message: "", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = pickerView
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel,handler: { (UIAlertAction) in }))
        alert.addAction(UIAlertAction(title: "Select", style: .default,handler: { [self] (UIAlertAction) in
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            self.selectedMinRow = pickerView.selectedRow(inComponent: 1)

            let selected = self.hourNums[self.selectedRow]
            let selectedMin = self.minNums[self.selectedMinRow]
            hours.text = "\(selected)"
            minutes.text = "\(selectedMin)"
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBOutlet var popUpView: UIView!

    //this next bit of code handles the add tasks button
    var taskBrain = TaskBrain()

    @IBAction func addNewTasks(_ sender: Any) {
        //animateIn(desiredView: blurView)
        animateIn(desiredView: popUpView)
        
        //let vc = UIViewController()
        //vc.view.addSubview(tableView)
    }
    @IBAction func exitPopUp(_ sender: Any) {
        animateOut(desiredView: popUpView)
    }
    
    @IBAction func addTaskToList(_ sender: Any) {
        
    }
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //blurView.bounds = self.view.bounds
        
        popUpView.bounds = CGRect(x: 0, y: 0, width: popUpView.bounds.width, height: popUpView.bounds.height)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounds = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height)
        
        // Do any additional setup after loading the view.
    }
    
    func animateIn(desiredView: UIView) {
        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center
        
        UIView.animate(withDuration: 0.3, animations: {
            
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
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
    //this next part allows the users to customize their own tasks
    
    
    /*
    // MARK: - Navigation

    
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row tapped")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskBrain.tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskBrain.tasks[indexPath.row].name
        print("yo")
        return cell
    }
    //this part transfers the focus period to the next screen
    @IBAction func moveOnGoals(_ sender: Any) {
        let time = focusTimes.text
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoalSetting") as! GoalSetting
        //print(time)
        vc.focusPeriod = Int(time!)!
        print(vc.focusPeriod)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

