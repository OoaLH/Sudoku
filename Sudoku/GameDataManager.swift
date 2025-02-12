//
//  GameDataManager.swift
//  Sudoku
//
//  Created by 张翌璠 on 2021-02-25.
//

import Foundation

class GameDataManager {
    
    static let shared = GameDataManager()
    
    private var solution: [[Int]] = []
    private var sudoku: [[GamePadCellModel]] = []
    private var flattenedSudoku: [GamePadCellModel] = []
    
    var gameData: [GamePadCellModel] = []
    
    private init() {}
    
    func generateData(completionHandler: @escaping (() -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            solution = GameConstants.solution
            sudoku = []
            flattenedSudoku = []
            gameData = []
            
            generateRandomMapping()
            swap()
            
            for row in 0..<9 {
                var tempRow: [GamePadCellModel] = []
                for col in 0..<9 {
                    let block = (row / 3) * 3 + col / 3
                    let model = GamePadCellModel(number: solution[row][col], row: row, column: col, block: block)
                    tempRow.append(model)
                    flattenedSudoku.append(model)
                }
                sudoku.append(tempRow)
            }
            
            removeSingleNumbers()
            removeRandomNumbers()
            
            DispatchQueue.main.async { [unowned self] in
                gameData = flattenedSudoku
                completionHandler()
            }
        }
    }
    
    func checkPlacement(index: Int) -> Bool {
        let model = flattenedSudoku[index]
        
        for otherModel in sudoku[model.row] {
            if model.column != otherModel.column,
               model.number == otherModel.number {
                return false
            }
        }
        
        let columnModels = sudoku.map {
            $0[model.column]
        }
        for otherModel in columnModels {
            if model.row != otherModel.row,
               model.number == otherModel.number {
                return false
            }
        }
        
        let blockModels = flattenedSudoku.filter {
            $0.block == model.block
        }
        for otherModel in blockModels {
            if model.row != otherModel.row || model.column != otherModel.column,
               model.number == otherModel.number {
                return false
            }
        }
        
        return true
    }
    
    private func removeSingleNumbers() {
        let models = flattenedSudoku.shuffled()
        for model in models {
            let rowNumbers = sudoku[model.row].map {
                $0.number
            }
            let columnNumbers = sudoku.map {
                $0[model.column]
            }.map {
                $0.number
            }
            let blockNumbers = models.filter {
                $0.block == model.block
            }.map {
                $0.number
            }
            let existings = Set(
                (rowNumbers + columnNumbers + blockNumbers).filter {
                    $0 != 0 && $0 != model.number
                }
            )
            if existings.count == 8 {
                model.number = 0
                model.status = .empty
            }
        }
    }
    
    private func removeRandomNumbers() {
        let models = flattenedSudoku
            .shuffled()
            .filter {
            $0.number != 0
        }
        var removed = 0
        for model in models {
            let original = model.number
            var possibilities = [1, 2, 3, 4, 5, 6, 7, 8, 9]
            possibilities.remove(at: original - 1)
            var canRemove = true
            for number in possibilities {
                model.number = number
                if solve() {
                    model.number = original
                    canRemove = false
                    break
                }
            }
            if canRemove {
                model.number = 0
                model.status = .empty
                removed += 1
                if removed == 6 {
                    break
                }
            }
        }
    }
    
    private func solve() -> Bool {
        let copied = flattenedSudoku.map { $0.copy() }
        let vacants = copied.filter { $0.number == 0 }
        var index = 0
        while index > -1,
              index < vacants.count {
            let current = vacants[index]
            var canFill = false
            if current.number < 9 {
                let range = (current.number + 1)...9
                for number in range {
                    let rowNumbers = copied.filter {
                        $0.row == current.row
                    }.map {
                        $0.number
                    }
                    let columnNumbers = copied.filter {
                        $0.column == current.column
                    }.map {
                        $0.number
                    }
                    let blockNumbers = copied.filter {
                        $0.block == current.block
                    }.map {
                        $0.number
                    }
                    let existings = Set(
                        (rowNumbers + columnNumbers + blockNumbers).filter {
                            $0 != 0
                        }
                    )
                    if !existings.contains(number) {
                        current.number = number
                        canFill = true
                        break
                    }
                }
            }
            if !canFill {
                current.number = 0
                index -= 1
            } else {
                index += 1
            }
        }
        if vacants.count == 0 {
            return false
        }
        return index == vacants.count
    }
    
    private func checkValid() {
        
    }
    
    private func generateRandomMapping() {
        let mapping = [1, 2, 3, 4, 5, 6, 7, 8, 9].shuffled()
        for row in 0..<9 {
            for col in 0..<9 {
                let original = solution[row][col]
                solution[row][col] = mapping[original - 1]
            }
        }
    }
    
    private func swap() {
        for offset in [0, 3, 6] {
            let row1 = Int(arc4random_uniform(3) + UInt32(offset))
            let row2 = Int(arc4random_uniform(3) + UInt32(offset))
            let col1 = Int(arc4random_uniform(3) + UInt32(offset))
            let col2 = Int(arc4random_uniform(3) + UInt32(offset))
            swapRow(row1: row1, row2: row2)
            swapColumn(col1: col1, col2: col2)
        }
        
        let row1 = Int(arc4random_uniform(3))
        let row2 = Int(arc4random_uniform(3))
        let col1 = Int(arc4random_uniform(3))
        let col2 = Int(arc4random_uniform(3))
        swapBlockInColumn(col1: col1, col2: col2)
        swapBlockInRow(row1: row1, row2: row2)
    }
    
    private func swapRow(row1: Int, row2: Int) {
        for col in 0..<9 {
            let temp = solution[row1][col]
            solution[row1][col] = solution[row2][col]
            solution[row2][col] = temp
        }
    }
    
    private func swapColumn(col1: Int, col2: Int) {
        for row in 0..<9 {
            let temp = solution[row][col1]
            solution[row][col1] = solution[row][col2]
            solution[row][col2] = temp
        }
    }
    
    private func swapBlockInColumn(col1: Int, col2: Int) {
        swapColumn(col1: 3 * col1 + 1, col2: 3 * col2 + 1)
        swapColumn(col1: 3 * col1 + 2, col2: 3 * col2 + 2)
        swapColumn(col1: 3 * col1, col2: 3 * col2)
    }
    
    private func swapBlockInRow(row1: Int, row2: Int) {
        swapRow(row1: 3 * row1 + 1, row2: 3 * row2 + 1)
        swapRow(row1: 3 * row1 + 2, row2: 3 * row2 + 2)
        swapRow(row1: 3 * row1, row2: 3 * row2)
    }
}
