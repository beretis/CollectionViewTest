//
//  CollectionViewVM.swift
//  CollectionViewTest
//
//  Created by Jozef Matus on 08/05/2019.
//

import Foundation
import RxSwift
import RxCocoa

class CollectionViewVM {

    // this viewmodel state, which is collected from cell inputs
    let someStateFromCell1: BehaviorRelay<String> = BehaviorRelay(value: "value1")
    let someStateFromCell2: BehaviorRelay<String> = BehaviorRelay(value: "value2")

    var sections: BehaviorRelay<[SectionOfCustomData]> = BehaviorRelay(value: [])

    var sectionDisposeBag = DisposeBag()
    var disposeBag = DisposeBag()

    init() {
        self.setupRx()
        self.bindSections()
    }

    private func createSections(value1: String, value2: String) -> [SectionOfCustomData] {
        self.sectionDisposeBag = DisposeBag()
        //evaluate state based on which sections will be shown
        let someState = (value1 == "A" && value2 == "B")
        //first two items are displayed always
        let vm1 = SomeCellVM(initialValue: self.someStateFromCell1.value, placeholder: "Nothing")
        //bind textValue from cellvm
        vm1.textValue.skip(2)
            .filter { $0 != nil }
            .map { $0 ?? "" }
            .bind(to: self.someStateFromCell1)
            .disposed(by: self.sectionDisposeBag)

        let vm2 = SomeCellVM(initialValue: self.someStateFromCell2.value, placeholder: "Nothing")
        vm2.textValue.skip(2)
            .filter { $0 != nil }
            .map { $0 ?? "" }
            .bind(to: self.someStateFromCell2)
            .disposed(by: self.sectionDisposeBag)

        let firstSection = [vm1, vm2]

        let secondSection = !someState ? [] : [SomeCellVM(initialValue: "", placeholder: "Nothing"),
            SomeCellVM(initialValue: "", placeholder: "Nothing")]
        return [SectionOfCustomData(items: firstSection + secondSection)]
    }

    private func bindSections() {
        self.sections.accept(self.createSections(value1: self.someStateFromCell1.value, value2: self.someStateFromCell2.value))
    }

    private func setupRx() {
        //observe state and if some conditions are met, recreate sections
        Observable.combineLatest(someStateFromCell1.asObservable(), someStateFromCell2.asObservable()) { (val1, val2) -> Bool in
                return val1 == "A" && val2 == "B"
            }
            .filter { $0 }
            .map { [unowned self] _ in
                self.createSections(value1: self.someStateFromCell1.value, value2: self.someStateFromCell2.value)
            }
            .bind(to: self.sections)
            .disposed(by: self.disposeBag)
    }

}
