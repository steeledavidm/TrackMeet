//
//  ContentView.swift
//  TrackMeet
//
//  Created by David Steele on 4/16/24.
//

//import SwiftData
import SwiftUI



struct ContentView: View {
    var body: some View {
        TabView {
            
            RecordView()
                .tabItem {
                    Label("Record", systemImage: "record.circle")
                }
            
            ResultsView()
                .tabItem {
                    Label("Results", systemImage: "figure.run")
                }
            SetUpView()
                .tabItem {
                    Label("Setup", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
