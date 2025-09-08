//
//  OddsAPIServiceTests.swift
//  OddsTaskTests
//
//  Created by Özgü Ataseven on 07.09.2025.
//

import XCTest
import Combine
@testable import OddsTask

final class OddsAPIServiceTests: XCTestCase {
    
    private var oddsAPIService: OddsAPIService!
    private var mockNetworkService: MockNetworkService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        oddsAPIService = OddsAPIService(network: mockNetworkService)
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        oddsAPIService = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func test_initialization_withNetworkService_succeeds() {
        XCTAssertNotNil(oddsAPIService)
    }
    
    // MARK: - Protocol Method Tests
    
    func test_getAllSports_callsNetworkService() {
        let expectation = XCTestExpectation(description: "Get all sports")
        
        let mockSports = [
            Sport(key: "soccer", group: .soccer, title: "Soccer", active: true),
            Sport(key: "basketball", group: .basketball, title: "Basketball", active: true)
        ]
        mockNetworkService.mockResult = .success(mockSports)
        
        oddsAPIService.getAllSports()
            .sink(
                receiveCompletion: { _ in
                    expectation.fulfill()
                },
                receiveValue: { sports in
                    XCTAssertEqual(sports.count, 2)
                    XCTAssertEqual(sports[0].key, "soccer")
                    XCTAssertEqual(sports[1].key, "basketball")
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockNetworkService.requestCalled)
    }
    
    func test_getOddEvents_callsNetworkService() {
        let expectation = XCTestExpectation(description: "Get odd events")
        
        let mockEvents = [
            OddEvent(id: "1", 
                    sportKey: "soccer", 
                    sportTitle: "Soccer", 
                    commenceTime: "2024-01-01T12:00:00Z", 
                    homeTeam: "Team A", 
                    awayTeam: "Team B")
        ]
        mockNetworkService.mockResult = .success(mockEvents)
        
        oddsAPIService.getOddEvents(for: "soccer")
            .sink(
                receiveCompletion: { _ in
                    expectation.fulfill()
                },
                receiveValue: { events in
                    XCTAssertEqual(events.count, 1)
                    XCTAssertEqual(events[0].sportKey, "soccer")
                    XCTAssertEqual(events[0].homeTeam, "Team A")
                    XCTAssertEqual(events[0].awayTeam, "Team B")
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockNetworkService.requestCalled)
    }
    
    func test_getOddEventDetail_callsNetworkService() {
        let expectation = XCTestExpectation(description: "Get odd event detail")
        
        let mockEventDetail = OddEventDetail(
            id: "1",
            sportKey: "soccer",
            sportTitle: "Soccer",
            commenceTime: "2024-01-01T12:00:00Z",
            homeTeam: "Team A",
            awayTeam: "Team B",
            bookmakers: []
        )
        mockNetworkService.mockResult = .success(mockEventDetail)
        
        oddsAPIService.getOddEventDetail(sportKey: "soccer", eventId: "1")
            .sink(
                receiveCompletion: { _ in
                    expectation.fulfill()
                },
                receiveValue: { eventDetail in
                    XCTAssertEqual(eventDetail.id, "1")
                    XCTAssertEqual(eventDetail.sportKey, "soccer")
                    XCTAssertEqual(eventDetail.homeTeam, "Team A")
                    XCTAssertEqual(eventDetail.awayTeam, "Team B")
                    XCTAssertEqual(eventDetail.commenceTime, "2024-01-01T12:00:00Z")
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(mockNetworkService.requestCalled)
    }
    
    // MARK: - Protocol Conformance Tests
    
    func test_conformsToOddsAPIServiceProtocol() {
        let serviceProtocol: OddsAPIServiceProtocol = oddsAPIService
        XCTAssertNotNil(serviceProtocol)
    }
    
    func test_protocolMethods_returnPublishers() {
        let serviceProtocol: OddsAPIServiceProtocol = oddsAPIService
        
        XCTAssertNoThrow(serviceProtocol.getAllSports())
        XCTAssertNoThrow(serviceProtocol.getOddEvents(for: "test"))
        XCTAssertNoThrow(serviceProtocol.getOddEventDetail(sportKey: "test", eventId: "test"))
    }
}
