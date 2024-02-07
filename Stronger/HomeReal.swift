//
//  Summary.swift
//  Stronger
//
//  Created by Theodore Kanell on 1/31/24.
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SpeziMockWebService
import SwiftUI


struct HomeRealView: View {
    static var accountEnabled: Bool {
        !FeatureFlags.disableFirebase && !FeatureFlags.skipOnboarding
    }
    
    @State private var presentingAccount = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Stronger")
                    .font(.largeTitle)
                Spacer()
                // Top section with SummaryInfo component
                Summary()
                // Bottom section with navigation buttons
                Spacer()
                HStack(spacing: 10) {
                    NavigationLink(destination: Nutrition()) {
                        Text("Food")
                            .modifier(ButtonHelp())
                    }
                    
                    
                    NavigationLink(destination: ExerciseView()) {
                        Text("Exercise")
                            .modifier(ButtonHelp())
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .frame(width: UIScreen.main.bounds.width * 0.9)
            }
            .navigationBarTitle("Home")
            .sheet(isPresented: $presentingAccount) {
                AccountSheet()
            }
            .accountRequired(Self.accountEnabled) {
                AccountSheet()
            }
            .verifyRequiredAccountDetails(Self.accountEnabled)
        }
    }
}


struct ButtonHelp: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(8)
            .frame(maxWidth: .infinity)
    }
}

#if DEBUG
#Preview {
    let details = AccountDetails.Builder()
        .set(\.userId, value: "lelandstanford@stanford.edu")
        .set(\.name, value: PersonNameComponents(givenName: "Leland", familyName: "Stanford"))
    
    return HomeReal()
        .previewWith(standard: StrongerStandard()) {
            StrongerScheduler()
            MockWebService()
            AccountConfiguration(building: details, active: MockUserIdPasswordAccountService())
        }
}

// #Preview {
//    CommandLine.arguments.append("--disableFirebase") // make sure the MockWebService is displayed
//    return HomeView()
//        .previewWith(standard: StrongerStandard()) {
//            StrongerScheduler()
//            MockWebService()
//            AccountConfiguration {
//                MockUserIdPasswordAccountService()
//            }
//        }
// }
#endif
