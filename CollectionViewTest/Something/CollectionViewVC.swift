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
    let viewModel: CollectionViewVM
    //private
    private var disposeBag = DisposeBag()

    init(vm: CollectionViewVM) {
        self.viewModel = vm
        super.init(nibName: "CollectionViewVC", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfCustomData>(
        configureCell: { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? SomeCell else { return UICollectionViewCell() }
            cell.configure(withVM: item)
            return cell
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    private func setup() {
        collectionView.register(UINib(nibName: "SomeCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.collectionView.delegate = self
        self.viewModel.sections.bind(to: self.collectionView.rx.items(dataSource: self.dataSource)).disposed(by: self.disposeBag)
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
    var items: [Item]
}

extension SectionOfCustomData: SectionModelType {
    typealias Item = SomeCellVM

    init(original: SectionOfCustomData, items: [Item]) {
        self = original
        self.items = items
    }
}
