//
// This source file is part of the STRONGER based on the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import Foundation
import SpeziAccount
import SpeziFoundation
import SpeziValidation
import SpeziViews
import SwiftUI


// Declare a DateFormatter instance
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

/// The start date of a user.
public struct StartDateKey: AccountKey {
    public typealias Value = Date
    public static let name = LocalizedStringResource("START_DATE")
    public static let category: AccountKeyCategory = .personalDetails
}

extension AccountKeys {
    /// This is the StartDateKey of the user.
    public var startDate: StartDateKey.Type {
        StartDateKey.self
    }
}

extension AccountValues {
    /// This is the value of the start date to store.
    public var startDate: Date? {
        storage[StartDateKey.self]
    }
}

// MARK: - UI
extension StartDateKey {
    public struct DataDisplay: DataDisplayView {
        public typealias Key = StartDateKey
        private let startDate: Date
        public init(_ value: Date) {
            self.startDate = value
        }
        public var body: some View {
            HStack {
                Text(StartDateKey.name)
                Spacer()
                Text("\(startDate, formatter: dateFormatter)")
                    .foregroundColor(.secondary)
            }
            .accessibilityElement(children: .combine)
        }
    }
}

extension StartDateKey {
    public struct DataEntry: DataEntryView {
        public typealias Key = StartDateKey
        @Binding private var startDate: Date
        public var body: some View {
            HStack {
                Text(StartDateKey.name)
                Spacer()
                DatePicker(selection: $startDate, in: ...Date(), displayedComponents: .date) {
                    Text("")
                }
                .frame(width: 120) // set frame width to enable more spaces.
            }
        }
        public init(_ value: Binding<Date>) {
            self._startDate = value
        }
    }
}
