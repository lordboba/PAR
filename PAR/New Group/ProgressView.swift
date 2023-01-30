//
//  ProgressView.swift
//  PAR
//
//  Created by Tyler Xiao on 1/30/23.
//

import SwiftUI
import SwiftUICharts
class DataModel: ObservableObject {
    @Published var user_data:DataUpdate = DataUpdate()
    func fetch() {
        let temp = UserDefaults.standard.string(forKey: "USER_ID")
        if temp == nil {
            //create new user first, then run api call
            return
        }
        guard let url = URL(string: "https://data.mongodb-api.com/app/data-rmmsc/endpoint/data/v1/action/findOne") else{return}
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        //replace the oid with temp variable
        let json: [String:Any] = ["collection": "actual","database": "user_data","dataSource": "PlanActRest","filter":["_id":["$oid":"63ba49616cdf01427d699c3f"]]]
        //print("rizz")
        let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("*", forHTTPHeaderField: "Access-Control-Request-Headers")
        request.setValue(Bundle.main.infoDictionary?["API_KEY"] as? String, forHTTPHeaderField: "api-key")
        //print("gru")

            let task = URLSession.shared.dataTask(with: request){ [weak self]
            data, response, error in
            //print("brp")
            //print(data!)
            if let data = data{
                do{
                    //print("dru")

                    //var jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                   // let data_result = jsonResult as! Dictionary<String,Any>
                    let data_ish = try JSONDecoder().decode(DataUpdate.self, from: data)
                        DispatchQueue.main.async {
                            self?.user_data = data_ish
                        }
                    print(data_ish)
                    //print(data_result)
                    //var id_var = data_result["document"] as! Dictionary<String,Any>
                }catch{
                    print(error)
                }
            }
        }
        task.resume()

    }
}
struct ProgressView: View {
    @StateObject var dataModel = DataModel()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text(String(dataModel.user_data.coins))
                }
            } .navigationTitle("Progress")
                .onAppear {
                    dataModel.fetch()
                }
        }
       
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
