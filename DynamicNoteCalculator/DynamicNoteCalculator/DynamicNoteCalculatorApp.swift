//
//  DynamicNoteCalculatorApp.swift
//  DynamicNoteCalculator
//
//  Created by Sarp Ünsal on 16.09.2024.
//

import SwiftUI
import SwiftData

@main
struct DynamicNoteCalculatorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Course.self)
    }
}
