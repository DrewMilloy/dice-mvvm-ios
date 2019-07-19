//
//  RandomDiceRollerTests.swift
//  DiceMVVMTests
//
//  Created by Drew Milloy on 19/07/2019.
//  Copyright © 2019 Marmadore Studio. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import DiceMVVM

class RandomDiceRollerTests: XCTestCase {
    private let testScheduler = TestScheduler(initialClock: 0)
    private var diceRoller: DiceRoller!
    
    private let disposeBag = DisposeBag()
    
    override func setUp() {
        diceRoller = RandomDiceRoller(scheduler: testScheduler)
    }

    func testRollObservableCompletes() {
        let valueObserver = testScheduler.createObserver(Int.self)
        
        let valueObservable = diceRoller.roll()
        
        valueObservable.bind(to: valueObserver).disposed(by: disposeBag)
        
        SharingScheduler.mock(scheduler: testScheduler) {
            testScheduler.start()
        }
        
        XCTAssertEqual(valueObserver.events.last?.value, .completed)
    }
    
    func testRollValuesBetween1And6() {
        (1...20).forEach { _ in
            
            guard let rollValue = finalElementAfterRoll() else {
                XCTFail("Roll produced nil value")
                return
            }
            XCTAssertTrue((1...6).contains(rollValue))
        }
    }
    
    func testRollProducesDifferentValue() {
        let roll20Times = (1...20).compactMap { _ in
            return finalElementAfterRoll()
        }
        
        XCTAssertEqual(roll20Times.count, 20)
        
        let setOfValues = Set(roll20Times)
        
        XCTAssertTrue(setOfValues.count > 1)
    }
    
    private func finalElementAfterRoll() -> Int? {
        let valueObserver = testScheduler.createObserver(Int.self)
        
        let valueObservable = diceRoller.roll()
        
        valueObservable.bind(to: valueObserver).disposed(by: disposeBag)
        
        SharingScheduler.mock(scheduler: testScheduler) {
            testScheduler.start()
        }
        
        let eventCount = valueObserver.events.count
        let penultimateEvent = valueObserver.events[eventCount - 2].value
        switch penultimateEvent {
        case .next(let value):
            return value
        default:
            return nil
        }
    }
    
}
