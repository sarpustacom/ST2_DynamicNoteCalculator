//
//  Course.swift
//  DynamicNoteCalculator
//
//  Created by Sarp Ünsal on 16.09.2024.
//

import Foundation

import SwiftData

@Model
class Course {
    let credit : Int
    let note : Double
    let name : String
    
    init(credit: Int, note: Double, name: String) {
        self.credit = credit
        self.note = note
        self.name = name
    }
    
    func multiCreditNote() -> Double {
        return Double(credit) * note
    }
}
