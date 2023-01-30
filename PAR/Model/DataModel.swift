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
    func fetch() {
        var temp = UserDefaults.standard.string(forKey: "USER_ID")
        temp = "63ba49616cdf01427d699c3f"
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
                            print("yoo")
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

    }

