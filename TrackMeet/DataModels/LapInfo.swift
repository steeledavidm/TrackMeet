//
//  LapInfo.swift
//  TrackMeet
//
//  Created by David Steele on 4/16/24.
//

import Foundation

struct LapInfo: Hashable {
    var lapID: Int
    var lapTime: TimeInterval
    var cumulativeTime: TimeInterval
}
