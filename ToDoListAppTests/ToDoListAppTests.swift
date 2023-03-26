//
//  ToDoListAppTests.swift
//  ToDoListAppTests
//
//  Created by Amelie Pocchiolo on 01/03/2023.
//

import XCTest
import CoreData
import SwiftUI
@testable import ToDoListApp

final class ToDoListAppTests: XCTestCase {
    let viewContext = PersistenceController(inMemory: true).container.viewContext
    @ObservedObject var vm = ViewModel()
    let app = XCUIApplication()

    func testAddTask() throws {
        let name = "Test Task"
        let priority = ToDoListApp.Priority.low
        let date = Date.now
        let alarm = Date.now
    
        vm.addNewTask(name: name, date: date, priority: priority, alarm: alarm)
        
        let list = app.collectionViews.element
        let initialListRows = list.cells.count
        
        XCTAssert(initialListRows == 1)
        XCTAssert(list.title == "Test Task")
    }
}
