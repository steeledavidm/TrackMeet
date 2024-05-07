//
//  TrackLayout.swift
//  TrackMeet
//
//  Created by David Steele on 4/20/24.
//

import Foundation
import SwiftUI

struct TrackLayout: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let trackWidth: Double = 40
        let curveRadius = rect.maxX - rect.midX - trackWidth
        

        path.addArc(center: CGPoint(x: rect.midX, y: rect.minY + trackWidth / 2 + curveRadius), radius: curveRadius, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: true)
        path.addLine(to: CGPoint(x: rect.midX - curveRadius, y: rect.maxY - trackWidth / 2 - curveRadius))
        path.addArc(center: CGPoint(x: rect.midX, y: rect.maxY - trackWidth / 2 - curveRadius), radius: curveRadius, startAngle: .degrees(180), endAngle: .degrees(360), clockwise: true)
        path.closeSubpath()
        
        
        return path
    }
}
