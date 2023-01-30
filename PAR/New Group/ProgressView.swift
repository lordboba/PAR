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
                   
                    BarChartView(data:ChartData(values:dataModel.graph), title:"Past 7 Days",legend: "Productive Minutes", form: ChartForm.medium)
                    
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
