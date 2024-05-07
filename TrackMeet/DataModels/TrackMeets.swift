//
//  DataModel.swift
//  TrackMeets
//
//  Created by David Steele on 4/17/24.
//

import Foundation
import SwiftData

    
@Model
class TrackMeetInfra {
    var id = UUID()
    var trackMeets: [TrackMeet]
    var listOfEvents: [EventList]
    var listOfAthletes: [AthleteList]
    
    init(id: UUID = UUID(), trackMeets: [TrackMeet], listOfEvents: [EventList] = [EventList](), listOfAthletes: [AthleteList] = [AthleteList]()) {
        self.id = id
        self.trackMeets = trackMeets
        self.listOfEvents = listOfEvents
        self.listOfAthletes = listOfAthletes
    }
}

@Model
class TrackMeet {
    var id = UUID()
    var collectionOfRecords: Bool // indicates if it is an actual trackmeet or a collection of records
    var location: String
    var date: Date
    var events: [Event]
    
    init(id: UUID = UUID(), collectionOfRecords: Bool = false, location: String = "", date: Date = Date(), events: [Event] = [Event]()) {
        self.id = id
        self.collectionOfRecords = collectionOfRecords
        self.location = location
        self.date = date
        self.events = events
    }
}
@Model
class Event {
    let id: UUID
    var name: String
    var type: String //Individual, relay
    var gender: String // boys or girls event
    var distance: String
    var timeMinutes: String
    var timeSeconds: String
    var athletes: [Athlete]? = [Athlete]()
    
    var totalSeconds: Double {
        (Double(timeMinutes) ?? 99) * 60 + (Double(timeSeconds) ?? 99)
    }
    var timeString: String {
        timeMinutes + ":" + timeSeconds
    }
    var distanceDouble: Double {
        Double(distance) ?? 1
    }
    
    init(id: UUID = UUID(), name: String = "", type: String = "", gender: String = "", distance: String = "", timeMinutes: String = "", timeSeconds: String = "", athletes: [Athlete]) {
        self.id = id
        self.name = name
        self.type = type
        self.gender = gender
        self.distance = distance
        self.timeMinutes = timeMinutes
        self.timeSeconds = timeSeconds
        self.athletes = athletes
    }
}
@Model
class Athlete {
    
    let id: UUID
    var firstName: String
    var lastName: String
    var sex: String
    var PR: TimeInterval?
    
    var name: String {
        ("\(firstName) \(lastName)")
    }
    
    init(id: UUID = UUID(), firstName: String = "", lastName: String = "", sex: String = "", PR: TimeInterval? = nil) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.sex = sex
        self.PR = PR
    }
}

@Model
class EventList {
    let id = UUID()
    var name: String
    var type: String //Individual, relay
    var gender: String // boys or girls event
    var distance: String
    
    init(name: String = "", type: String = "", gender: String =  "", distance: String = "") {
        self.name = name
        self.type = type
        self.gender = gender
        self.distance = distance
    }
}

@Model
class AthleteList {
    
    let id = UUID()
    var firstName: String
    var lastName: String
    var sex: String
    var name: String {
        ("\(firstName) \(lastName)")
    }
    
    init(firstName: String = "", lastName: String = "", sex: String = "") {
        self.firstName = firstName
        self.lastName = lastName
        self.sex = sex
    }
}

