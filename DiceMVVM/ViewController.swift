//
//  ViewController.swift
//  DiceMVVM
//
//  Created by Drew Milloy on 18/07/2019.
//  Copyright © 2019 Marmadore Studio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var a: UIView!
    @IBOutlet weak var b: UIView!
    @IBOutlet weak var c: UIView!
    @IBOutlet weak var x: UIView!
    @IBOutlet weak var d: UIView!
    @IBOutlet weak var e: UIView!
    @IBOutlet weak var f: UIView!

    @IBOutlet weak var rollButton: UIButton!
    
    private var viewModel: ViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ViewModel(diceRoller: RandomDiceRoller())
        
        rollButton.rx.tap
            .subscribe(onNext: viewModel.rollDice)
            .disposed(by: disposeBag)
        
        viewModel.afIsHidden.drive(a.rx.isHidden).disposed(by: disposeBag)
        viewModel.afIsHidden.drive(f.rx.isHidden).disposed(by: disposeBag)
        viewModel.beIsHidden.drive(b.rx.isHidden).disposed(by: disposeBag)
        viewModel.beIsHidden.drive(e.rx.isHidden).disposed(by: disposeBag)
        viewModel.cdIsHidden.drive(c.rx.isHidden).disposed(by: disposeBag)
        viewModel.cdIsHidden.drive(d.rx.isHidden).disposed(by: disposeBag)
        viewModel.xIsHidden.drive(x.rx.isHidden).disposed(by: disposeBag)
    }

}

