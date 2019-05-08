//
//  SomeCell.swift
//  CollectionViewTest
//
//  Created by Jozef Matus on 07/05/2019.
//

import UIKit
import RxSwift
import RxCocoa

class SomeCell: UICollectionViewCell {

    private var disposeBag = DisposeBag()
    @IBOutlet weak var textField: UITextField!

    public func configure(withVM: SomeCellVM) {
        withVM.placeholder
            .drive(onNext: { [weak self] placeholder in
                self?.textField.placeholder = placeholder
            })
            .disposed(by: self.disposeBag)
        //this is here to preserve value on scroll
        withVM.textValue
            .take(1)
            .bind(to: self.textField.rx.text)
            .disposed(by: self.disposeBag)

        self.textField.rx.text.bind(to: withVM.textValue)
            .disposed(by: self.disposeBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }

}
