//
//  ViewModelTests.swift
//  DiceMVVMTests
//
//  Created by Drew Milloy on 18/07/2019.
//  Copyright © 2019 Marmadore Studio. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import DiceMVVM

class MockDiceRoller: DiceRoller {
    
    var nextValue: Int = 0
    var rollCallback: (() -> Void)?
    
    func roll() -> Observable<Int> {
        rollCallback?()
        return Observable.just(nextValue)
    }
}

class ViewModelTests: XCTestCase {

    private let testScheduler = TestScheduler(initialClock: 0)
    private var mockDiceRoller = MockDiceRoller()
    private var viewModel: ViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func setUp() {
        viewModel = ViewModel(diceRoller: mockDiceRoller)
    }

    func testRollCallsRoller() {
        let rollerCalled = expectation(description: "DiceRoller.roll() called")
        mockDiceRoller.rollCallback = {
            rollerCalled.fulfill()
        }
        
        viewModel.rollDice()
        waitForExpectations(timeout: 0.1)
    }
    
    func testDisplayElementX() {
        let xObserver = testScheduler.createObserver(Bool.self)

        viewModel.xIsHidden.drive(xObserver).disposed(by: disposeBag)
        
        schedule1To6Events()

        let expectedX: [Recorded<Event<Bool>>] = [
            .next(0, true),
            .next(1, false),
            .next(2, true),
            .next(3, false),
            .next(4, true),
            .next(5, false),
            .next(6, true),
        ]

        XCTAssertEqual(xObserver.events, expectedX)
    }
    
    func testDisplayElementAF() {
        let afObserver = testScheduler.createObserver(Bool.self)
        
        viewModel.afIsHidden.drive(afObserver).disposed(by: disposeBag)
        
        schedule1To6Events()
        
        let expectedAF: [Recorded<Event<Bool>>] = [
            .next(0, true),
            .next(1, true),
            .next(2, false),
            .next(3, false),
            .next(4, false),
            .next(5, false),
            .next(6, false),
        ]
        
        XCTAssertEqual(afObserver.events, expectedAF)
    }
    
    func testDisplayElementBE() {
        let beObserver = testScheduler.createObserver(Bool.self)
        
        viewModel.beIsHidden.drive(beObserver).disposed(by: disposeBag)
        
        schedule1To6Events()
        
        let expectedBE: [Recorded<Event<Bool>>] = [
            .next(0, true),
            .next(1, true),
            .next(2, true),
            .next(3, true),
            .next(4, true),
            .next(5, true),
            .next(6, false),
        ]
        
        XCTAssertEqual(beObserver.events, expectedBE)
    }
    
    func testDisplayElementCD() {
        let cdObserver = testScheduler.createObserver(Bool.self)
        
        viewModel.cdIsHidden.drive(cdObserver).disposed(by: disposeBag)
        
        schedule1To6Events()
        
        let expectedCD: [Recorded<Event<Bool>>] = [
            .next(0, true),
            .next(1, true),
            .next(2, true),
            .next(3, true),
            .next(4, false),
            .next(5, false),
            .next(6, false),
        ]
        
        XCTAssertEqual(cdObserver.events, expectedCD)
    }
    
    private func schedule1To6Events() {
        SharingScheduler.mock(scheduler: testScheduler) {
            (1...6).forEach { value in
                testScheduler.scheduleAt(value) { [unowned self] in
                    self.mockDiceRoller.nextValue = value
                    self.viewModel.rollDice()
                }
            }
            testScheduler.start()
        }
    }

}
