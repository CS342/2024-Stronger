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

// Store current week in user information.
// This can be updated.
// 

import SpeziAccount
import SpeziMockWebService
import SwiftUI

struct SummaryView: View {
    enum Tabs: String {
        case home
        case workout
        case chatWindow
    }
    
    static var accountEnabled: Bool {
        !FeatureFlags.disableFirebase && !FeatureFlags.skipOnboarding
    }
    @Environment(Account.self) var account
    
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
            if let details = account.details {
                if let name = details.name {
                    Text("Hello \(name.formatted(.name(style: .medium)))")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 50)
                } else {
                    Text("Hello World")
                }
            } else {
                Text("Hello World")
            }
            
            MainPage()
            Spacer()
            Text("This Week's Fitness Progress\n")
            ExerciseWeek(value: 2, presentingAccount: $presentingAccount)
            Spacer()
            Text("Last Week's Fitness Progress\n")
            ExerciseWeek(value: 1, presentingAccount: $presentingAccount)
            Spacer()
            ExerciseLogUploaderView()
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
