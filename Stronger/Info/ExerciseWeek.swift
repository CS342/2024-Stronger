//
//  ExerciseWeek.swift
//  Stronger
//
//  Created by Theodore Kanell on 2/19/24.
//

import SwiftUI

struct ExerciseWeek: View {
    var value: String
    var body: some View {
        HStack {
            NavigationLink(destination: WorkoutHome(presentingAccount: .constant(false))) {
                Text("\(value)")
                    .modifier(NavButton())
            }
            NavigationLink(destination: WorkoutHome(presentingAccount: .constant(false))) {
                Text("Hard")
                    .modifier(NavButton())
            }
            NavigationLink(destination: WorkoutHome(presentingAccount: .constant(false))) {
                Text("Hard")
                    .modifier(NavButton())
            }
        }
    }
}

#Preview {
    ExerciseWeek(value: "Easy")
}
