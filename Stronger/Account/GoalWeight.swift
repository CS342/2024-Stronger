//
// This source file is part of the PICS based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//
import SpeziAccount
import SpeziFoundation
import SpeziValidation
import SpeziViews
import SwiftUI

/// The weight of a user.
public struct GoalWeightKey: AccountKey {
    public typealias Value = Int
    public static let name = LocalizedStringResource("GOAL_WEIGHT")
    public static let category: AccountKeyCategory = .personalDetails
}


extension AccountKeys {
    /// this is the weightKey of the user
    public var goalweight: GoalWeightKey.Type {
        GoalWeightKey.self
    }
}


extension AccountValues {
    /// this is the weight value to be stored
    public var goalweight: Int? {
        storage[GoalWeightKey.self]
    }
}


// MARK: - UI
extension GoalWeightKey {
    public struct DataDisplay: DataDisplayView {
        public typealias Key = GoalWeightKey
        private let goalweight: Int
        public init(_ value: Int) {
            self.goalweight = value
        }
        public var body: some View {
            HStack {
                Text(GoalWeightKey.name)
                Spacer()
                Text("\(goalweight) kg")
                    .foregroundColor(.secondary)
            }
            .accessibilityElement(children: .combine)
        }
    }
}

extension GoalWeightKey {
    public struct DataEntry: DataEntryView {
        public typealias Key = GoalWeightKey
        @Binding private var goalweight: Int
        public var body: some View {
            HStack {
                    Text(GoalWeightKey.name)
                    Spacer()
                    TextField("Goal Weight", value: $goalweight, formatter: NumberFormatter())
                         .frame(width: 120) // set frame width to enable more spaces.
            }
        }
        public init(_ value: Binding<Int>) {
            self._goalweight = value
        }
    }
}
