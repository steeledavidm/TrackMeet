//
//  BestTimePosition.swift
//  TrackMeet
//
//  Created by David Steele on 4/20/24.
//

import Foundation
import SwiftUI

struct BestTimePosition: Shape {
    let trackPosition: Double
    
        
    func path(in rect: CGRect) -> Path {
        var path = Path()
        var quadrantPosition: Double = 0
        let trackWidth: Double = 40
        let curveRadius = rect.maxX - rect.midX - trackWidth
        
        let topCurve = 0...25.0
        let leftStraight = 25.01...50
        let bottomCurve = 50.01...75
        let rightStraight = 75.01...100
        
        if topCurve.contains(trackPosition) {
            quadrantPosition = trackPosition / 25.0
            
            let positionStartAngle: Angle = .degrees(360 - (quadrantPosition * 180) + 0.5)
            let positionEndAngle: Angle = positionStartAngle - .degrees(1)
            
            path.addArc(center: CGPoint(x: rect.midX, y: rect.minY + trackWidth / 2 + curveRadius), radius: curveRadius, startAngle: positionStartAngle, endAngle: positionEndAngle, clockwise: true)
        }
        
        if leftStraight.contains(trackPosition) {
            quadrantPosition = (trackPosition - 25.0) / 25.0
            
            let xPosition = rect.midX - curveRadius
            
            let yMin = (rect.minY + trackWidth / 2 + curveRadius)
            let yMax = (rect.maxY - trackWidth / 2 - curveRadius)
            
            let yPosition  = yMin + (yMax - yMin) * quadrantPosition
            
            path.move(to: CGPoint(x: xPosition, y: yPosition - 1))
            path.addLine(to: CGPoint(x: xPosition, y: yPosition + 1))
        }
        if bottomCurve.contains(trackPosition) {
            quadrantPosition = (trackPosition - 50.0) / 25.0
            
            let positionStartAngle: Angle = .degrees(180 - (quadrantPosition * 180) + 0.5)
            let positionEndAngle: Angle = positionStartAngle - .degrees(1)
            
            path.addArc(center: CGPoint(x: rect.midX, y: rect.maxY - trackWidth / 2 - curveRadius), radius: curveRadius, startAngle: positionStartAngle, endAngle: positionEndAngle, clockwise: true)
        }
        if rightStraight.contains(trackPosition) {
            quadrantPosition = (trackPosition - 75.0) / 25.0
            
            let xPosition = rect.midX + curveRadius
            
            let yMin = (rect.maxY - trackWidth / 2 - curveRadius)
            let yMax = (rect.minY + trackWidth / 2 + curveRadius)
            
            let yPosition  = yMin + (yMax - yMin) * quadrantPosition
            
            path.move(to: CGPoint(x: xPosition, y: yPosition - 1))
            path.addLine(to: CGPoint(x: xPosition, y: yPosition + 1))
        }
        
        return path
    }
}

