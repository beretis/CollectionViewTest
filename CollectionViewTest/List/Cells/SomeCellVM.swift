//
//  SomeCellVM.swift
//  CollectionViewTest
//
//  Created by Jozef Matus on 07/05/2019.
//

import Foundation
import RxSwift
import RxCocoa

typealias CellID = UUID

struct StaticCellState {
	let id: CellID
	let placeholder: String
}
