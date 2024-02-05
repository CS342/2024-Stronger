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

import SwiftUI
import SpeziAccount
import SpeziMockWebService


struct HomeReal: View {
    static var accountEnabled: Bool {
        !FeatureFlags.disableFirebase && !FeatureFlags.skipOnboarding
    }
    
    @State private var presentingAccount = false
    
    var body: some View{
        NavigationView{
            VStack {
                Spacer()
                // Top section with SummaryInfo component
                Summary()
                // Bottom section with navigation buttons
                Spacer()
                HStack(spacing: 10) {
                    
                    NavigationLink(destination: Nutrition()) {
                        Text("Food")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity)
                    }
                    
                    
                    NavigationLink(destination: ExerciseView()) {
                        Text("Exercise")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity)
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

//#Preview {
//    CommandLine.arguments.append("--disableFirebase") // make sure the MockWebService is displayed
//    return HomeView()
//        .previewWith(standard: StrongerStandard()) {
//            StrongerScheduler()
//            MockWebService()
//            AccountConfiguration {
//                MockUserIdPasswordAccountService()
//            }
//        }
//}
#endif
