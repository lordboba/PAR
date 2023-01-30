//
//  ProgressView.swift
//  PAR
//
//  Created by Tyler Xiao on 1/30/23.
//

import SwiftUI
import SwiftUICharts

struct ProgressView: View {
    @StateObject var dataModel = DataModel()
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    //Text("hurb")
                   // let lastWeek = SwiftUI.Legend(color: .blue, label:"Past 7 Days")\
                    /*
                    let points : [DataPoint] = [
                        .init(value: 2, label : "2", legend:"Past 7 Days")
                    ]*/
                    /*
                    ForEach(dataModel.user_data["document"]["sessions"], id \.self) { session in
                        print(session)
                    }*/
                    let doc = dataModel.user_data["document"]
                    if doc != nil {
                        let bob = doc as! Dictionary<String,Any>
                        //let sessions = bob["sessions"] as! [[String:Any]]
                        //ForEach(sessions) { session in
                        //    var x = print(session)

                        //}
                    }
                    LineChartView(data:[8,23,54,32,12,37,7,23,43], title:"Past 7 Days",legend: "Productive Minutes", form: ChartForm.large)
                }
            }
            .navigationTitle("Progress")
            .onAppear {
                dataModel.fetch()
                //print(dataModel.user_data)
            }
        }
    }
}
private struct impression: Identifiable {
    var id: ObjectIdentifier
    let arr : [String:Any]
}
struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
