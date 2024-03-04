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
    static var accountEnabled: Bool {
        !FeatureFlags.disableFirebase && !FeatureFlags.skipOnboarding
    }

    @Binding var presentingAccount: Bool

    var body: some View {
        NavigationStack {
            SummaryView()
                .id(UUID())
//            .navigationTitle(String(localized: "SUMMARY_NAVIGATION_TITLE"))
            .toolbar {
                if AccountButton.shouldDisplay {
                    AccountButton(isPresented: $presentingAccount)
                }
            }
        }
    }
    
    init(presentingAccount: Binding<Bool>) {
        self._presentingAccount = presentingAccount
    }
}

#if DEBUG
#Preview {
    Summary(presentingAccount: .constant(false))
}
#endif
