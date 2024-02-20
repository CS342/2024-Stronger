//
//  ProgressCircle.swift
//  Stronger
//
//  Created by Theodore Kanell on 2/15/24.
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct ProgressCircle: View {
    var progress: Double // Number of proteins consumed
    var totalProtein: Double // Total daily proteins consumed
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            let fillVal = progress / totalProtein
            Circle()
                .trim(from: 0.0, to: CGFloat(min(fillVal, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.green)
                .rotationEffect(.degrees(90)) // Start from the top (12 o'clock position)
                .animation(.easeInOut)
            
            Text("\(Int(progress)) g of your \(Int(totalProtein)) g goal.")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding(10)
                                .foregroundColor(.black)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
    }
}

// struct ContentViewPC: View {
//    @State private var progressValue: Double = 0 // Example value
//    
//    var body: some View {
//        VStack {
//            ProgressCircle(progress: 46, totalProtein: 66)
//                .frame(width: 150, height: 150)
//            
//            Slider(value: $progressValue, in: 0...100, step: 1)
//                .padding()
//        }
//        .padding()
//    }
// }

// #Preview {
//    ContentViewPC()
// }
