//
//  ViewModel.swift
//  DiceMVVM
//
//  Created by Drew Milloy on 18/07/2019.
//  Copyright © 2019 Marmadore Studio. All rights reserved.
//

import RxSwift
import RxCocoa

extension Bool {
    init(_ intValue: Int) {
        self = intValue != 0
    }
}

class ViewModel {
    
    private let diceRoller: DiceRoller
    
    let afIsHidden: Driver<Bool>
    let beIsHidden: Driver<Bool>
    let cdIsHidden: Driver<Bool>
    let xIsHidden: Driver<Bool>
    
    private let diceValue: BehaviorRelay<Int>
    private let disposeBag = DisposeBag()
    
    init(diceRoller: DiceRoller) {
        self.diceRoller = diceRoller
        
        diceValue = BehaviorRelay(value: 0)
        
        xIsHidden = diceValue
            .map { !Bool($0 & 1) }
            .asDriver(onErrorJustReturn: true)

        afIsHidden = diceValue
            .map { !Bool($0 & 6) }
            .asDriver(onErrorJustReturn: true)
        beIsHidden = diceValue
            .map { !(Bool($0 & 2) && Bool($0 & 4)) }
            .asDriver(onErrorJustReturn: true)
        cdIsHidden = diceValue
            .map { !Bool($0 & 4) }
            .asDriver(onErrorJustReturn: true)

    }
    
    func rollDice() {
        diceRoller.roll()
            .subscribe(onNext: { [diceValue] in
                diceValue.accept($0)
            })
            .disposed(by: disposeBag)
    }
}
