//
//  DiceRoller.swift
//  DiceMVVM
//
//  Created by Drew Milloy on 18/07/2019.
//  Copyright © 2019 Marmadore Studio. All rights reserved.
//

import RxSwift
import RxRelay

protocol DiceRoller {
    func roll() -> Observable<Int>
}

class RandomDiceRoller: DiceRoller {
    private let scheduler: SchedulerType

    init(scheduler: SchedulerType = MainScheduler.asyncInstance) {
        self.scheduler = scheduler
    }
    
    func roll() -> Observable<Int> {
        let randomValue = Int.random(in: (100...200))
        return Observable
            .interval(.milliseconds(10), scheduler: scheduler)
            .takeWhile { $0 < randomValue }
            .map { ($0 % 6) + 1 }
    }
}
