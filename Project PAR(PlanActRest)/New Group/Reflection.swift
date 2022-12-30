//
//  Reflection.swift
//  Project PAR(PlanActRest)
//
//  Created by Tyler Xiao on 12/29/22.
//

import UIKit

class Reflection: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet var sliderResults: UISlider!
    
    @IBOutlet var tipView: UIView!
    @IBOutlet var tipText: UILabel!
    var tips = ["If you are feeling overwhelmed, focus on one task at a time! You got this!", "Eat the rainbow! Vegetables and fruits keep your body healthy and your mind sharp.", "Make a to-do-list in the morning. Clear your head and get ready to tackle what the day brings!", "Exercise at least 30 minutes everyday! Here are some easy ways to get started: take a walk around the neighborhood, swim at the beach, play your favorite sport with your friends.", "In the mood for some fun games to exercise your brain? Try these board games: Catan, Apple to Apples, Scrabble, Monopoly, and Chess.", "Eat for the environment. You can fight climate change by eating less packaged foods, animal meats, and growing your own food!", "Feeling tired and unmotivated? A good 8 hours of sleep every night can ensure an energized and fresh mind and body in the morning!.", "Getting distracted by noise around you? Consider changing your work space to somewhere more quiet. For example, a secluded room or the library."]
    @IBAction func exitFromTip(_ sender: Any) {
        animateOut(desiredView: tipView)
    }
    @IBAction func suggestTips(_ sender: Any) {
        //pops up the tips
        animateIn(desiredView: tipView)
        tipText.text = tips.randomElement()
    }
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
    func animateOut(desiredView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: { _ in
            desiredView.removeFromSuperview()
        })
    }
    @IBAction func toBreak(_ sender: Any) {
        //save reflection results to database/statistics
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
