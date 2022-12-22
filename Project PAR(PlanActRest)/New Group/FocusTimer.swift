//
//  FocusTimer.swift
//  Project PAR(PlanActRest)
//
//  Created by Tyler Xiao on 12/21/22.
//

import UIKit
import AVFoundation
class FocusTimer: UIViewController {
    var timer = Timer()
    var player: AVAudioPlayer!
    var focusPeriod = 0
    var counter = 0
    
    @IBOutlet var timerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        counter = focusPeriod * 60
        // Do any additional setup after loading the view.
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(FocusTimer.updateCounter)), userInfo: nil, repeats: true)
    }
    @objc func updateCounter() {
        if counter > 0 {
            print("\(counter) seconds.")
            counter -= 1
            updateLabel()
        } else if counter == 0 {
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
        timerLabel.text = "\(min):\(extraZero)\(sec)"
    }
    @IBAction func nextScreen(_ sender: Any) {
        timer.invalidate()
        
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
