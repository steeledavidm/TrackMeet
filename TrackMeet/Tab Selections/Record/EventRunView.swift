//
//  EventRunView.swift
//  TrackMeet
//
//  Created by David Steele on 4/20/24.
//
import SwiftData
import SwiftUI

struct EventRunView: View {
    @Bindable var trackMeet: TrackMeet
    @Bindable var event: EventList
    @Bindable var athlete: AthleteList
    @Bindable var recordMeet: TrackMeet

    let eventRecordTime: Double

    @State var runViewButton: Bool = false
    @State var isTimerRunning: Bool = false
    
    @State var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    @State var trackPosition: Double = 0
    @State var raceStarted = false
    @State var timerStartTime: Date = Date()
    

    
    var body: some View {
        ZStack {
            
            TrackLayout()
                .stroke(.blue, lineWidth: 40)
                .shadow(color: .black, radius: 10)
                .background(.green)
            
            BestTimePosition(trackPosition: trackPosition)
                .stroke(.black, lineWidth: 30)
                .shadow(color: .black, radius: 5)
                .onReceive(timer) {_ in
                        trackPosition = calculateTrackPosition()
                }
            
            Button(action: buttonActions) {
                Text("")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 12)
            }
            .edgesIgnoringSafeArea(.horizontal)
            
            
            VStack {
                
                TimerView(runViewButton: $runViewButton, event: event, isTimerRunning: $isTimerRunning)
                
                    .offset(y: 150)
                Spacer()
                
            }
        }
        .navigationTitle("\(event.name) - \(athlete.name)")
    }
    
    func buttonActions() {
        runViewButton.toggle()
        if !raceStarted {
            timerStartTime = Date()
            raceStarted = true
        }

        print(" button pressed \(timerStartTime.timeIntervalSince1970)")
        }
    
    func calculateTrackPosition() -> Double {
        let distance = Double(event.distance) ?? 999
        let recordTimeInSeconds = eventRecordTime
        var timeSinceStart: TimeInterval
        print("totalSeconds \(recordTimeInSeconds)")
        let laps = distance / 400.0
        var racePosition: Double = 0
        var trackPosition: Double = 0
        var positionOffset: Double = 0
        
        let startPosition = (1.0 - laps.truncatingRemainder(dividingBy: 1)) * 100
        let finishPosition = startPosition + (laps * 100)
        print(raceStarted)
        
        if raceStarted {
            timeSinceStart = (Date().timeIntervalSince(timerStartTime))
            print(timerStartTime.timeIntervalSince1970)
            print("timeSinceStart \(timeSinceStart)")
            let rateLapsPerSecond = (laps / recordTimeInSeconds)
            print("rateLapsPerSecond \(rateLapsPerSecond)")
            positionOffset = (rateLapsPerSecond * timeSinceStart) * 100
            print(positionOffset)
            racePosition = startPosition + positionOffset
            print("racePosition \(racePosition)")
            
            if racePosition >= finishPosition {
                racePosition = finishPosition
                timer.upstream.connect().cancel()
            }
            trackPosition = racePosition.truncatingRemainder(dividingBy: 100)

        } else {
            trackPosition = startPosition
        }
        print("track Position \(trackPosition)")
        return trackPosition
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TrackMeetInfra.self, configurations: config)
        
        //Example Data Start
            let athlete1 = Athlete(id: UUID(), firstName: "firstName", lastName: "lastName", sex: "Male", PR: 99)
            let athlete2 = Athlete(id: UUID(), firstName: "firstName", lastName: "lastName", sex: "Female", PR: 99)
            
            let athletes = [athlete1, athlete2]

            let event1 = Event(id: UUID(), name: "Event1", type: "relay", gender: "boys", distance: "Distance", timeMinutes: "mm", timeSeconds: "ss.SS", athletes: athletes)
            
            let event2 = Event(id: UUID(), name: "Event2", type: "individual", gender: "boys", distance: "Distance", timeMinutes: "mm", timeSeconds: "ss.SS", athletes: athletes)
            
            let events = [event1, event2]

            let trackMeet1 = TrackMeet(id: UUID(), collectionOfRecords: false, location: "location", date: Date(), events: events)
            
            //let trackMeet2 = TrackMeet(id: UUID(), collectionOfRecords: false, location: "location", date: Date(), events: events)
            
            //let trackMeets = [trackMeet1, trackMeet2]
        
            let record1 = TrackMeet(id: UUID(), collectionOfRecords: true, location: "location", date: Date(), events: events)
            
            //let record2 = TrackMeet(id: UUID(), collectionOfRecords: true, location: "location", date: Date(), events: events)
            
            //let recordMeet = [record1, record2]
            

            let athleteFromList1 = AthleteList(firstName: "FirstName", lastName: "LastName", sex: "Sex")
            
            //let athleteFromList2 = AthleteList(firstName: "FirstName", lastName: "LastName", sex: "Sex")
            
            //let listOfAthletes = [athleteFromList1, athleteFromList2]
        
            let eventFromList1 = EventList(name: "Event1", type: "Individual", gender: "boys", distance: "100")
        
            //let eventFromList2 = EventList(name: "Event2", type: "Relay", gender: "girls", distance: "800")

            //let listOfEvents = [eventFromList1, eventFromList2]

        
        
            //let trackMeetInfra = TrackMeetInfra(id: UUID(), trackMeets: trackMeets, listOfEvents: listOfEvents, listOfAthletes: listOfAthletes)
        
        //Example Data End
        
        
        return EventRunView(trackMeet: trackMeet1, event: eventFromList1, athlete: athleteFromList1, recordMeet: record1, eventRecordTime: 99.9)
        
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}


