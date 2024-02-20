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

/// The resistance of a user.
public struct GoalResistanceKey: AccountKey {
    public typealias Value = Int
    public static let name = LocalizedStringResource("GOAL_RESISTANCE")
    public static let category: AccountKeyCategory = .personalDetails
}


extension AccountKeys {
    /// this is the resistanceKey of the user
    public var goalresistance: GoalResistanceKey.Type {
        GoalResistanceKey.self
    }
}


extension AccountValues {
    /// this is the resistance value to be stored
    public var goalresistance: Int? {
        storage[GoalResistanceKey.self]
    }
}


// MARK: - UI
extension GoalResistanceKey {
    public struct DataDisplay: DataDisplayView {
        public typealias Key = GoalResistanceKey
        private let goalresistance: Int
        public init(_ value: Int) {
            self.goalresistance = value
        }
        public var body: some View {
            HStack {
                Text(GoalResistanceKey.name)
                Spacer()
                Text("\(goalresistance) kg")
                    .foregroundColor(.secondary)
            }
            .accessibilityElement(children: .combine)
        }
    }
}

extension GoalResistanceKey {
    public struct DataEntry: DataEntryView {
        public typealias Key = GoalResistanceKey
        @Binding private var goalresistance: Int
        public var body: some View {
            HStack {
                    Text(GoalResistanceKey.name)
                    Spacer()
                    TextField("Goal Resistance", value: $goalresistance, formatter: NumberFormatter())
                         .frame(width: 120) // set frame width to enable more spaces.
            }
        }
        public init(_ value: Binding<Int>) {
            self._goalresistance = value
        }
    }
}
