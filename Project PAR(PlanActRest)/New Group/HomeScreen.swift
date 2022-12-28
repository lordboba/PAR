//
//  HomeScreen.swift
//  Project PAR(PlanActRest)
//
//  Created by Tyler Alex on 12/19/22.
//

import UIKit

class HomeScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let hex:UInt64 = 0xA0E4CB
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0xff00) >> 8
        let b = hex & 0xff
        view.backgroundColor = UIColor(red: CGFloat(r) / 256.0, green: CGFloat(g) / 256.0, blue: CGFloat(b) / 256.0, alpha: 1)
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]) { success, error in
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func TutorialButton(_ sender: Any) {
        print("hi")
        //sender.font = "Times New Roman"
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
