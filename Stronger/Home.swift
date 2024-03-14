//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import SpeziAccount
import SpeziMockWebService
import SwiftUI


enum Tabs: String {
    case home
    case workout
    case chatWindow
}

struct TabViewChatWindow: View {
    var body: some View {
        ChatWindow()
            .tag(Tabs.chatWindow)
            .tabItem {
                Label("ProBot", systemImage: "fork.knife")
            }
    }
}

struct HomeView: View {
    enum Tabs: String {
        case home
        case workout
        case foodClassifierApp
    }
    
    static var accountEnabled: Bool {
        !FeatureFlags.disableFirebase && !FeatureFlags.skipOnboarding
    }

    @AppStorage(StorageKeys.homeTabSelection) private var selectedTab = Tabs.home
    @State private var presentingAccount = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Summary(presentingAccount: $presentingAccount)
                .tag(Tabs.home)
//             MainPage()
//                 .tag(Tabs.mainPage)
                .tabItem {
                    Label("HOME_TAB_TITLE", systemImage: "house.fill")
                }
//                .id(UUID())

            WorkoutSelection(presentingAccount: $presentingAccount)
                .tag(Tabs.workout)
                .tabItem {
                    Label("Workout", systemImage: "dumbbell.fill") // change icon later
                }
            // TabViewChatWindow()
            ProteinTrackerOptions()
                .tag(Tabs.foodClassifierApp)
                .tabItem {
                    Label("Food Tracking", systemImage: "fork.knife")
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
    
    return HomeView()
        .previewWith(standard: StrongerStandard()) {
//            StrongerScheduler()
//            MockWebService()
            AccountConfiguration(building: details, active: MockUserIdPasswordAccountService())
        }
}

#Preview {
    CommandLine.arguments.append("--disableFirebase") // make sure the MockWebService is displayed
    return HomeView()
        .previewWith(standard: StrongerStandard()) {
//            StrongerScheduler()
//            MockWebService()
            AccountConfiguration {
                MockUserIdPasswordAccountService()
            }
        }
}
#endif
