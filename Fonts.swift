//
//  Fonts.swift
//  TrackMeet
//
//  Created by David Steele on 5/7/24.
//

import SwiftUI

struct Fonts: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    init() {
        for familyName in UIFont.familyNames { print(familyName)
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print("-- \(fontName)")
            }
        }
    }
}

#Preview {
    Fonts()
}
