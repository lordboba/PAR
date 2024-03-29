//
//  IntermediateScreen.swift
//  PAR
//
//  Created by Tyler Xiao on 12/31/22.
//

import UIKit
import SwiftUI
class IntermediateScreen: UIViewController {
    var maximumContentSizeCategory: UIContentSizeCategory?
    @objc func dismissKeyboard() {
        self.view.endEditing(true)

        //self.view.removeGestureRecognizer(tap)
    }
    @objc func nextTut() {
        animateOut(desiredView: bubbleView)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.maximumContentSizeCategory = .medium
        UserDefaults.standard.set(true, forKey: "cycleFinish")
       
        self.navigationItem.setHidesBackButton(true, animated:true)
        let tutOn = UserDefaults.standard.bool(forKey: "TUTORIAL")
        if tutOn {
            animateInTut(desiredView: bubbleView, x: x_pos[i], y: y_pos[i])
            var tapTut:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(nextTut))
            bubbleView.addGestureRecognizer(tapTut)
        }
        UserDefaults.standard.set(false, forKey: "Tutorial")
        // Do any additional setup after loading the view.
    }
    
    var i = 0
    var x_pos = [170]
    var y_pos = [140]
    
    @IBOutlet var bubbleView: UIView!
    @IBAction func doneButton(_ sender: Any) {
        animateOut(desiredView: bubbleView)
    }
    
    @IBAction func outOfSoon(_ sender: Any) {
        animateOut(desiredView: soonView)
    }
    @IBOutlet var soonView: UIView!
    @IBAction func progressTrack(_ sender: Any) {
        //track next progress
        //animateIn(desiredView: soonView)
        let vc = UIHostingController(rootView: ProgressView())
        self.navigationController?.pushViewController(vc, animated: true)
    }
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
    func animateInTut(desiredView: UIView, x: Int, y: Int) {
        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = CGPoint(x: x, y:y)
        //desiredView.center = backgroundView.center
        
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
    
