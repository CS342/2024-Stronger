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

struct SummaryView: View {
    static var accountEnabled: Bool {
        !FeatureFlags.disableFirebase && !FeatureFlags.skipOnboarding
    }

   
    @State private var presentingAccount = false
    
    // var username: String
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var exerciseValue: Double = 50
    @State private var dietValue: Double = 80
    @State private var totalProtein: Double = 66

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
                ProgressCircle(progress: dietValue, totalProtein: totalProtein)
                
                VStack(alignment: .leading) {
                    // Spacer()
                    Text("Daily Protein:\n")
                    Text("Log more with Pro-Bot")
                }
                .alignmentGuide(.imageAlignment) { tmp in tmp[.bottom] }
            }
            Spacer()
            ExerciseWeek(value: "Easy")
            ExerciseWeek(value: "Medium")
            Spacer()
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
    SummaryView()
}
