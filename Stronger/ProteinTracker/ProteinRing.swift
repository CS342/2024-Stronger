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
    @State private var drawingStroke = false
    @State private var animation = Animation
            .easeOut(duration: 5)
            .delay(1)

    private var fractionComplete: Double
    private var color: Color

    var body: some View {
        ZStack {
                ring(for: color)
                    .frame(width: 160)
//                    .animation(animation, value: drawingStroke)
                    .onAppear {
                        drawingStroke.toggle()
                        drawingStroke = true
                        print("Inside the ring's onAppear. self.fractionComplete = \(fractionComplete)")
                    }
        }
    }

    init(fracComplete: Double = 0.0) {
        fractionComplete = fracComplete
        if fractionComplete >= 0.0 && fractionComplete < 0.66 {
            color = Color(.red)
        } else if fractionComplete >= 0.66 && fractionComplete < 0.98 {
            color = Color(.orange)
        } else {
            color = Color(.green)
        }
        print("fractioncomplete is = \(fractionComplete)")
    }

    private func ring(for color: Color) -> some View {
        // Background ring
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 20))
            .foregroundStyle(.tertiary)
            .overlay {
                // Foreground ring
                Circle()
                    .trim(from: 0, to: drawingStroke ? CGFloat(self.fractionComplete) : 0)
                    .stroke(
                        color.gradient,
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
            }
            .rotationEffect(.degrees(-90))
    }
}

#Preview {
    ProteinRing(fracComplete: 0.4)
}
