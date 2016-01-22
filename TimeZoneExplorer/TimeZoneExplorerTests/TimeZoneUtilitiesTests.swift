//
//  TimeZoneUtilitiesTests.swift
//  TimeZoneExplorer
//
//  Created by Michael L Mehr on 1/21/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import XCTest
@testable import TimeZoneExplorer

class TimeZoneUtilitiesTests: XCTestCase {
    
    let zoneLA = "America/Los_Angeles"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Uses the given-when-then pattern described here in objc.io Testing issue:
//        //   https://www.objc.io/issues/15-testing/xctest/
//        // given
//        //  include any unique case setup
//        // when
//        //  usually a single method call to test
//        // then
//        //  assertions for testing results
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }

    // MARK: BUG TESTING (FOUND ISSUES)
    // BUG ONE: test formatting of western TZ's (negative offsets) to properly round hours/minutes
    // The bug: America/Los_Angeles reports PST as -07:59 instead of -08:00
    // The fixes: generate a few edge test cases for TZTimeZone::getStandardFormatOffset()
    func testPST() {
        // given
        let input = zoneLA

        // when
        let (abbrev, offset) = TZTimeZone.getTimeInfo(input, type: .Standard)!
        let offstr = TZTimeZone.getStandardFormatOffset(offset)

        // then
        XCTAssertEqual(abbrev, "PST")
        XCTAssertEqual(offset, -8 * 3600)
        XCTAssertEqual(offstr, "-08:00")
    }

    func testPDT() {
        // given
        let input = zoneLA
        
        // when
        let (abbrev, offset) = TZTimeZone.getTimeInfo(input, type: .Daylight)!
        let offstr = TZTimeZone.getStandardFormatOffset(offset)
        
        // then
        XCTAssertEqual(abbrev, "PDT")
        XCTAssertEqual(offset, -7 * 3600)
        XCTAssertEqual(offstr, "-07:00")
    }

    // MARK: TEST BASIC MATH FUNCS OF FORMATTER
    
    func testFormatOffset_Zero() {
        // given
        let input = 0
        
        // when
        let offstr = TZTimeZone.getStandardFormatOffset(input)
        
        // then
        XCTAssertEqual(offstr, "+00:00")
    }
    
    func testFormatOffset_Plus() {
        // given
        let input = 10*3600 + 30*60
        
        // when
        let offstr = TZTimeZone.getStandardFormatOffset(input)
        
        // then
        XCTAssertEqual(offstr, "+10:30")
    }
    
    func testFormatOffset_Minus() {
        // given
        var input = 10 * 3600 + 30 * 60
        input = -input
        
        // when
        let offstr = TZTimeZone.getStandardFormatOffset(input)
        
        // then
        XCTAssertEqual(offstr, "-10:30")
    }
    

    // tests that we can go from a ZoneID to its screen representation and back
    func testStandardFormatInversion() {
        // given
        let input = zoneLA
        
        // when
        let temp = TZTimeZone.getStandardFormat(input)
        let output = TZTimeZone.getZoneID(temp)
        
        // then
        XCTAssertEqual(input, output)
    }

    func testBadZoneID_getClock() {
        // given
        let input = "bad"
        
        // when
        let output = TZTimeZone.getClock(NSDate(), formattedForZone: input)
        
        // then
        // relies on implementation formats, change when implementation changes
        XCTAssertEqual(output.0, "No date")
        XCTAssertEqual(output.1, "..:..:..")
        XCTAssertEqual(output.2, "..")
        XCTAssertEqual(output.3, "...")
    }
    
    func testGoodZoneID_getClock() {
        // given
        let zone = zoneLA
        let dc = NSDateComponents()
        dc.year = 2016
        dc.month = 4
        dc.day = 29
        dc.hour = 12
        dc.minute = 34
        dc.second = 56
        let testDate = NSCalendar(identifier: NSCalendarIdentifierGregorian)!.dateFromComponents(dc)!
        
        // when
        let output = TZTimeZone.getClock(testDate, formattedForZone: zone)
        
        // then
        // relies on implementation formats, change when implementation changes
        XCTAssertEqual(output.0, "Apr 29, 2016")
        XCTAssertEqual(output.1, "12:34:56")
        XCTAssertEqual(output.2, "PM")
        XCTAssertEqual(output.3, "PDT")
    }
    
}
