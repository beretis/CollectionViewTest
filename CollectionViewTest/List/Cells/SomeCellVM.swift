//
//  SomeCellVM.swift
//  CollectionViewTest
//
//  Created by Jozef Matus on 07/05/2019.
//

import Foundation
import RxSwift
import RxCocoa

class SomeCellVM {
    //inout
    let textValue: BehaviorRelay<String?>
    //out
    let placeholder: Driver<String>

    init (initialValue: String?, placeholder: String) {
        self.textValue = BehaviorRelay(value: initialValue)
        self.placeholder = Driver.just(placeholder)
    }

}
