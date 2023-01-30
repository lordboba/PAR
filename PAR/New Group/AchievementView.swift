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
    let achievementPic = [UIImage(named: "cycle_pic"), UIImage(named: "grow"), UIImage(named: "give")]
    let achievementDesc = ["Complete 1st focus cycle", "Grow for 100 minutes", "Give your 1st donation"]
    let achieveNumCoins = ["10", "50", "100"]
    @IBOutlet weak var achieveTable: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("bob")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Achievement", for: indexPath) as! Achievements
        cell.achievementPic.image = achievementPic[indexPath.row]
        cell.achievementDesc.text = achievementDesc[indexPath.row]
        cell.achieveNumCoins.text = achieveNumCoins[indexPath.row]
        cell.tag = indexPath.row
        //print("yo")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }

}
