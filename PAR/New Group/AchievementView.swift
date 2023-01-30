//
//  Achievements.swift
//  PAR
//
//  Created by Emma Shen on 1/30/23.
//

import UIKit

class AchievementView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievementPic.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.achieveTable.delegate = self
        self.achieveTable.dataSource = self

    }
    let userDefaults = UserDefaults.standard
    let achievementPic = [UIImage(named: "cycle_pic"), UIImage(named: "grow"), UIImage(named: "give")]
    let achievementDesc = ["Complete 1st focus cycle", "Grow for 100 minutes", "Give your 1st donation"]
    let achieveNumCoins = ["10", "50", "100"]
    @IBOutlet weak var achieveTable: UITableView!
    func setGreen() -> UIColor{
        let hex:UInt64 = 0xCDE990
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0xff00) >> 8
        let b = hex & 0xff
        return UIColor(red: CGFloat(r) / 256.0, green: CGFloat(g) / 256.0, blue: CGFloat(b) / 256.0, alpha: 1)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("bob")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Achievement", for: indexPath) as! Achievements
        cell.achievementPic.image = achievementPic[indexPath.row]
        cell.achievementDesc.text = achievementDesc[indexPath.row]
        //cell.achieveNumCoins.text = achieveNumCoins[indexPath.row]
        cell.achieveNumCoins.text = ""
        cell.tag = indexPath.row
        switch indexPath.row {
        case 0:
            //if finish 1 focus cycle
            let cycleFinish = UserDefaults.standard.bool(forKey: "cycleFinish")
            print("yo is this working")
            print(cycleFinish)
            if cycleFinish {
                cell.contentView.backgroundColor = setGreen()
                print("set Green!")
            }
        case 1:
            let growMin = userDefaults.integer(forKey: "totalFocus")
            if growMin >= 100 {
                cell.contentView.backgroundColor = setGreen()
            }
        case 2:
            //if make first donation
            let firstDonation = UserDefaults.standard.bool(forKey: "firstDonation")
            if firstDonation {
                cell.contentView.backgroundColor = setGreen()
            }
        default:
            print("row not found!")
        }
        //print("yo")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }

}
