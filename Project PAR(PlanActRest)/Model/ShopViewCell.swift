//
//  ShopViewCell.swift
//  Project PAR(PlanActRest)
//
//  Created by Emma Shen on 12/31/22.
//

import UIKit

class ShopViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var learnMore: UIButton!
    @IBOutlet weak var donateNow: UIButton!
    let links = ["https://teamtrees.org", "https://teamseas.org", "https://academicsandathleticsforall.org"]
    @IBAction func onTapButton(_ sender: UIButton)
    {
        if sender == learnMore
        {
            UIApplication.shared.openURL(URL(string: links[self.tag])!)
            print("hi")
            print(self.tag)
        }
        if sender == donateNow
        {
            
        }
    }

}
