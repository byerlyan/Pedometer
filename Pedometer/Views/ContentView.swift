//
//  ContentView.swift
//  Pedometer
//
//  Created by Andrew Byerly on 5/28/25.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @State var healthKitManager = HealthKitManager.shared
    var body: some View {
        VStack {
            Button("Refresh", systemImage: "arrow.clockwise", action: healthKitManager.getAllData)
                .labelStyle(.iconOnly)
            
            Text("Steps: \(healthKitManager.stepsToday) ")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
