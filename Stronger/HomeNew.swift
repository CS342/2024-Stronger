//
//  HomeNew.swift
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

struct HomeNew: View {
    enum Tabs: String {
        case food
        case exercise
    }
    
    static var accountEnabled: Bool {
        !FeatureFlags.disableFirebase && !FeatureFlags.skipOnboarding
    }


    @AppStorage(StorageKeys.homeTabSelection) private var selectedTab = Tabs.food
    @State private var presentingAccount = false

    
    var body: some View {
        TabView(selection: $selectedTab) {
            ScheduleView(presentingAccount: $presentingAccount)
                .tag(Tabs.food)
                .tabItem {
                    Label("EXERCISE_TAB_TITLE", systemImage: "figure.run.circle")
                }
            Contacts(presentingAccount: $presentingAccount)
                .tag(Tabs.exercise)
                .tabItem {
                    Label("FOOD_TAB_TITLE", systemImage: "pencil.circle")
                }
        }
            .sheet(isPresented: $presentingAccount) {
                AccountSheet()
            }
            .accountRequired(Self.accountEnabled) {
                AccountSheet()
            }
            .verifyRequiredAccountDetails(Self.accountEnabled)
    }
}

#if DEBUG
#Preview {
    let details = AccountDetails.Builder()
        .set(\.userId, value: "lelandstanford@stanford.edu")
        .set(\.name, value: PersonNameComponents(givenName: "Leland", familyName: "Stanford"))
    
    return HomeNew()
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
