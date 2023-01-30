//
//  DataModel.swift
//  PAR
//
//  Created by Tyler Xiao on 1/30/23.
//
import Foundation
import SwiftUI
class DataModel: ObservableObject {
    @Published var user_data:Dictionary<String,Any> = [:]
    @Published var graph:[(String,Double)] = []
    @Published var graphImp:[(String,Double)] = []
    func fetch() {
        var temp = UserDefaults.standard.string(forKey: "USER_ID")
        temp = "63ba63c9d56bcbc03bc73117"
        print("yoo")
        if temp == nil {
            //create new user first, then run api call
            return
        }
        guard let url = URL(string: "https://data.mongodb-api.com/app/data-rmmsc/endpoint/data/v1/action/findOne") else{return}
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        //replace the oid with temp variable
        let json: [String:Any] = ["collection": "actual","database": "user_data","dataSource": "PlanActRest","filter":["_id":["$oid":temp]]]
        //print("rizz")
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("*", forHTTPHeaderField: "Access-Control-Request-Headers")
        request.setValue(Bundle.main.infoDictionary?["API_KEY"] as? String, forHTTPHeaderField: "api-key")
        print("gru")

            let task = URLSession.shared.dataTask(with: request){ [weak self]
            data, response, error in
            //print("brp")
            //print(data!)
                guard let data = data, error == nil else {
                    return
                }
                do{
                    //print("dru")

                    //
                   // let data_result = jsonResult as! Dictionary<String,Any>
                    let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    //print(jsonResult)
                    //let data_ish = try JSONDecoder().decode(DataUpdate.self, from: data)
                    //print("chicken?")
                    //self?.user_data = jsonResult
                        DispatchQueue.main.async {
                            self?.user_data = jsonResult as! Dictionary<String,Any>
                            //print("yoo")
                            self?.processData()
                        }
                    
                    //print(self?.user_data)
                    //print(data_ish)
                    //print(data_result)
                    //var id_var = data_result["document"] as! Dictionary<String,Any>
                }catch{
                    print(error)
                }
            }
            task.resume()

        }
    func processData() {
        let doc = user_data["document"]
        let date = Date()
        var startDate = date - TimeInterval(Double(518400))
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY-MM-dd"
        let tempDate = dateFormatter.string(from: startDate) + " 00:00:00"
        dateFormatter.dateFormat = "YY-MM-dd HH:mm:ss"
        startDate = dateFormatter.date(from: tempDate)!
        print(startDate)
        //print(doc)
        var temporDate = startDate
        for i in 0..<7{
            dateFormatter = DateFormatter()
              dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
              dateFormatter.dateFormat = "MM-dd-YY"
            graph.append((dateFormatter.string(from: temporDate),0))
            graphImp.append((dateFormatter.string(from: temporDate),0))

            temporDate = temporDate + TimeInterval(Double(86400))
        }
        //graph = [0,0,0,0,0,0,0]
        var totalImp = 0.0
        var numImp = 0
        var currDex = 0
        if doc != nil {
            let bob = doc as! Dictionary<String,Any>
            let sessions = bob["sessions"] as! [[String:Any]]
            for i in 0..<sessions.count {
                let sess = sessions[i]
                //print(sess["time"])
            //    var x = print(session)
                dateFormatter = DateFormatter()
                  dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                  dateFormatter.dateFormat = "YY-MM-dd HH:mm:ss"
                let currDate = dateFormatter.date(from:sess["date"] as! String)!
                if currDate >= startDate {
                    let difference = -Int(startDate.timeIntervalSince(currDate))/(86400)
                    //print(sess["time"])
                    if difference > currDex {
                        while currDex < difference {
                            let tempName = graphImp[Int(currDex)].0
                            let tempSum = totalImp/Double(numImp)
                            graphImp[Int(currDex)] = (tempName, tempSum)
                            currDex += 1
                        }
                    }
                    if sess["time"] != nil {
                        let tempName = graph[Int(difference)].0
                        let tempSum = graph[Int(difference)].1 + Double(sess["time"] as! String)!
                        totalImp += Double(sess["impression"] as! String)!
                        numImp += 1
                        graph[Int(difference)] = (tempName,tempSum)
                        //print(difference)
                    }
                    
                }
                //print(currDate)
            }
        }
        let tempName = graphImp[Int(currDex)].0
        let tempSum = totalImp/Double(numImp)
        graphImp[Int(currDex)] = (tempName, tempSum)
        
        print(graphImp)
    }
}

