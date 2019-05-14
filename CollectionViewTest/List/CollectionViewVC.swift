//
//  CollectionViewVC.swift
//  CollectionViewTest
//
//  Created by Jozef Matus on 07/05/2019.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CollectionViewVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    //dependency
    let viewModelFactory: (Observable<(CellID, String)>) -> CollectionViewModel
    //private
    private var disposeBag = DisposeBag()

    init(viewModelFactory: @escaping (Observable<(CellID, String)>) -> CollectionViewModel) {
        self.viewModelFactory = viewModelFactory
        super.init(nibName: "CollectionViewVC", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        collectionView.register(UINib(nibName: "SomeCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
		let itemEdit = PublishSubject<(CellID, String)>()
		let viewModel = viewModelFactory(itemEdit)
		let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfCustomData>(
			configureCell: { dataSource, collectionView, indexPath, item in
				guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? SomeCell else { return UICollectionViewCell() }
				let output = cell.configure(with: item, initial: viewModel.cellStates.map { $0[item.id]! })
				output
					.bind(to: itemEdit)
					.disposed(by: cell.disposeBag)
				return cell
		})
        viewModel.cells
			.map { [SectionOfCustomData(items: $0)] }
			.bind(to: collectionView.rx.items(dataSource: dataSource))
			.disposed(by: disposeBag)

		viewModel.cellStates
			.bind(onNext: { print($0) })
			.disposed(by: disposeBag)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 55)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

struct SectionOfCustomData {
    var items: [StaticCellState]
}

extension SectionOfCustomData: SectionModelType {
    typealias Item = StaticCellState

    init(original: SectionOfCustomData, items: [Item]) {
        self = original
        self.items = items
    }
}
