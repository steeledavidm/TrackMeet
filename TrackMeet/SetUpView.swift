//
//  SetUpView.swift
//  TrackMeet
//
//  Created by David Steele on 4/20/24.
//

import SwiftData
import SwiftUI

struct SetUpView: View {
    @Environment(\.modelContext) var modelContext
    @State private var path = NavigationPath()
    
    @Query(filter: #Predicate<TrackMeet> { $0.collectionOfRecords == false})
    var trackMeets: [TrackMeet]
    @Query var eventsList: [EventList]
    @Query var athletesList: [AthleteList]
    @Query(filter: #Predicate<TrackMeet> { $0.collectionOfRecords == true})
    var records: [TrackMeet]//only pull trackmeets with collectionOfRecords = true
    

    

  
    var body: some View {
        NavigationStack(path: $path) {
            List {
                NavigationLink(value: "trackMeet") {
                    Text("Track Meets")
                }
                .tag("Track Meets View")
                
                NavigationLink(value: "events") {
                    Text("Event")
                }
                .tag("Events")
                
                NavigationLink(value: "athletes") {
                    Text("Athletes")
                }
                .tag("Athletes")
                
                NavigationLink(value: "records") {
                    Text("Records")
                }
                .tag("Records")
                
            }

            .navigationDestination(for: String.self) { value in
                if value == "trackMeet" {
                    List {
                        ForEach(trackMeets) { trackMeet in
                            NavigationLink(value: trackMeet) {
                                Text(trackMeet.location)
                            }
                            .tag("\(trackMeet.location)")
                        }
                        .onDelete(perform: deleteTrackMeet)
                    }
                    .navigationTitle("Track Meets")
                    .navigationDestination(for: TrackMeet.self) {trackMeet in
                        AddTrackMeetView(trackMeet: trackMeet)
                    }
                    .toolbar {
                        Button("Add TrackMeet", systemImage: "plus", action: addTrackMeet)
                    }
                }
                if value == "events" {
                    List {
                        ForEach(eventsList) { event in
                            NavigationLink(value: event) {
                                VStack(alignment: .leading) {
                                    Text(event.name)
                                }
                            }
                        }
                        .onDelete(perform: deleteEvent)
                    }
                    .navigationTitle("Events")
                    .navigationDestination(for: EventList.self) {event in
                        AddEventView(eventList: event)
                    }
                    .toolbar {
                        Button("Add Event", systemImage: "plus", action: addEvent)
                    }
                }
                    
                if value == "athletes" {
                    List {
                        ForEach(athletesList) { athlete in
                            NavigationLink(value: athlete) {
                                VStack(alignment: .leading) {
                                    Text(athlete.name)
                                }
                            }
                        }
                        .onDelete(perform: deleteAthlete)
                    }
                    .navigationTitle("Athletes")
                    .navigationDestination(for: AthleteList.self) {athlete in
                        AddAthleteView(athleteList: athlete)
                    }
                    .toolbar {
                        Button("Add Athlete", systemImage: "plus", action: addAthlete)
                    }
                }
                
                if value == "records" {
                    List {
                        ForEach(records) { record in
                            NavigationLink(value: record) {
                                VStack(alignment: .leading) {
                                    Text(record.location)
                                }
                            }
                        }
                        .onDelete(perform: deleteRecord)
                    }
                    .navigationTitle("Records")
                    .navigationDestination(for: TrackMeet.self) {record in
                        AddRecordView(records: record)
                    }
                    .toolbar {
                        Button("Add Record Set", systemImage: "plus", action: addRecordGroup)
                    }
                }
                else {
                    EmptyView()
                }
            }
            .navigationTitle("Setup")
        }
    }
    
    
    
    func deleteTrackMeet(_ indexSet: IndexSet) {
        for index in indexSet {
            let trackMeet = trackMeets[index]
            modelContext.delete(trackMeet)
        }
    }
    
    func addTrackMeet() {
        let trackMeet = TrackMeet()
            trackMeet.collectionOfRecords = false
        var eventArray: [Event] = [Event]()
            for eventList in eventsList {
                var athleteArray: [Athlete] = [Athlete]()
                    for athleteList in athletesList {
                        let singleAthlete = Athlete(firstName: athleteList.firstName, lastName: athleteList.lastName, sex: athleteList.sex)
                        athleteArray.append(singleAthlete)
                    }
                    let athletes = athleteArray
                    let singleEvent = Event(name: eventList.name, type: eventList.type, gender: eventList.gender, distance: eventList.distance, timeMinutes: "00", timeSeconds: "00.00", athletes: athletes)
                
                eventArray.append(singleEvent)
            }
        trackMeet.events = eventArray
        
        modelContext.insert(trackMeet)
        path.append(trackMeet)
    }


    func deleteEvent(_ indexSet: IndexSet) {
        for index in indexSet {
            let event = eventsList[index]
            modelContext.delete(event)
        }
    }

    func addEvent() {
        let event = EventList()
        modelContext.insert(event)
        path.append(event)
    }
    
    func deleteAthlete(_ indexSet: IndexSet) {
        for index in indexSet {
            let athlete = athletesList[index]
            modelContext.delete(athlete)
        }
    }
    
    func addAthlete() {
        let athlete = AthleteList()
        modelContext.insert(athlete)
        path.append(athlete)
    }
    
    
    func addRecordGroup() {
        let trackMeet = TrackMeet()
        trackMeet.collectionOfRecords = true
        var eventArray: [Event] = [Event]()
            for eventList in eventsList {
                let singleEvent = Event(name: eventList.name, type: eventList.type, gender: eventList.gender, distance: eventList.distance, timeMinutes: "00", timeSeconds: "00.00", athletes: [Athlete]())
                eventArray.append(singleEvent)
            }
        trackMeet.events = eventArray
        modelContext.insert(trackMeet)
        
        

            path.append(trackMeet)
        }
    
    

    func deleteRecord(_ indexSet: IndexSet) {
        for index in indexSet {
            let record = records[index]
            modelContext.delete(record)
        }
    }
}


#Preview {
    SetUpView()
}
