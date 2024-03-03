//
//  ProteinRing.swift
//  Stronger
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
//  Created by Tulika Jha on 18/02/24.
//

import SwiftUI


struct ProteinRing: View {
    @State private var fractionComplete: Float
    @State private var drawingStroke = false
    @State private var strawberry = Color(red: 1, green: 0.1857388616, blue: 0.5733950138, opacity: 1)
    @State private var animation = Animation
            .easeOut(duration: 5)
            .delay(1)
    
    var body: some View {
        ZStack {
                ring(for: strawberry)
                    .frame(width: 160)
//                    .animation(animation, value: drawingStroke)
                    .onAppear {
                        drawingStroke.toggle()
                        drawingStroke = true
                    }
        }
    }
    
    init(fractionComplete: Float = 0.0) {
        self.fractionComplete = fractionComplete
    }
    
    private func ring(for color: Color) -> some View {
        // Background ring
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 20))
            .foregroundStyle(.tertiary)
            .overlay {
                // Foreground ring
                Circle()
                    .trim(from: 0, to: drawingStroke ? CGFloat(fractionComplete) : 0)
                    .stroke(
                        color.gradient,
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
            }
            .rotationEffect(.degrees(-90))
    }
}

#Preview {
    ProteinRing()
}
