//
//  TaskCompletion.swift
//  PAR
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
    var maximumContentSizeCategory: UIContentSizeCategory?
    @objc func nextTut() {
        nextButton((Any).self)
    }
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated:true)
        view.maximumContentSizeCategory = .medium

        let minFocus = UserDefaults.standard.integer(forKey: "ACTUAL_FOCUS_TIME") / 60
        congratsText.text = "You were focused for \(minFocus) min. Take your well deserved break!"
        chosenTasks = (userDefaults.object(forKey: "CHOSEN_TASKS") as? [String])!
        chosenTaskDex = (userDefaults.object(forKey: "CHOSEN_TASK_DEX") as? [Int])!
        confetti()
        var totalFocus = userDefaults.integer(forKey: "totalFocus")
        if totalFocus == nil {
            totalFocus = 0
        }
        totalFocus += minFocus
        userDefaults.set(totalFocus, forKey: "totalFocus")
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
        let tutOn = userDefaults.bool(forKey: "TUTORIAL")
        if tutOn {
            animateInTut(desiredView: bubbleView, x: x_pos[i], y: y_pos[i])
            var tapTut:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nextTut))
            bubbleView.addGestureRecognizer(tapTut)
        }
        bubbleText.text = textList[i]
        
        // Do any additional setup after loading the view.
    }
    var confettiTimer = Timer()
    
    let sublayer =  CAEmitterLayer()
    private func confetti() {
        
        sublayer.emitterPosition = CGPoint(
            x: view.center.x,
            y: -100
        )
        //sublayer.beginTime = CACurrentMediaTime()
        let colors: [UIColor] = [
            .systemRed,
            .systemBlue,
            .systemOrange,
            .systemGreen,
            .systemPink,
            .systemYellow,
            .systemPurple
        ]
        sublayer.birthRate = 1
        let cells: [CAEmitterCell] = colors.compactMap {
            let cell = CAEmitterCell()
            cell.beginTime = 0.1
            cell.scale = 0.2
            cell.emissionRange = .pi * 2
            cell.lifetime = 3
            cell.birthRate = 100
            cell.velocity = 150
            cell.color = $0.cgColor
            cell.spin = 0.1
            cell.contents = UIImage(named: "confetti")!.cgImage
            return cell
        }
        
        sublayer.emitterCells = cells
        view.layer.addSublayer(sublayer)

        confettiTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: (#selector(Shop.updateConfetti)), userInfo: nil, repeats: false)
    }
    @objc func updateConfetti() {
        sublayer.birthRate = 0
        //sublayer.layer.actions = [NSDictionary dictionaryWithObject:[NSNull null] forKey:@"content"];
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
    @objc func toolbarDisappear(){
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        //picker2.removeFromSuperview()
    }
    @objc func changeTimeText() {
        self.selectedFocusRow = picker.selectedRow(inComponent: 0)
        let selectedMin = self.breakMins[self.selectedFocusRow]
        breakMin.text = "\(selectedMin)"
        toolbarDisappear()
    }
    var picker = UIPickerView()

    var toolBar = UIToolbar()
    @IBOutlet var breakMin: UILabel!
    @IBAction func selectBreak(_ sender: Any) {
        toolbarDisappear()
        selectedFocusRow = 0
        picker = UIPickerView.init(frame:CGRect(x: 0, y: UIScreen.main.bounds.height-scHeight, width: scWidth, height: scHeight))
        picker.tag = 1
        picker.dataSource = self
        picker.delegate = self
        self.picker.reloadAllComponents()

        picker.backgroundColor = UIColor.lightGray
        picker.selectRow(selectedFocusRow, inComponent: 0, animated: false)
        //picker.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(picker)
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: scHeight, width: scWidth, height: 50))
        toolBar.items = [UIBarButtonItem.init(title: "Cancel", style: .done, target: self, action: #selector(toolbarDisappear)), UIBarButtonItem.init(title: "Select", style: .done, target: self, action: #selector(changeTimeText))]
        self.view.addSubview(toolBar)
        /*
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
        self.present(alert, animated: true, completion: nil)*/
    }
    
    @IBOutlet var oneSwitch: UISwitch!
    @IBOutlet var twoSwitch: UISwitch!
    @IBOutlet var threeSwitch: UISwitch!
    var taskBrain = TaskBrain()
    var endTime:Date?
    let endKey = "ENDKEY"
    let startKey = "STARTKEY"
    var counter = 0
    var dataUpdate = DataUpdate()
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
        databaseUpd()
        
        if oneSwitch.isOn && chosenTaskDex[0] != -1 {
            taskBrain.tasks[chosenTaskDex[0]].name = "thistaskhasbeencompletedyesithas"
        }
        if twoSwitch.isOn && chosenTaskDex[1] != -1 {
            taskBrain.tasks[chosenTaskDex[1]].name = "thistaskhasbeencompletedyesithas"
        }
        if threeSwitch.isOn && chosenTaskDex[2] != -1 {
            taskBrain.tasks[chosenTaskDex[2]].name = "thistaskhasbeencompletedyesithas"
        }
        //save to database if can
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
        let chosenTasks = ["reallynothinghereatall", "reallynothinghereatall", "reallynothinghereatall"]
        let chosenTaskDex = [-1, -1, -1]
        UserDefaults.standard
            .set(chosenTasks, forKey: "CHOSEN_TASKS")
        UserDefaults.standard
            .set(chosenTaskDex, forKey: "CHOSEN_TASK_DEX")
        //store and save task completon data to database
        
    }
    func databaseUpd() {
        //get dataUpdate actual
        let temp = UserDefaults.standard.data(forKey: "dataUpdate")
        if temp != nil {
            do {let bob = try JSONDecoder().decode(DataUpdate.self, from: temp!)
                dataUpdate = bob
                //print(bob)
            
            } catch let error {
                print("Error decoding: \(error)")
            
            }
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY-MM-dd HH:mm:ss"
        let currDate = dateFormatter.string(from: Date())
        if oneSwitch.isOn && chosenTaskDex[0] != -1 {
            dataUpdate.tasks.append(["name" :taskBrain.tasks[chosenTaskDex[0]].name, "time":"\(taskBrain.tasks[chosenTaskDex[0]].time)","date":currDate])
        }
        if twoSwitch.isOn && chosenTaskDex[1] != -1 {
            dataUpdate.tasks.append(["name" :taskBrain.tasks[chosenTaskDex[1]].name, "time":"\(taskBrain.tasks[chosenTaskDex[1]].time)","date":currDate])
        }
        if threeSwitch.isOn && chosenTaskDex[2] != -1 {
            dataUpdate.tasks.append(["name" :taskBrain.tasks[chosenTaskDex[2]].name, "time":"\(taskBrain.tasks[chosenTaskDex[2]].time)","date":currDate])
        }
        //check connection
        checkConnect()
    }
    func checkConnect()  {
        guard let url = URL(string: "https://data.mongodb-api.com/app/data-rmmsc/endpoint/data/v1/action/findOne") else{return}
        var request = URLRequest(url:url)
        print("bruh")
        request.httpMethod = "POST"
        let json: [String:Any] = ["collection": "actual","database": "user_data","dataSource": "PlanActRest"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("*", forHTTPHeaderField: "Access-Control-Request-Headers")
        request.setValue(Bundle.main.infoDictionary?["API_KEY"] as? String, forHTTPHeaderField: "api-key")
        
            let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
           
                var bob = false
                if error == nil {
                    bob = true
                }
                self.upload(connects: bob)
                //self.errorCheck = true
                //print(error)
                
        }
        print("grass lemon")

        //creates the data structure we want
        task.resume()
        //userPartTwo()
    }
    func upload(connects : Bool) {
        do {
            let tempData = try JSONEncoder().encode(dataUpdate)
            UserDefaults.standard
                .set(tempData, forKey: "dataUpdate")
        } catch let error {
            print("Error encoding: \(error)")
        }
        if connects {
            let temp = userDefaults.string(forKey: "USER_ID")
            if temp == nil {
                //create new user first, then run api call
                print("dud du ddu")

                newUser()
            } else {
                //

                updUser(steve: false)
            }
        }

    }
    func getID() {
        guard let url = URL(string: "https://data.mongodb-api.com/app/data-rmmsc/endpoint/data/v1/action/findOne") else{return}
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        var json: [String:Any] = ["collection": "actual","database": "user_data","dataSource": "PlanActRest","filter":["editing":true]]
        print("rizz")
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("*", forHTTPHeaderField: "Access-Control-Request-Headers")
        request.setValue(Bundle.main.infoDictionary?["API_KEY"] as? String, forHTTPHeaderField: "api-key")
        print("gru")

            let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            print("brp")
            let decoder = JSONDecoder()
            //print(data!)
            if let data = data{
                do{
                    print("dru")

                    var jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    let data_result = jsonResult as! Dictionary<String,Any>
                    
                    print(data_result)
                    var id_var = data_result["document"] as! Dictionary<String,Any>
                    
                    
                    self.userDefaults.set(id_var["_id"], forKey: "USER_ID")
                    
                    
                    
                }catch{
                    print(error)
                }
            }
                self.updUser(steve: true)
        }
        task.resume()
    }
    func newUser() {
        //gets the data structure and modifies it to how we want it to be
        guard let url = URL(string: "https://data.mongodb-api.com/app/data-rmmsc/endpoint/data/v1/action/insertOne") else{return}
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let json: [String:Any] = ["collection": "actual","database": "user_data","dataSource": "PlanActRest","document":["id":"","coins":0,"donations":[],"tasks":[],"sessions":[],"editing":true]]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("*", forHTTPHeaderField: "Access-Control-Request-Headers")
        request.setValue(Bundle.main.infoDictionary?["API_KEY"] as? String, forHTTPHeaderField: "api-key")
        print("chicken")
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
                print("yo mom")
            //retrieve user JSON, edit json, and make updates
            self.getID()
                
        }
        task.resume()
        //update the existing one
    }
    func updUser(steve : Bool) {
        //gets the data structure and modifies it to how we want it to be
        guard let url = URL(string: "https://data.mongodb-api.com/app/data-rmmsc/endpoint/data/v1/action/updateOne") else{return}
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let temp = userDefaults.string(forKey: "USER_ID")!
        var json: [String:Any] = ["collection": "actual","database": "user_data","dataSource": "PlanActRest","filter":["_id":["$oid":temp]], "update":["$set":["editing":false,"coins":dataUpdate.coins],"$push":["sessions":["$each":""],"donations":["$each":""],"tasks":["$each":""]]]]
        if dataUpdate.sessions[0].isEmpty {
            dataUpdate.sessions.removeFirst()
        }
        if dataUpdate.tasks[0].isEmpty {
            dataUpdate.tasks.removeFirst()
        }
        if dataUpdate.donations[0].isEmpty {
            dataUpdate.donations.removeFirst()
        }
        if dataUpdate.sessions.count >= 1 {
            //json["update"]["$push"]["sessions"] = dataUpdate.sessions.removeFirst()
            //print("tetrault")
            if var update = json["update"] as? [String:Any] {
                //print(update)
              if var push = update["$push"] as? [String:Any] {
                  //print(push)
                if var sessions = push["sessions"] as? [String:Any] {
                  //print("fewwefwe")
                      sessions["$each"] = dataUpdate.sessions
                    push["sessions"] = sessions
                    update["$push"] = push
                    json["update"] = update
                  }
                
              }
            }
        } else {
            if var update = json["update"] as? [String:Any] {
                //print(update)
              if var push = update["$push"] as? [String:Any] {
                  //print(push)
                  push.removeValue(forKey: "sessions")
                    update["$push"] = push
                    json["update"] = update
              }
            }
        }
        if dataUpdate.tasks.count >= 1 {
            //json["update"]["$push"]["sessions"] = dataUpdate.sessions.removeFirst()
            //print("tetrault")
            if var update = json["update"] as? [String:Any] {
                //print(update)
              if var push = update["$push"] as? [String:Any] {
                  //print(push)
                if var letask = push["tasks"] as? [String:Any] {
                  //print("fewwefwe")
                      letask["$each"] = dataUpdate.tasks
                    push["tasks"] = letask
                    update["$push"] = push
                    json["update"] = update
                  }
                
              }
            }
        } else {
            if var update = json["update"] as? [String:Any] {
                //print(update)
              if var push = update["$push"] as? [String:Any] {
                  //print(push)
                  push.removeValue(forKey: "tasks")
                    update["$push"] = push
                    json["update"] = update
              }
            }
        }
        if dataUpdate.donations.count >= 1 {
            //json["update"]["$push"]["sessions"] = dataUpdate.sessions.removeFirst()
            //print("tetrault")
            if var update = json["update"] as? [String:Any] {
                //print(update)
              if var push = update["$push"] as? [String:Any] {
                  //print(push)
                if var donate = push["donations"] as? [String:Any] {
                  //print("fewwefwe")
                      donate["$each"] = dataUpdate.donations
                    push["donations"] = donate
                    update["$push"] = push
                    json["update"] = update
                  }
                
              }
            }
        } else {
            if var update = json["update"] as? [String:Any] {
                //print(update)
              if var push = update["$push"] as? [String:Any] {
                  //print(push)
                  push.removeValue(forKey: "donations")
                    update["$push"] = push
                    json["update"] = update
              }
            }
        }
        /*
        if dataUpdate.sessions.count >= 1 {
            //json["update"]["$push"]["sessions"] = dataUpdate.sessions.removeFirst()
            if var update = json["update"] as? [String:Any] {
              if var push = update["$push"] as? [String:Any] {
                if var sessions = push["sessions"] as? [String:Any] {
                  
                      sessions["$each"] = dataUpdate.sessions
                    push["sessions"] = sessions
                    update["$push"] = push
                    json["update"] = update
                  }
                
              }
            }
        }*/
        print(json)
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("*", forHTTPHeaderField: "Access-Control-Request-Headers")
        request.setValue(Bundle.main.infoDictionary?["API_KEY"] as? String, forHTTPHeaderField: "api-key")
        print("hurb")
            let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            //print(response)
            if let data = data{
                do{
                    let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    let data_result = jsonResult as! Dictionary<String,Any>
                    //print()
                    if data_result["modifiedCount"] as! Int == 1 && data_result["matchedCount"] as! Int == 1 {
                        //reset dataUpdate
                        self.dataUpdate.donations = [[:]]
                        self.dataUpdate.tasks = [[:]]
                        self.dataUpdate.sessions = [[:]]
                        do {
                            let tempData = try JSONEncoder().encode(self.dataUpdate)
                            UserDefaults.standard
                                .set(tempData, forKey: "dataUpdate")
                        } catch let error {
                            print("Error encoding: \(error)")
                        }
                        print(self.dataUpdate)
                    }
                    print(data_result)
                    //var id_var = data_result["document"] as! Dictionary<String,Any>
                    
                    //print(id_var)
                    
                    
                }catch{
                    print(error)
                }
            }
        }
        task.resume()
        //update the existing one
    }//get view ready
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
        if i == 3 {
            animateOutTut(desiredView: bubbleView)
        }
        if i == 2 {
            nextTip.setTitle("Exit", for: .normal)
            i = 3
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
