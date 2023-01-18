//
//  Reflection.swift
//  Project PAR(PlanActRest)
//
//  Created by Tyler Xiao on 12/29/22.
//

import UIKit

class Reflection: UIViewController, UITextFieldDelegate {
    var maximumContentSizeCategory: UIContentSizeCategory?
    @objc func dismissKeyboard() {
        self.view.endEditing(true)

        //self.view.removeGestureRecognizer(tap)
    }
    @objc func nextTut() {
        nextButton((Any).self)
    }
    override func viewDidLoad() {
        super.viewDidLoad();
        userFeedback.delegate = self
        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        view.maximumContentSizeCategory = .medium
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tutOn = userDefaults.bool(forKey: "TUTORIAL")
        if tutOn {
            animateInTut(desiredView: bubbleView, x: x_pos[i], y: y_pos[i])
            var tapTut:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nextTut))
            bubbleView.addGestureRecognizer(tapTut)
        }
        bubbleText.text = textList[i]
        self.navigationItem.setHidesBackButton(true, animated:true)

        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    var dataUpdate = DataUpdate()
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0{                       self.view.frame.origin.y -= keyboardFrame.height
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y != 0{                       self.view.frame.origin.y += keyboardFrame.height
        }
    }
    @IBOutlet var userFeedback: UITextField!
    @IBOutlet var sliderResults: UISlider!
    let userDefaults = UserDefaults.standard
    @IBOutlet var tipView: UIView!
    @IBOutlet var tipText: UILabel!
    var tips = ["If you are feeling overwhelmed, focus on one task at a time! You got this!", "Eat the rainbow! Vegetables and fruits keep your body healthy and your mind sharp.", "Make a to-do-list in the morning. Clear your head and get ready to tackle what the day brings!", "Exercise at least 30 minutes everyday! Here are some easy ways to get started: take a walk around the neighborhood, swim at the beach, play your favorite sport with your friends.", "In the mood for some fun games to exercise your brain? Try these board games: Catan, Apple to Apples, Scrabble, Monopoly, and Chess.", "Eat for the environment. You can fight climate change by eating less packaged foods, animal meats, and growing your own food!", "Feeling tired and unmotivated? A good 8 hours of sleep every night can ensure an energized and fresh mind and body in the morning!.", "Getting distracted by noise around you? Consider changing your work space to somewhere more quiet. For example, a secluded room or the library."]
    @IBAction func exitFromTip(_ sender: Any) {
        animateOut(desiredView: tipView)
    }
    @IBAction func suggestTips(_ sender: Any) {
        //pops up the tips
        animateIn(desiredView: tipView)
        tipText.text = tips.randomElement()
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
    var errorCheck = false
    @IBAction func toBreak(_ sender: Any) {
        //save reflection results to database/statistics
        //let temp = userDefaults.string(forKey: "USER_ID")
        /*
        do {
            let tempData = try JSONEncoder().encode(DataUpdate())
            userDefaults.set(tempData, forKey: "dataUpdate")
        }catch let error {
            
                print("Error encoding: \(error)")
            
        }*/
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
        let minFocus = UserDefaults.standard.integer(forKey: "ACTUAL_FOCUS_TIME") / 60
        dataUpdate.coins += minFocus
        dataUpdate.sessions.append(["time" :"\(minFocus)", "impression" : "\(sliderResults.value)", "date":dateFormatter.string(from: Date()),"reflect":userFeedback.text!])

        checkConnect()
        /*
        if temp == nil {
            let impressVal = sliderResults.value
            //save stuff to local data
            
            
            //print(dataUpdate)
            //print(errorCheck)
            /*
            var newData = DataUpdate()
            newData.coins = 6900
    
            do {
                let tempData = try JSONEncoder().encode(newData)
                UserDefaults.standard
                    .set(tempData, forKey: "dataUpdate")
            } catch let error {
                print("Error encoding: \(error)")
            }
            //first, we test the connection to the api, if it fails, then we only upload to local
            //createNewUser()
            //reset local dataupdate
            */
        } else {
            
        }*/
    }
    
    //insertOne, updateOne, findOne
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
    }
    
    var textList = ["Step 4 is Reflection! Slide the bar based on how productive you feel your session was","Click on the ? for some useful tips!","Ready to move on? "]
    var i = 0
    var x_pos = [270, 100, 170]
    var y_pos = [210, 420, 550]
    
    
    @IBOutlet var bubbleView: UIView!
    
    @IBAction func nextButton(_ sender: Any) {
        if i < 2 {
            i+=1
            bubbleText.text = textList[i]
            //animateOut(desiredView: bubbleView)
            animateInTut(desiredView: bubbleView, x: x_pos[i], y: y_pos[i])
        }
        if i == 3 {
            animateOut(desiredView: bubbleView)
        }
        if i == 2 {
            nextTip.setTitle("Exit", for: .normal)
            i = 3
        }
    }
    
    @IBOutlet weak var nextTip: UIButton!
    @IBOutlet weak var bubbleText: UILabel!
    
    
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
     func userPartTwo() {
        //gets the data structure and modifies it to how we want it to be
        guard let url = URL(string: "https://data.mongodb-api.com/app/data-rmmsc/endpoint/data/v1/action/findOne") else{return}
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let json: [String:Any] = ["collection": "actual","database": "user_data","dataSource": "PlanActRest","filter":["editing":true]]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("*", forHTTPHeaderField: "Access-Control-Request-Headers")
        request.setValue(Bundle.main.infoDictionary?["API_KEY"] as? String, forHTTPHeaderField: "api-key")
        
            let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            let decoder = JSONDecoder()
            //print(data!)
            if let data = data{
                do{
                    var jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                  
                }catch{
                    print(error)
                }
            }
        }
        //update the existing one
    }
    func getUser(the_id: String){
        guard let url = URL(string: "https://data.mongodb-api.com/app/data-rmmsc/endpoint/data/v1/action/findOne") else{return}
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let json: [String:Any] = ["collection": "testing_data","database": "test","dataSource": "PlanActRest","filter":["id":the_id],"projection":["id":1,"coins":1,"donations":1,"tasks":1,"sessions":1]]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("*", forHTTPHeaderField: "Access-Control-Request-Headers")
        request.setValue(Bundle.main.infoDictionary?["API_KEY"] as? String, forHTTPHeaderField: "api-key")
        
            let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            let decoder = JSONDecoder()
            //print(data!)
            if let data = data{
                do{
                    var jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                    //let string = String(data: data, encoding: .utf8)
                    //let decoded = try decoder.decode(User.self,from: data)
                    //print(jsonResult["document"]!)
                    //print(type(of:result))
                    /*
                    let tasks = try decoder.decode([User].self, from: data)
                    tasks.forEach{ i in
                        print(i.userId)
                    }*/
                }catch{
                    print(error)
                }
            }
        }
        task.resume()

    }
     */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
