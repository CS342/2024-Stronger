//
//  ProgressBar.swift
//  Stronger
//
//  Created by Theodore Kanell on 2/6/24.
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SwiftUI
struct ProgressBar: View {
    var title: String?
    var value: Double // Value between 0 and 100
    var barColor: Color // Custom color for the progress bar
    
    var body: some View {
        VStack {
            if let title = title {
                Text(title)
                    .font(.headline)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    Rectangle() // Background
                        .frame(width: 40, height: geometry.size.height - 50)
                        .foregroundColor(Color.gray)
                        .cornerRadius(5)
                    
                    Rectangle() // Filled portion
                        .frame(width: 40, height: CGFloat(value) / 100 * (geometry.size.height - 50))
                        .foregroundColor(Color.blue)
                        .cornerRadius(5)
                }
                // .rotationEffect(.degrees(-90))
                .frame(width: geometry.size.width - 5, height: geometry.size.height - 50)
                

//                Text("\(Int(value))")
//                    .font(.caption)
//                    .foregroundColor(.black)
                // HStack(spacing: 0) {
                //     ForEach([0, 25, 50, 75, 100], id: \.self) { tick in
                //         VStack(spacing: 0) {
                //             Spacer()
                //             if tick % 25 == 0 {
                //                 Text("\(tick)")
                //                     .font(.caption)
                //                     .padding(.bottom, 2)
                //             }
                //             Rectangle()
                //                 .frame(width: 1, height: 5)
                //                 .foregroundColor(.black)
                //         }
                //         .frame(height: 15)
                //         .offset(x: CGFloat(tick) / 100 * geometry.size.height)
                //     }
                // }

            }
            .frame(maxWidth: .infinity)
        }
    }
}


#Preview {
    ProgressBar(title: "Sample", value: 50, barColor: .red)
}
