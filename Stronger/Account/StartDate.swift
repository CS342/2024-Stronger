//
// This source file is part of the Stronger based on the Stanford Spezi Template Application project
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


/// The start date of a user.
public struct StartDateKey: AccountKey {
    public typealias Value = Date
    public typealias DataEntry = StartDatePicker

    public static let name = LocalizedStringResource("START_DATE_TITLE")

    public static let category: AccountKeyCategory = .personalDetails
    
    public static var initialValue: InitialValue<Value> {
        .default(Date())
    }
//    public static var initialValue: Date {
//        Date()
//    }
}

extension AccountKeys {
    /// The start date ``AccountKey`` metatype.
    public var startDate: StartDateKey.Type {
        StartDateKey.self
    }
}


extension AccountValues {
    /// Access the start date of a user.
    public var startDate: Date? {
        storage[StartDateKey.self]
    }
}


// MARK: - UI

extension StartDateKey {
    public struct DataDisplay: DataDisplayView {
        public typealias Key = StartDateKey

        private let value: Date

        @Environment(\.locale) private var locale

        private var formatStyle: Date.FormatStyle {
            .init()
                .locale(locale)
                .year(.defaultDigits)
                .month(locale.identifier == "en_US" ? .abbreviated : .defaultDigits)
                .day(.defaultDigits)
        }

        public var body: some View {
            ListRow(Key.name) {
                Text(value.formatted(formatStyle))
            }
        }


        public init(_ value: Date) {
            self.value = value
        }
    }
}
