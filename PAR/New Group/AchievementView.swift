//
//  Achievements.swift
//  PAR
//
//  Created by Emma Shen on 1/30/23.
//

import UIKit

class AchievementView: UIViewController {
    
    let achievementPic = [UIImage(named: "cycle_pic"), UIImage(named: "grow"), UIImage(named: "give")]
    let achievementDesc = ["Complete 1 focus cycle", "Grow for 100 minutes", "Give 1st donation"]
    let achieveNumCoins = ["10", "50", "100"]

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Achievements", for: indexPath) as! Achievements
        cell.achievementPic.image = achievementPic[indexPath.row]
        cell.achievementDesc.text = achievementDesc[indexPath.row]
        cell.achieveNumCoins.text = achieveNumCoins[indexPath.row]
        cell.tag = indexPath.row
        //print("yo")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }

}
