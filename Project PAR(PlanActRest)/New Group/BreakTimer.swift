//
//  BreakTimer.swift
//  Project PAR(PlanActRest)
//
//  Created by Emma Shen on 12/29/22.
//

import UIKit
import AVFoundation
import UserNotifications

class BreakTimer: UIViewController {
    var timer = Timer()
    var player: AVAudioPlayer!
    var breakPeriod = 5
    var counter = 0
    var endTime:Date?
    let userDefaults = UserDefaults.standard
    let endKey = "ENDKEY"
    let startKey = "STARTKEY"
    var maximumContentSizeCategory: UIContentSizeCategory?

    @objc func nextTut() {
        nextButton((Any).self)
    }
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var earnedCoins: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.maximumContentSizeCategory = .medium

        self.navigationItem.setHidesBackButton(true, animated:true)

        let tutOn = userDefaults.bool(forKey: "TUTORIAL")
        if tutOn {
            animateInTut(desiredView: bubbleView, x: x_pos[i], y: y_pos[i])
            var tapTut:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nextTut))
            bubbleView.addGestureRecognizer(tapTut)
        }
        bubbleText.text = textList[i]
        breakPeriod = userDefaults.integer(forKey: "BREAK_TIME")
        //breakPeriod (min), counter (seconds left)
        counter = breakPeriod * 60
        //exact time start timer
        //let startDate = Date()
        //when start timer + seconds left = when end timer
        let coins = userDefaults.integer(forKey: "ACTUAL_FOCUS_TIME") / 60
        earnedCoins.text = "Ready to spend your \(coins) coins?"
        endTime = userDefaults.object(forKey: endKey) as? Date
        
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
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(BreakTimer.updateCounter)), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
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
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "IntermediateScreen") as! IntermediateScreen
            self.navigationController?.pushViewController(vc, animated: true)
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
        if i < 1 {
            i+=1
            bubbleText.text = textList[i]
            //print("yo()mom")

            //animateOut(desiredView: bubbleView)
            animateInTut(desiredView: bubbleView, x: x_pos[i], y: y_pos[i])
        }
        //print("yo()mom")
        if i == 2 {
            animateOutTut(desiredView: bubbleView)
        }
        if i == 1 {
            nextTip.setTitle("Exit", for: .normal)
            i = 2
        }
    }
    
    var textList = ["Well done! Each of your productivity minutes are converted to 1 in-game coin 🪙","Spend your coins at the shop 🛒"]
    var i = 0
    var x_pos = [280, 150]
    var y_pos = [210, 580]

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



    

    
    
