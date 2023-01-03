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
    let userDefaults = UserDefaults.standard
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
        let temp = userDefaults.string(forKey: "USER_ID")
        if temp == nil {
            //createNewUser()
        } else {
            
        }
    }
    /*
    func createNewUser() {
        guard let url = URL(string: "https://data.mongodb-api.com/app/data-rmmsc/endpoint/data/v1/action/insertOne") else{return}
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let json: [String:Any] = ["collection": "actual","database": "user_data","dataSource": "PlanActRest","document":["id":"","coins":0,"donations":[],"tasks":[],"sessions":[]],"editing":true]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("*", forHTTPHeaderField: "Access-Control-Request-Headers")
        request.setValue(Bundle.main.infoDictionary?["API_KEY"] as? String, forHTTPHeaderField: "api-key")
        
            let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            let decoder = JSONDecoder()
            //print(data!)
            if let data = data{
                do{
                    var jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                  
                }catch{
                    print(error)
                }
            }
        }
        //creates the data structure we want
        task.resume()
        userPartTwo()
    }
    func userPartTwo() {
        //gets the data structure and modifies it to how we want it to be
        guard let url = URL(string: "https://data.mongodb-api.com/app/data-rmmsc/endpoint/data/v1/action/findOne") else{return}
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let json: [String:Any] = ["collection": "actual","database": "user_data","dataSource": "PlanActRest","filter":["editing":true]]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("*", forHTTPHeaderField: "Access-Control-Request-Headers")
        request.setValue(Bundle.main.infoDictionary?["API_KEY"] as? String, forHTTPHeaderField: "api-key")
        
            let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            let decoder = JSONDecoder()
            //print(data!)
            if let data = data{
                do{
                    var jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                  
                }catch{
                    print(error)
                }
            }
        }
        //update the existing one
    }
    func getUser(the_id: String){
        guard let url = URL(string: "https://data.mongodb-api.com/app/data-rmmsc/endpoint/data/v1/action/findOne") else{return}
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let json: [String:Any] = ["collection": "testing_data","database": "test","dataSource": "PlanActRest","filter":["id":the_id],"projection":["id":1,"coins":1,"donations":1,"tasks":1,"sessions":1]]
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("*", forHTTPHeaderField: "Access-Control-Request-Headers")
        request.setValue(Bundle.main.infoDictionary?["API_KEY"] as? String, forHTTPHeaderField: "api-key")
        
            let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            let decoder = JSONDecoder()
            //print(data!)
            if let data = data{
                do{
                    var jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    
                    //let string = String(data: data, encoding: .utf8)
                    //let decoded = try decoder.decode(User.self,from: data)
                    //print(jsonResult["document"]!)
                    //print(type(of:result))
                    /*
                    let tasks = try decoder.decode([User].self, from: data)
                    tasks.forEach{ i in
                        print(i.userId)
                    }*/
                }catch{
                    print(error)
                }
            }
        }
        task.resume()

    }
     */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
