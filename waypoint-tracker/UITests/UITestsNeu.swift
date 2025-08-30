//
//  UITestsNeu.swift
//  UITests
//
//  Created by Ingo Böhme on 14.08.20.
//  Copyright © 2020 Ingo Böhme Mobil. All rights reserved.
//

import XCTest

class UITestsNeu: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false



        let app = XCUIApplication()

        app.launchArguments = ["UITest"]
        app.launch()
        addUIInterruptionMonitor(withDescription: "") {
            (alert) -> Bool in
            var button = alert.buttons["Allow"]
            if button.exists {
                button.tap()
                app.activate()
                return true
            }

            button = alert.buttons["Give Access"]
            if button.exists {
                button.tap()
                app.activate()
                return true
            }

            button = alert.buttons["Change to Always Allow"]
            if button.exists {
                button.tap()
                app.activate()
                return true
            }

            button = alert.buttons["Allow While Using The App"]
            if button.exists {
                button.tap()
                app.activate()
                return true
            }
            button = alert.buttons["OK"]
            if button.exists {
                button.tap()
                app.activate()
                return true
            }

            return false
        }
        app.activate()


    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCUIApplication().staticTexts["Always display this intro screen on app start"].twoFingerTap()
                                                                                                        
    }

}
