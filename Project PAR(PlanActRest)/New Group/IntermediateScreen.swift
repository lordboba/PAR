//
//  IntermediateScreen.swift
//  Project PAR(PlanActRest)
//
//  Created by Tyler Xiao on 12/31/22.
//

import UIKit

class IntermediateScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        animateIn(desiredView: bubbleView)

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet var bubbleView: UIView!
    @IBOutlet weak var bubbleText: UILabel!
    
    func animateIn(desiredView: UIView) {
        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center
        
        UIView.animate(withDuration: 0.3, animations: {
            
            desiredView.transform = CGAffineTransform(scaleX: 1, y: 1)
            desiredView.alpha = 1
            
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
