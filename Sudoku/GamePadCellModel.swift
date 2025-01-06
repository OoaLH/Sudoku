//
//  GamePadCellModel.swift
//  Sudoku
//
//  Created by Yi Fan Zhang on 2024/12/30.
//

enum GamePadCellStatus {
    
    case displayedAtBeginning
    case filled
    case empty
}

class GamePadCellModel {
    
    var status: GamePadCellStatus = .displayedAtBeginning {
        didSet {
            statusDidChange?()
        }
    }
    
    var number: Int
    
    let row: Int
    let column: Int
    let block: Int
    
    var statusDidChange: (() -> Void)?
    
    init(number: Int, row: Int, column: Int, block: Int) {
        self.number = number
        self.row = row
        self.column = column
        self.block = block
    }
}
