//
//  goalSetting.swift
//  Project PAR(PlanActRest)
//
//  Created by Tyler Xiao on 12/21/22.
//

import UIKit

class GoalSetting: UIViewController {
    var focusPeriod = 0 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func toFocusPeriod(_ sender: Any) {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FocusTimer") as! FocusTimer
        vc.focusPeriod = focusPeriod
        self.navigationController?.pushViewController(vc, animated: true)
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
