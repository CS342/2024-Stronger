//
//  Summary.swift
//  Stronger
//
//  Created by Theodore Kanell on 2/1/24.
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SpeziMockWebService
import SwiftUI

struct Summary: View {
    @State private var presentingAccount = false
    
    // var username: String
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var exerciseValue: Double = 50
    @State private var dietValue: Double = 80

    var body: some View {
        VStack {
            // Welcome message
            Text("Welcome Mary")
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(.bottom, 50)
            // Spacer()
            // Image and text boxes
            HStack {
//                Image(systemName: "person.circle")
//                    .resizable()
//                Rectangle()
//                    .fill(Color.gray)
//                    .frame(maxWidth: .infinity, maxHeight: 200)
//                    .padding(.trailing, 10)
                ProgressBar(title: "Exercise Progress", value: exerciseValue, barColor: .green)
                
                VStack(alignment: .leading) {
                    // Spacer()
                    Text("You've finished your exercises for the day! Way to go!")
                }
                .alignmentGuide(.imageAlignment) { tmp in tmp[.bottom] }
            }
            HStack {
                VStack(alignment: .leading) {
                    // Spacer()
                    Text("You've had 30 grams of protein today. 150 grams to go!")
                }
                .alignmentGuide(.imageAlignment) { tmp in tmp[.bottom] }

                ProgressBar(title: "Nutrition Progress", value: dietValue, barColor: .blue)
            }
        }
        .padding()
    }
}

extension VerticalAlignment {
    private enum ImageAlignment: AlignmentID {
        static func defaultValue(in tmp: ViewDimensions) -> CGFloat {
            tmp[.top]
        }
    }
    
    static let imageAlignment = VerticalAlignment(ImageAlignment.self)
}

#Preview {
    Summary()
}
