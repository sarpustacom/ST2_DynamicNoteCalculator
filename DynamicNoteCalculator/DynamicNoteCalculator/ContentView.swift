//
//  ContentView.swift
//  DynamicNoteCalculator
//
//  Created by Sarp Ünsal on 16.09.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    
    @Environment(\.modelContext) var context
    @Query(sort: \Course.name, order: .forward) private var courseq : [Course]
    
    @State private var credits = 1
    @State private var name = ""
    @State private var note = 0.0
    @State private var average = 0.0
    @State private var creditTotal = 0
    @State private var courses: [Course] = []
    
    
    var body: some View {
        VStack {
            //MARK: NOTE ADD
            VStack {
                HStack {
                    //MARK: NOTE ADD TOOL
                    VStack {
                        //MARK: TEXTBOX NOTE NAME
                        TextField("Course Name", text: $name)
                            .padding()
                            .background(.green.opacity(0.2))
                            .background(.quaternary, in: RoundedRectangle(cornerRadius: 20))
                        //MARK: NOTE SELECT BUTTON + CREDIT SELECT
                       
                            //MARK: NOTE CREDIT SELECT
                            Stepper("\(credits) credit(s)", value: $credits,in: 1...10)
                            
                            //MARK: NOTE SELECT
                            Stepper("\(note, specifier: "%.2f")/4,0", value: $note, in: 0...4, step: 0.5)
                        
                        
                        //MARK: ADD BUTTON
                        Button(action: {
                            let newCourse = Course(credit: credits, note: note, name: name)
                            courses.append(newCourse)
                            context.insert(newCourse)
                            credits = 1
                            note = 0
                            name = ""
                            calculateAverage()
                        }, label: {
                            HStack {
                                Image(systemName: "folder.fill.badge.plus")
                                    
                                Text("Add")
                            }.padding(20)
                                .background(.green.opacity(0.2))
                                .background(.quaternary, in: RoundedRectangle(cornerRadius: 20))
                        })
                    }
                    //MARK: AVG TOOL
                    VStack {
                        Text("Average:")
                        Text("\(average, specifier: "%.2f")")
                            .font(.largeTitle)
                            .bold()
                        Text("\(creditTotal) credit(s)")
                    }
                    .padding()
                }
            }
            //MARK: NOTE LIST
            List(courses, id: \.name.hashValue) { course in
                CourseView(course: course)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            
                            courses.removeAll { c in
                                c.name == course.name
                            }
                            calculateAverage()
                            
                            context.delete(course)
                            
                            do {
                                try context.save()
                                print("Done")
                            } catch {
                                print("Error....")
                            }
                            
                            
                        } label: {
                            Text("Remove")
                        }

                    }
            }
        }
        .padding()
        .onAppear(perform: {
            courses = courseq
            calculateAverage()
        })
    }
                        
    func calculateAverage(){
        var x = 0.0
        creditTotal = 0
        courses.forEach { c in
            x += c.multiCreditNote()
            creditTotal += c.credit
        }
        if creditTotal > 0 {
            average = x / Double(creditTotal)
        }
        
    }
}

#Preview {
    ContentView()
}

struct CourseView: View {
    var course: Course
    var body: some View {
        HStack(alignment: .center){
            VStack(alignment:.leading) {
                Text(course.name)
                Text("\(course.credit) credit(s)")
            }
            Spacer()
            Text("\(course.note, specifier: "%.2f")/4,00").bold()
        }
    }
}
