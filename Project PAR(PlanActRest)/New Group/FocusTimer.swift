//
//  FocusTimer.swift
//  Project PAR(PlanActRest)
//
//  Created by Tyler Xiao on 12/21/22.
//

import UIKit
import AVFoundation
import UserNotifications
class FocusTimer: UIViewController {
    var timer = Timer()
    var player: AVAudioPlayer!
    var focusPeriod = 0
    var counter = 0
    var endTime:Date?
    let userDefaults = UserDefaults.standard
    let endKey = "ENDKEY"
    let startKey = "STARTKEY"
    var chosenTasks : [String] = []
    //var chosenTaskDex : [Int] = []
    @IBOutlet var goalOne: UILabel!
    @IBOutlet var goalTwo: UILabel!
    @IBOutlet var goalThree: UILabel!
    @IBOutlet var endSession: UIButton!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    //let notificationCenter = UNUserNotificationCenter.current()
    //@IBOutlet var navigationItem: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        animateInTut(desiredView: bubbleView, x: x_pos[i], y: y_pos[i])
        bubbleText.text = textList[i]
        //self.navigationController?.delegate = self
        self.navigationItem.setHidesBackButton(true, animated:true)

        //make goals show up
        let minFocus = UserDefaults.standard.integer(forKey: "ACTUAL_FOCUS_TIME") / 60
        chosenTasks = (userDefaults.object(forKey: "CHOSEN_TASKS") as? [String])!
        quoteLabel.text = userDefaults.string(forKey: "User_Quote")
        //chosenTaskDex = (userDefaults.object(forKey: "CHOSEN_TASK_DEX") as? [Int])!
        var dex = 0
        print(chosenTasks)
        for a in chosenTasks {
            if a == "reallynothinghereatall" {
                chosenTasks[dex] = "N/A"
            }
            dex += 1
        }
        print(chosenTasks[2])
        goalOne.text = "1. \(chosenTasks[0])"
        goalTwo.text = "2. \(chosenTasks[1])"
        goalThree.text = "3. \(chosenTasks[2])"

        /*
        do {
            if let data = UserDefaults.standard.data(forKey: "CHOSEN_TASKS") {
                let taskTemp = try JSONDecoder().decode([String](), from: data)
                print(taskTemp)
                taskBrain = taskTemp
                for _ in 0...taskBrain.tasks.count {
                    selected.append(false)
                }
               
                
                
            }
        } catch let error {
            print("Error decoding: \(error)")
        }*/
        //prepare timer
        counter = focusPeriod * 60
        let startDate = Date()
        endTime = startDate + TimeInterval(Double(counter))
        userDefaults.set(endTime, forKey: endKey)
        userDefaults.set(startDate, forKey: startKey)
        let content = UNMutableNotificationContent()
        content.title = "Timer"
        content.body = "Your focus session is over!"
        content.sound = UNNotificationSound(named:UNNotificationSoundName("xp_ring.mp3"))
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: endTime!), repeats: true)
        print(endTime!)
        let request = UNNotificationRequest(identifier: "id_focusTimer", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (err) in
            if err != nil {
                print("something's wrong")
            } else {
                print("notification prepared!")
            }
        }
        print("hi")
        // Do any additional setup after loading the view.
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(FocusTimer.updateCounter)), userInfo: nil, repeats: true)
    }
    @objc func updateCounter() {
        //let currTime = Date()
        let start = userDefaults.object(forKey: startKey) as! Date
        let diff = Int(Date().timeIntervalSince(start))
        counter = 60 * focusPeriod - diff
        updateLabel()
        if counter <= 0 {
            counter = 0
            updateLabel()
            playSound()
            timer.invalidate()
            endSession.setTitle("Finish Session", for: .normal)
        }
    }
    func updateLabel() {
        let min = counter / 60
        let sec = counter % 60
        var extraZero = ""
        if sec < 10 {
            extraZero = "0"
        }
        timerLabel.text = "\(min):\(extraZero)\(sec)"
    }
    @IBAction func nextScreen(_ sender: Any) {
        timer.invalidate()
        let start = userDefaults.object(forKey: startKey) as! Date
        let diff = Int(Date().timeIntervalSince(start))
        let actualLength = min(focusPeriod * 60, diff)
        UserDefaults.standard.set(actualLength, forKey: "ACTUAL_FOCUS_TIME")
        //add diff/60 to the total coins that the user has
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        UNUserNotificationCenter.current().delegate = self.transitioningDelegate as? any UNUserNotificationCenterDelegate
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .badge, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        //let userInfo = response.notification.request.content.userInfo
        // Handle notification

        completionHandler()
    }
    
    
    @IBOutlet var bubbleView: UIView!
    @IBOutlet weak var bubbleText: UILabel!
    @IBOutlet weak var nextTip: UIButton!
    @IBAction func nextButton(_ sender: Any) {
        if i < 2 {
            i+=1
            bubbleText.text = textList[i]
            //animateOut(desiredView: bubbleView)
            animateInTut(desiredView: bubbleView, x: x_pos[i], y: y_pos[i])
        }
        
        if i == 2 {
            nextTip.setTitle("", for: .normal)
        }
    }
    
    var textList = ["Step 3 is YOU 🫵 getting that work done 📚","While the ⏳ counts down, refer back to your goals and motivational quote here!","If you happen to finish all 3 of your tasks before the timer ends...press this button!🎉"]
    var i = 0
    var x_pos = [280, 270, 170]
    var y_pos = [225, 580, 680]

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
}


