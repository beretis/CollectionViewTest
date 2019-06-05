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

    @IBOutlet weak var textField: UITextField!
	var disposeBag = DisposeBag()

	public func configure(with state: StaticCellState, initial: Observable<String>) -> Observable<(CellID, String)> {
		textField.placeholder = state.placeholder
		initial
			.take(1)
			.bind(to: textField.rx.text)
			.disposed(by: disposeBag)
		return textField.rx.text.orEmpty
			.map { (state.id, $0) }
	}

    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }

}
