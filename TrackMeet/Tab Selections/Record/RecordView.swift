//
//  RecordView.swift
//  TrackMeet
//
//  Created by David Steele on 4/28/24.
//
import SwiftData
import SwiftUI

struct RecordView: View {

    @Query(filter: #Predicate<TrackMeet> { $0.collectionOfRecords == false})
    var trackMeets: [TrackMeet]
    
    @Query var eventsList: [EventList]
    @Query var athletesList: [AthleteList]
    
    @Query(filter: #Predicate<TrackMeet> { $0.collectionOfRecords == true})
    var records: [TrackMeet]//only pull trackmeets with collectionOfRecords = true
    
    @State private var selectedTrackMeet: TrackMeet = TrackMeet()
    @State private var selectedEvent: EventList = EventList()
    @State private var selectedAthlete: AthleteList = AthleteList()
    @State private var selectedRecord: TrackMeet = TrackMeet()
    
    @State private var readyToStart = false
    @State private var recordEvent: Event = Event(athletes: [Athlete]())
    @State private var eventRecordTime: Double = 0
    
    
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section("Select Track Meet") {
                        Picker("Track Meet", selection: $selectedTrackMeet) {
                            Text("Not selected").tag(nil as TrackMeet?)
                            ForEach(trackMeets, id: \.self) {selectedTrackMeet in
                                Text(selectedTrackMeet.location).tag(selectedTrackMeet as TrackMeet?)
                            }
                        }
                        .pickerStyle(.automatic)
                        
                    }
                    
                    Section("Select Event") {
                        Picker("Event", selection: $selectedEvent) {
                            Text("Not selected").tag(nil as Event?)
                            ForEach(eventsList, id: \.self) {selectedEvent in
                                Text(selectedEvent.name).tag(selectedEvent as EventList?)
                            }
                        }
                        .pickerStyle(.automatic)
                    }
                     
                    Section("Select Athlete") {
                        Picker("Athlete", selection: $selectedAthlete) {
                            Text("Not selected").tag(nil as Athlete?)
                            ForEach(athletesList, id: \.self) {selectedAthlete in
                                Text(selectedAthlete.name).tag(selectedAthlete as AthleteList?)
                            }
                        }
                        .pickerStyle(.automatic)
                    }
                    
                    Section("Select Record") {
                        Picker("Record", selection: $selectedRecord) {
                            Text("Not selected").tag(nil as TrackMeet?)
                            ForEach(records, id: \.self) {selectedRecord in
                                Text(selectedRecord.location).tag(selectedRecord as TrackMeet?)
                            }
                        }
                        .pickerStyle(.automatic)
                    }
                }
                .padding()
                Button("Ready") {
                    for event in selectedRecord.events {
                        if event.name == selectedEvent.name {
                            eventRecordTime = event.totalSeconds
                            print(event.name)
                        }
                    }
                    print(recordEvent.totalSeconds)
                    
                    readyToStart = true
                }
                .navigationDestination(isPresented: $readyToStart) {EventRunView(trackMeet: selectedTrackMeet, event: selectedEvent, athlete: selectedAthlete, recordMeet: selectedRecord, eventRecordTime: eventRecordTime)
                        .toolbar(.hidden, for: .tabBar)
                }

            }
                
            .padding()
        }
        .navigationTitle("Set up for Race")
        
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TrackMeetInfra.self, configurations: config)
        
        //Example Data Start 
        /*
            let athlete1 = Athlete(id: UUID(), firstName: "firstName", lastName: "lastName", sex: "Male", PR: 99)
            let athlete2 = Athlete(id: UUID(), firstName: "firstName", lastName: "lastName", sex: "Female", PR: 99)
            
            let athletes = [athlete1, athlete2]

            let event1 = Event(id: UUID(), name: "Event1", type: "relay", gender: "boys", distance: "Distance", timeMinutes: "mm", timeSeconds: "ss.SS", athletes: athletes)
            
            let event2 = Event(id: UUID(), name: "Event2", type: "individual", gender: "boys", distance: "Distance", timeMinutes: "mm", timeSeconds: "ss.SS", athletes: athletes)
            
            let events = [event1, event2]

            let trackMeet1 = TrackMeet(id: UUID(), collectionOfRecords: false, location: "location", date: Date(), events: events)
            
            let trackMeet2 = TrackMeet(id: UUID(), collectionOfRecords: false, location: "location", date: Date(), events: events)
            
            let trackMeets = [trackMeet1, trackMeet2]
        
            let record1 = TrackMeet(id: UUID(), collectionOfRecords: true, location: "location", date: Date(), events: events)
            
            let record2 = TrackMeet(id: UUID(), collectionOfRecords: true, location: "location", date: Date(), events: events)
            
            let recordMeet = [record1, record2]
            

            let athleteFromList1 = AthleteList(firstName: "FirstName", lastName: "LastName", sex: "Sex")
            
            let athleteFromList2 = AthleteList(firstName: "FirstName", lastName: "LastName", sex: "Sex")
            
            let listOfAthletes = [athleteFromList1, athleteFromList2]

            let eventFromList1 = EventList(name: "Event1", type: "Individual", gender: "boys", distance: "100")
        
            let eventFromList2 = EventList(name: "Event2", type: "Relay", gender: "girls", distance: "800")

            let listOfEvents = [eventFromList1, eventFromList2]

        
        
            let trackMeetInfra = TrackMeetInfra(id: UUID(), trackMeets: trackMeets, listOfEvents: listOfEvents, listOfAthletes: listOfAthletes)
        */
        
        //Example Data End
        
        
        return RecordView()
        
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}

 
 
 
