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
                    var doc = dataModel.user_data["document"]
                    if doc != nil {
                        var bob = doc as! Dictionary<String,Any>
                        var x = print(bob["sessions"])
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

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
