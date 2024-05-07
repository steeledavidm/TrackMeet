//
//  TimerView.swift
//  TrackMeet
//
//  Created by David Steele on 4/16/24.
//

import SwiftData
import SwiftUI



struct TimerView: View {
    @Binding var runViewButton: Bool
    @Bindable var event: EventList
    
    @State private var raceStartTime: Date?
    @State private var lapStartTime: Date?
    @State private var timerString = "00:00.00"
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var lapCounter = 0
    @State private var lapTimes = [LapInfo]()
    @State private var numberOfLaps: Int = 1
    @State private var lapInfo = LapInfo(lapID: 0, lapTime: 0, cumulativeTime: 0)
    @State private var currentLapTimeString: String = ""
    
    @State private var type = ""

    
    @Binding var isTimerRunning: Bool
    
    var body: some View {
        VStack {

                Text(timerString)
                .font(.custom("DSEG7Modern-Regular", size: 45))
                    .onReceive(timer) { _ in
                        if isTimerRunning {
                            
                            timerString = format(Date().timeIntervalSince(raceStartTime ?? Date()))
                        }
                    }
            
            
            
            ForEach (lapTimes, id: \.self) {lapTime in
                HStack {
                    Text("\(type) \(lapTime.lapID)")
                    Text(format(lapTime.lapTime))
                    Text(format(lapTime.cumulativeTime))
                }
            }

            HStack {
                Text("Current \(type)")
                Text(currentLapTimeString)
                    .onReceive(timer) { _ in
                        currentLapTimeString = format(Date().timeIntervalSince(lapStartTime ?? Date()))
                    }
            }
            
            
            
            .onChange(of: runViewButton) {
                print(runViewButton)
                let distance = Double(event.distance) ?? 400
                if distance > 400 {
                    numberOfLaps = Int(1.0 + distance / 400.0)
                    print("number of laps \(numberOfLaps)")
                } else { numberOfLaps = 1
                }
                if event.type == "Relay" {
                    numberOfLaps = 4
                }
                if isTimerRunning {
                    if lapCounter > 0 {
                        lapInfo.lapID = lapCounter
                        lapInfo.lapTime = (Date().timeIntervalSince(lapStartTime ?? Date()))
                        lapInfo.cumulativeTime = (Date().timeIntervalSince(raceStartTime ?? Date()))
                        lapStartTime = Date()
                        lapTimes.append(lapInfo)
                        lapCounter += 1
                    }
                    if lapCounter > numberOfLaps {
                        stopTimer()
                        isTimerRunning.toggle()
                    }
                } else {
                    timerString = "00:00.00"
                    raceStartTime = Date()
                    lapStartTime = Date()
                    startTimer()
                    isTimerRunning = true
                    lapCounter = 1
                    lapTimes.removeAll()
                }
            }
        }
            .onAppear() {
                // no need for UI updates at startup
                stopTimer()
                UIApplication.shared.isIdleTimerDisabled = true
                
                if event.type == "Relay" {
                    type = "Split"
                } else {
                    type = "Lap"
                }
            }
        
            .onDisappear {
                UIApplication.shared.isIdleTimerDisabled = false
            }
            //.frame(width: 400, height: 20)
        
    }

    
    
            
        func stopTimer() {
            timer.upstream.connect().cancel()
            print("stop timer function")
        }
        
        func startTimer() {
            timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
        }
        
        func format(_ duration: TimeInterval) -> String {
            
            let durationInt = Int(duration)
            
            let SSInt = Int((duration.truncatingRemainder(dividingBy: 1)) * 100)
            let ssInt = durationInt % 60
            let mmInt = (durationInt / 60) % 60
            
            var SS = "\(SSInt)"
            if SS.count < 2 {
                SS = "0\(SS)"
            }
            var ss = "\(ssInt)"
            if ss.count < 2 {
                ss = "0\(ss)"
            }
            var mm = "\(mmInt)"
            if mm.count < 2 {
                mm = "0\(mm)"
            }
            
            return("\(mm):\(ss).\(SS)")
            
        }
    }

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TrackMeetInfra.self, configurations: config)
        
        //Example Data Start
        
            let eventFromList1 = EventList(name: "Event1", type: "Individual", gender: "boys", distance: "100")

        
        //Example Data End
        
        
        return TimerView(runViewButton: .constant(false), event: eventFromList1, isTimerRunning: .constant(false))
        
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}



 
