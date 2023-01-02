//
//  Shop.swift
//  Project PAR(PlanActRest)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        coinLabel.text = String(coinCount)
        breakPeriod = userDefaults.integer(forKey: "BREAK_TIME")
        // Do any additional setup after loading the view.
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
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(Shop.updateCounter)), userInfo: nil, repeats: true)
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
            coinLabel.text = String(coinCount)
            animateOut(desiredView: donateView)
            quantityInt = 1
            //update database
        }
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

}
