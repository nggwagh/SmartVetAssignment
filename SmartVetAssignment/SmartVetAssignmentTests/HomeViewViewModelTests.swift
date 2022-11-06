//
//  HomeViewViewModelSpec.swift
//  SmartVetAssignmentTests
//
//  Created by NWagh on 06/11/22.
//

import XCTest
@testable import SmartVetAssignment

final class HomeViewViewModelTests: XCTestCase {

    var viewModel: HomeViewViewModel!
    var mockHomeService: MockHomeService!
    var mockHTTPUtility: MockHTTPUtility!
    
    override func setUpWithError() throws {
        mockHTTPUtility = MockHTTPUtility()
        mockHomeService = MockHomeService(httpUtility: mockHTTPUtility)
        viewModel = .init(service: mockHomeService)
    }
    
    func testGetConfigDetails_Success() {
        mockHomeService.configResultSuccess = true
        let expectation = XCTestExpectation(description: "Get Config Service Success call")
        mockHomeService.getConfigurationDetails { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result!)
            XCTAssertEqual(result!.settings.isCallEnabled, true)
            XCTAssertEqual(result!.settings.isChatEnabled, true)
            XCTAssertEqual(result!.settings.workHours, "M-F 9:00 - 18:00")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetConfigDetails_Failed() {
        mockHomeService.configResultSuccess = false
        let expectation = XCTestExpectation(description: "Get Config Service Failure call")
        mockHomeService.getConfigurationDetails { (result, error) in
            XCTAssertNil(result)
            XCTAssertNotNil(error!)
            XCTAssertEqual(error!.reason, "Failed to load")
            XCTAssertEqual(error!.httpStatusCode, 500)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetPetsInfoDetails_Success() {
        mockHomeService.petsInfoSuccess = true
        let expectation = XCTestExpectation(description: "Get Pets List Service Success call")
        mockHomeService.getPetsInfoList { (result, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(result!)
            XCTAssertEqual(result!.pets.count, 10)
            let firstPetInfo = result!.pets[0]
            XCTAssertEqual(firstPetInfo.title, "Cat")
            XCTAssertEqual(firstPetInfo.contentURL, "https://en.wikipedia.org/wiki/Cat")
            XCTAssertEqual(firstPetInfo.dateAdded, "2018-06-02T03:27:38.027Z")
            XCTAssertEqual(firstPetInfo.imageURL, "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Cat_poster_1.jpg/1200px-Cat_poster_1.jpg")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetPetsInfoDetails_Failed() {
        mockHomeService.petsInfoSuccess = false
        let expectation = XCTestExpectation(description: "Get Pets List Service Failure call")
        mockHomeService.getPetsInfoList { (result, error) in
            XCTAssertNil(result)
            XCTAssertNotNil(error!)
            XCTAssertEqual(error!.reason, "Failed to load")
            XCTAssertEqual(error!.httpStatusCode, 500)
            expectation.fulfill()
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func getDateFromString(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: date)!
    }
    
    func testValidateWhenChatDisable_CallEnable_ValidWorkHours() {
        viewModel.configSetting = mockHomeService.getSettingMockData_When_ChatDisable_CallEnable_ValidWorkHours()
        XCTAssertTrue(viewModel.configSetting!.isCallEnabled)
        XCTAssertFalse(viewModel.configSetting!.isChatEnabled)
        XCTAssertEqual(viewModel.configSetting!.workHours, "M-F 9:00 - 18:00")
    }
    
    func testValidateCurrentTime_WithInWorkHour_With_Invalid_WorkHours() {
        viewModel.configSetting = mockHomeService.getSettingMockData_When_ChatEnable_CallEnable_InvalidWorkHours()
        let withInWorkHourString = "2022-11-04T15:28:00"
        XCTAssertFalse(viewModel.checkIfWithinWorkHours(now: getDateFromString(date: withInWorkHourString)))
    }
    
    func testValidateCurrentTime_WithInWorkHour_With_nil_WorkHours() {
        viewModel.configSetting = mockHomeService.getSettingMockData_When_ChatEnable_CallEnable_NilWorkHours()
        let afterWorkHourString = "2022-11-04T20:28:00"
        XCTAssertFalse(viewModel.checkIfWithinWorkHours(now: getDateFromString(date: afterWorkHourString)))
    }
    
    func testValidateCurrentTime_WithInWorkHour() {
        viewModel.configSetting = mockHomeService.getSettingMockData_When_ChatEnable_CallEnable_ValidWorkHours()
        let withInWorkHourString = "2022-11-04T15:28:00"
        XCTAssertTrue(viewModel.checkIfWithinWorkHours(now: getDateFromString(date: withInWorkHourString)))
    }
    
    func testValidateCurrentTime_BeforeWorkHour() {
        viewModel.configSetting = mockHomeService.getSettingMockData_When_ChatEnable_CallEnable_ValidWorkHours()
        let beforeWorkHourString = "2022-11-04T08:28:00"
        XCTAssertFalse(viewModel.checkIfWithinWorkHours(now: getDateFromString(date: beforeWorkHourString)))
    }
    
    func testValidateCurrentTime_AfterWorkHour() {
        viewModel.configSetting = mockHomeService.getSettingMockData_When_ChatEnable_CallEnable_ValidWorkHours()
        let afterWorkHourString = "2022-11-04T20:28:00"
        XCTAssertFalse(viewModel.checkIfWithinWorkHours(now: getDateFromString(date: afterWorkHourString)))
    }
    
    func testValidateCurrentTime_WithWorkHour_OnWeekends() {
        viewModel.configSetting = mockHomeService.getSettingMockData_When_ChatEnable_CallEnable_ValidWorkHours()
        let withInWorkHourButOnWeekendString = "2022-11-06T15:28:00"
        XCTAssertFalse(viewModel.checkIfWithinWorkHours(now: getDateFromString(date: withInWorkHourButOnWeekendString)))
    }
    
    func testWhenChatDisable_ChatDisable_ValidValidWorkHours() {
        viewModel.configSetting = mockHomeService.getSettingMockData_When_ChatDisable_CallDisable_ValidWorkHours()
        XCTAssertFalse(viewModel.showCallChatOptions)
    }
    
}
