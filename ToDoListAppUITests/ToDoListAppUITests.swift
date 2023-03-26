//
//  ToDoListAppUITests.swift
//  ToDoListAppUITests
//
//  Created by Amelie Pocchiolo on 01/03/2023.
//

import XCTest
import ToDoListApp

final class ToDoListAppUITests: XCTestCase {
    let app = XCUIApplication()
    let tasks = TaskList()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }

    func testIsExistContentView() throws {
        app.launch()
        let navBarTitle = app.navigationBars["Task"]
        let navEdit = app.navigationBars.element.buttons["Edit"]
        let navAdd = app.navigationBars.element.buttons["AddButton"]
        let searchBar = app.searchFields.firstMatch
//        let list = app.collectionViews.element
        let image = app.images["no-data"]
        //2
        XCTAssert(navBarTitle.exists)
        XCTAssert(searchBar.exists)
        XCTAssert(navEdit.exists)
        XCTAssert(navAdd.exists)
        XCTAssert(image.exists)
}

    func testIsCreatTask() throws {
        app.launch()
        let navAdd = app.navigationBars.element.buttons["AddButton"]
        navAdd.tap()
        
        let txtFieldName = app.textFields["New task Name"]
        txtFieldName.tap()
        XCTAssert(txtFieldName.waitForExistence(timeout: 5))
        txtFieldName.typeText("Test 1")
        
        let priorityButton = app.staticTexts["High"]
        priorityButton.tap()
        
        let addButton = app.staticTexts["AddButton"]
        XCTAssert(addButton.exists)
    }
}

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
//}

extension XCUIElement {
    func forceTap() {
        if (isHittable) {
            tap()
        } else {
            coordinate(withNormalizedOffset: CGVector(dx:0.0, dy:0.0)).tap()
        }
    }
}
