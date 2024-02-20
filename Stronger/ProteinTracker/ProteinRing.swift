//
//  ProteinRing.swift
//  Stronger
//
//  Created by Tulika Jha on 18/02/24.
//

import SwiftUI


struct ProteinRing: View {
    @State private var drawingStroke = false
    
    let strawberry = Color(#colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1))
    let lime = Color(#colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1))
    let ice = Color(#colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1))
    let fractionComplete: Float
    
    init(fractionComplete: Float = 0.0) {
        self.fractionComplete = fractionComplete
    }
    
    let animation = Animation
            .easeOut(duration: 3)
//            .repeatForever(autoreverses: false)
            .delay(1)
    
    var body: some View {
        ZStack {
//                Color.black
                ring(for: strawberry)
                    .frame(width: 160)
//                ring(for: lime)
//                    .frame(width: 128)
//                ring(for: ice)
//                    .frame(width: 92)
            
        }
            .animation(animation, value: drawingStroke)
            .onAppear {
//                drawingStroke.toggle()
                drawingStroke = true
            }
    }
    
    func ring(for color: Color) -> some View {
        // Background ring
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 20))
            .foregroundStyle(.tertiary)
            .overlay {
                // Foreground ring
                Circle()
                    .trim(from: 0, to: drawingStroke ? CGFloat(fractionComplete) : 0)
                    .stroke(color.gradient,
                            style: StrokeStyle(lineWidth: 20, lineCap: .round))
            }
            .rotationEffect(.degrees(-90))
    }
}

#Preview {
    ProteinRing()
}
