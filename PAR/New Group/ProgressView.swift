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
                    Text("hurb")
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
