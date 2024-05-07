//
//  TrackMeetApp.swift
//  TrackMeet
//
//  Created by David Steele on 4/16/24.
//

import SwiftData
import SwiftUI

@main
struct TrackMeetApp: App {
    var body: some Scene {
        WindowGroup {
        ContentView()
        }
        .modelContainer(for: TrackMeetInfra.self)
    }
}
