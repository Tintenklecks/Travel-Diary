////
//
//import IBExtensions
//import XCTest
//
//class UITests: XCTestCase {
//    let fastlane = true // only Xcode
//
//    override func setUpWithError() throws {
//        let app = XCUIApplication()
//
//        continueAfterFailure = false
//        setupSnapshot(app, waitForAnimations: false)
//
//        app.launch()
//        app.activate()
//        addUIInterruptionMonitor(withDescription: "System Dialog") {
//            (alert) -> Bool in
//            var button = alert.buttons["Allow"]
//            if button.exists {
//                button.tap()
//                app.activate()
//                return true
//            }
//
//            button = alert.buttons["Give Access"]
//            if button.exists {
//                button.tap()
//                app.activate()
//                return true
//            }
//
//            button = alert.buttons["Allow While Using The App"]
//            if button.exists {
//                button.tap()
//                app.activate()
//                return true
//            }
//            button = alert.buttons["OK"]
//            if button.exists {
//                button.tap()
//                app.activate()
//                return true
//            }
//
//            return false
//        }
//    }
//
//    /*
//     func testScreenshots() throws {
//            // MARK: - Splash Screen
//
//            snapshot("01-SplashScreen")
//            XCUIApplication().buttons["Start"].firstMatch.tap()
//
//            tapNavigationButton(Accessability.togglePictures.id, image: "03-WithPictures")
//            tapNavigationButton(Accessability.togglePictures.id, image: "02-Startscreen")
//            tapNavigationButton(Accessability.toggleLayout.id, image: "04-CompactLayout")
//            tapButton(Accessability.detailsButton.id, image: "05-Detail", timeout: 10, close: Accessability.closeDialogButton.id)
//            tapButton(Accessability.compassButton.id, image: "06-Compass", timeout: 10, close: Accessability.closeDialogButton.id)
//            tapButton(Accessability.tabBarMap.id, image: "07-Map")
//            tapButton(Accessability.tabBarAroundme.id, image: "08-Aroundme")
//            tapButton(Accessability.tabBarCompass.id, image: "09-Navigation")
//
//            XCTAssert(true)
//        }
//
//        func tapButton(_ id: String, image name: String, fail message: String? = nil, timeout: Double? = nil, close closeButtonId: String? = nil) {
//            let app = XCUIApplication()
//            let button = app.buttons[id].firstMatch
//            tapAndShot(button: button, image: name, fail: message, timeout: timeout, close: closeButtonId)
//        }
//
//        func tapNavigationButton(_ id: String, image name: String, fail message: String? = nil, timeout: Double? = nil, close closeButtonId: String? = nil) {
//            let app = XCUIApplication()
//            let button = app.navigationBars.firstMatch.buttons[id].firstMatch
//            tapAndShot(button: button, image: name, fail: message, timeout: timeout, close: closeButtonId)
//        }
//
//        func tapAndShot(button: XCUIElement, image name: String, fail message: String? = nil, timeout: Double? = 5, close closeButtonId: String? = nil) {
//            let app = XCUIApplication()
//            app.activate()
//            let failMessage = message ?? "Button `\(button)` not found"
//            guard button.exists else {
//                XCTFail(failMessage)
//                return
//            }
//            button.tap()
//
//            if let timeout = timeout {
//                _ = XCTWaiter.wait(for: [XCTestExpectation(description: failMessage)], timeout: timeout)
//            }
//            if fastlane {
//                snapshot(name)
//            }
//
//            if let closeButtonId = closeButtonId {
//                app.buttons[closeButtonId].firstMatch.tap()
//            }
//        }
//
//        func localized(_ key: String) -> String {
//            let uiTestBundle = Bundle(for: UITests.self)
//            return NSLocalizedString(key, bundle: uiTestBundle, comment: "")
//        }
//     }
//     */
//
//    func testScreenshots() throws {
//        // MARK: - Main Screen in dark mode
//
//        let app = XCUIApplication()
//
//        app.activate()
//
//        // MARK: - Splash Screen
//
//      //  let navigationBar = app.navigationBars.firstMatch
//
//        screenshot("01-SplashScreen")
//
//        app.buttons["Start"].firstMatch.tap()
//
//        // MARK: - Switch to Compact Cells
//
//        let compactLayoutButton = app.buttons.containing(XCUIElement.ElementType.button, identifier: Accessability.toggleLayout.id).firstMatch
//        guard compactLayoutButton.exists else {
//            XCTFail("Layout Button Not Found")
//            return
//        }
//        compactLayoutButton.tap() // press(forDuration: 0.5)
//        screenshot("04-CompactLayout")
//
//        // MARK: - Detailed Cell
//
//        let layoutButton = app.buttons.containing(XCUIElement.ElementType.button, identifier: Accessability.toggleLayout.id).firstMatch
//        guard layoutButton.exists else {
//            XCTFail("Layout Button Not Found")
//            return
//        }
//        layoutButton.tap() // press(forDuration: 0.5)
//
//        screenshot("02-Startscreen")
//
//        // MARK: - Detailed Cell with Images
//
//        let pictureButton = app.buttons.containing(XCUIElement.ElementType.button, identifier: Accessability.togglePictures.id).firstMatch
//        guard pictureButton.exists else {
//            XCTFail("Picture Button Not Found")
//            return
//        }
//        pictureButton.tap()
//        screenshot("03-WithPictures")
//
//        // MARK: - Detail Screen -
//
//        let detailsButton = app.buttons.containing(XCUIElement.ElementType.button, identifier: Accessability.detailsButton.id).firstMatch
//        guard detailsButton.exists else {
//            XCTFail("Details Button Not Found")
//            return
//        }
//        detailsButton.tap()
//        screenshot("05-Detail")
//        app.buttons[Accessability.closeDialogButton.id].firstMatch.tap()
//
//        // MARK: - Compass Screen -
//
//        let compassButton = app.buttons[Accessability.compassButton.id].firstMatch
//        guard compassButton.exists else {
//            XCTFail("Compass Button Not Found")
//            return
//        }
//        compassButton.tap()
//        _ = XCTWaiter.wait(for: [XCTestExpectation(description: "Compass!")], timeout: 5.0)
//        screenshot("06-Compass")
//        app.buttons[Accessability.closeDialogButton.id].firstMatch.tap()
//
//        // MARK: - Cluster Map Screen -
//
//        let mapButton = app.buttons[Accessability.tabBarMap.id].firstMatch
//        guard mapButton.exists else {
//            XCTFail("Map Tab Bar Button Not Found")
//            return
//        }
//        mapButton.tap()
//        _ = XCTWaiter.wait(for: [XCTestExpectation(description: "07-Clustered Map!")], timeout: 5.0)
//        screenshot("07-Map")
//
//        // MARK: - Places Around Me Screen -
//
//        let aroundmeButton = app.buttons[Accessability.tabBarAroundme.id].firstMatch
//        guard aroundmeButton.exists else {
//            XCTFail("Around Me Tab Bar Button Not Found")
//            return
//        }
//        aroundmeButton.tap()
//
//        _ = XCTWaiter.wait(for: [XCTestExpectation(description: "08-Around me!")], timeout: 5.0)
//
//        screenshot("08-Aroundme")
//
//        // MARK: - Compass & Routing with search -
//
//        let poiButton = app.buttons[Accessability.tabBarCompass.id].firstMatch
//        guard poiButton.exists else {
//            XCTFail("POI Tab Bar Button Not Found")
//            return
//        }
//        poiButton.tap()
//        _ = XCTWaiter.wait(for: [XCTestExpectation(description: "09-Compass!")], timeout: 5.0)
//        screenshot("09-Navigation")
//
//        
//        app.launchArguments = ["SKIP_ANIMATIONS", "DARKMODE"]
//        setupSnapshot(app, waitForAnimations: false)
//
//
//        app.launch()
//        app.buttons["Start"].firstMatch.tap()
//        screenshot("10-Dark")
//
//        return
//    }
//
//    func screenshot(_ name: String) {
////        XCUIScreen.main.screenshot()
////        snapshot(name, timeWaitingForIdle: 5)
//        print("VIRUAL SCREENSHOT \(name)")
//    }
//}
//
////        app.terminate()
////        var launchArguments: [AnyHashable] = []
////        launchArguments.append("-AppleInterfaceStyle")
////        launchArguments.append("Dark")
////        app.launchArguments = launchArguments as! [String]
////        app.launch()
////        tapButton("Start", image: "10-Dark")
////
