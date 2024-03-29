//
//  Shop.swift
//  PAR
//
//  Created by Tyler Xiao on 12/31/22.
//

import UIKit
import AVFoundation
import UserNotifications
  
class Shop: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var coinCount = 600
    @IBOutlet var coinLabel: UILabel!
    var timer = Timer()
    var quantityInt = 1
    var subtractCoinsInt = 0
    var player: AVAudioPlayer!
    var breakPeriod = 5
    var counter = 0
    var endTime:Date?
    let userDefaults = UserDefaults.standard
    let endKey = "ENDKEY"
    let startKey = "STARTKEY"
    let logos = [UIImage(named: "teamTreesLogo"), UIImage(named: "teamSeasLogo"), UIImage(named: "AAALogo")]
    let descriptions = ["Plant a tree to save the earth!", "Remove trash from the sea to protect the homes of ocean wildlife!", "Provide sports equipment and educational materials for underserved children to pursue their favorite subject and sport!"]
    let titles = ["#teamtrees", "#teamseas", "AAA"]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var breakTimer: UILabel!
    var dataUpdate = DataUpdate()
    var maximumContentSizeCategory: UIContentSizeCategory?
    @objc func nextTut() {
        nextButton((Any).self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.maximumContentSizeCategory = .medium

        let temp = UserDefaults.standard.data(forKey: "dataUpdate")
        if temp != nil {
            do {let bob = try JSONDecoder().decode(DataUpdate.self, from: temp!)
                dataUpdate = bob
                //print(bob)
            
            } catch let error {
                print("Error decoding: \(error)")
            
            }
        }
        //temporary coins
        //dataUpdate.coins = 600
        coinCount = dataUpdate.coins
        let tutOn = userDefaults.bool(forKey: "TUTORIAL")
        if tutOn {
            animateInTut(desiredView: bubbleView, x: x_pos[i], y: y_pos[i])
            var tapTut:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nextTut))
            bubbleView.addGestureRecognizer(tapTut)
        }
        bubbleText.text = textList[i]
        tableView.delegate = self
        tableView.dataSource = self
        coinLabel.text = String(coinCount)
        
        
        let fromMain = UserDefaults.standard.bool(forKey: "fromMainMenu")
        if !fromMain {
            breakPeriod = userDefaults.integer(forKey: "BREAK_TIME")
            // Do any additional setup after loading the view.
            endTime = userDefaults.object(forKey: endKey) as? Date
            //nothing
            let content = UNMutableNotificationContent()
            content.title = "Timer"
            content.body = "Your break session is over!"
            content.sound = UNNotificationSound(named:UNNotificationSoundName("xp_ring.mp3"))
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: endTime!), repeats: true)
            //print(endTime!)
            let request = UNNotificationRequest(identifier: "id_breakTimer", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (err) in
                if err != nil {
                    print("something's wrong")
                } else {
                    print("notification prepared!")
                }
            }
        
            
            //print("hi")
            // Do any additional setup after loading the view.
            //updates every 1s
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(Shop.updateCounter)), userInfo: nil, repeats: true)
            
        }
        else {
            breakTimer.text = ""
        }

        
    }
    @objc func updateCounter() {
        //let currTime = Date()
        let start = userDefaults.object(forKey: startKey) as! Date
        //how much time has passed since the start
        let diff = Int(Date().timeIntervalSince(start))
        counter = 60 * breakPeriod - diff
        updateLabel()
        if counter <= 0 {
            counter = 0
            updateLabel()
            playSound()
            timer.invalidate()
            
        }
    }
    func updateLabel() {
        let min = counter / 60
        let sec = counter % 60
        var extraZero = ""
        if sec < 10 {
            extraZero = "0"
        }
        breakTimer.text = "\(min):\(extraZero)\(sec)"
    }
    func playSound() {
        guard let url = Bundle.main.url(forResource: "xp_ring", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    @IBAction func donateNow(_ sender: Any) {
        animateIn(desiredView: donateView)
        orgName.text = titles[Int((sender as AnyObject).tag)]
        orgLogo.image = logos[Int((sender as AnyObject).tag)]
        coinInventory.text = String(coinCount)
        quantity.text = String(quantityInt)
        subtractCoinsInt = 150
        priceCoins.text = "\(subtractCoinsInt) coins"
    }
    
    
    

    
    
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var orgName: UILabel!
    @IBOutlet var donateView: UIView!
    @IBOutlet weak var coinInventory: UILabel!
    @IBOutlet weak var orgLogo: UIImageView!
    @IBAction func subtractCoins(_ sender: Any) {
        if quantityInt > 1 {
            quantityInt -= 1
            subtractCoinsInt = quantityInt * 150
            quantity.text = String(quantityInt)
            priceCoins.text = "\(subtractCoinsInt) coins"
        }

    }
    @IBAction func cancelButton(_ sender: Any) {
        animateOut(desiredView: donateView)
    }
    
    @IBAction func addCoins(_ sender: Any) {
        quantityInt += 1
        subtractCoinsInt = quantityInt * 150
        quantity.text = String(quantityInt)
        priceCoins.text = "\(subtractCoinsInt) coins"
    }
    
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet var errorView: UIView!
    @IBAction func confirmButton(_ sender: Any) {
        if subtractCoinsInt > coinCount {
            animateIn(desiredView: errorView)
            
        } else {
            coinCount -= subtractCoinsInt
            updDb()
            coinLabel.text = String(coinCount)
            quantityInt = 1
            animateOut(desiredView: donateView)
            confetti()
            userDefaults.set(true, forKey: "firstDonation")

            //update database
            
        }
    }
    func updDb() {
        // change, append donation to donations array
        dataUpdate.coins = coinCount
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY-MM-dd HH:mm:ss"
        let currDate = dateFormatter.string(from: Date())
        dataUpdate.donations.append(["name":orgName.text!,"quantity":"\(quantityInt)","date":currDate])
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
    @IBAction func doneError(_ sender: Any) {
        animateOut(desiredView: errorView)
    }
    @IBOutlet weak var priceCoins: UILabel!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamTrees", for: indexPath) as! ShopViewCell
        cell.nameLabel.text = titles[indexPath.row]
        cell.logo.image = logos[indexPath.row]
        cell.descLabel.text = descriptions[indexPath.row]
        cell.learnMore.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        cell.donateNow.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        cell.tag = indexPath.row
        cell.donateNow.tag = indexPath.row
        //print("yo")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func animateIn(desiredView: UIView) {
        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center
        
        UIView.animate(withDuration: 0.3, animations: {
            
            desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
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
    
    var textList = ["Welcome to the shop!","This is your current coin inventory. We convert them into real US dollars where you can make a real change in the world!", "Pick your cause. Press learn more to redirect to the nonprofit's actual website and once you are ready...donate now!", "Go back to enjoy the rest of your break!"]
    var i = 0
    var x_pos = [270, 230, 170, 170]
    var y_pos = [290, 130, 200, 120]

    
    @IBOutlet weak var nextTip: UIButton!
    @IBAction func nextButton(_ sender: Any) {
        if i < 3 {
            i+=1
            bubbleText.text = textList[i]
            //animateOut(desiredView: bubbleView)
            animateInTut(desiredView: bubbleView, x: x_pos[i], y: y_pos[i])
        }
        if i == 4 {
            animateOut(desiredView: bubbleView)
        }
        if i == 3 {
            nextTip.setTitle("Exit", for: .normal)
            i = 4
        }
    }
    @IBOutlet weak var bubbleText: UILabel!
    @IBOutlet var bubbleView: UIView!
    
    
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
    
}
