//
//  AddTrackMeetView.swift
//  TrackMeet
//
//  Created by David Steele on 4/21/24.
//
import SwiftData
import SwiftUI

struct AddTrackMeetView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var trackMeet: TrackMeet
    
    @State var selectedAthlete: Athlete = Athlete()
    var body: some View {
        Form {
            DatePicker("Date", selection: $trackMeet.date)
            TextField("Location", text: $trackMeet.location)
                .navigationTitle("Add Trackmeet")
            
            Section("Events") {
                List{
                    ForEach($trackMeet.events, id: \.self) {$event in
                        HStack {
                            Text(event.name)
                            Text(event.gender)
                            Picker("", selection: $selectedAthlete) {
                                Text("Not selected").tag(nil as Athlete?)
                                ForEach(event.athletes ?? [Athlete](), id: \.self) {selectedAthlete in
                                    Text(selectedAthlete.name).tag(selectedAthlete as Athlete)
                                }
                            }
                            .pickerStyle(.automatic)
                        }
                    }
                    .onDelete(perform: deleteEvent)
                }
            }
        }
            .navigationTitle("Edit Destination")
            .navigationBarTitleDisplayMode(.inline)
    }
    func deleteEvent(_ indexSet: IndexSet) {
        for index in indexSet {
            let event = trackMeet.events[index]
            modelContext.delete(event)
        }
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
        
        
        //Example Data End
        
        return AddTrackMeetView(trackMeet: trackMeet2)
        
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}
 
 
