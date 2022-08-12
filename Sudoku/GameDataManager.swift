//
//  GameDataManager.swift
//  Sudoku
//
//  Created by 张翌璠 on 2021-02-25.
//

import Foundation

class GameDataManager {
    static let shared = GameDataManager()
    
    var numberMapping = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    var numbersToDisplay = Array(repeating: 0, count: 81)
    var emptyNum = 81
    
    private init() {}
    
    func refreshData() {
        numberMapping = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        emptyNum = 81
    }
    
    func generateData() {
        let random = Int(arc4random_uniform(UInt32(GameConstants.numbers.count)))
        numbersToDisplay = GameConstants.numbers[random]
        
        numberMapping.shuffle()
        
        for i in 0..<81 {
            if numbersToDisplay[i] != 0 {
                numbersToDisplay[i] = numberMapping[numbersToDisplay[i] - 1]
                emptyNum -= 1
            }
            else {
                if Int(arc4random_uniform(UInt32(81))) < 5 {
                    numbersToDisplay[i] = numberMapping[GameConstants.solution[i] - 1]
                    emptyNum -= 1
                }
            }
        }
        var row1 = Int(arc4random_uniform(3) + 3)
        var row2 = Int(arc4random_uniform(3) + 3)
        var line1 = Int(arc4random_uniform(3) + 3)
        var line2 = Int(arc4random_uniform(3) + 3)
        converseRow(row1: row1, row2: row2)
        converseLine(line1: line1, line2: line2)
        row1 = Int(arc4random_uniform(3))
        row2 = Int(arc4random_uniform(3))
        line1 = Int(arc4random_uniform(3))
        line2 = Int(arc4random_uniform(3))
        converseRow(row1: row1, row2: row2)
        converseLine(line1: line1, line2: line2)
        row1 = Int(arc4random_uniform(3) + 6)
        row2 = Int(arc4random_uniform(3) + 6)
        line1 = Int(arc4random_uniform(3) + 6)
        line2 = Int(arc4random_uniform(3) + 6)
        converseRow(row1: row1, row2: row2)
        converseLine(line1: line1, line2: line2)
        row1 = Int(arc4random_uniform(3))
        row2 = Int(arc4random_uniform(3))
        line1 = Int(arc4random_uniform(3))
        line2 = Int(arc4random_uniform(3))
        converseBlockInLine(line1: line1, line2: line2)
        converseBlockInRow(row1: row1, row2: row2)
    }
    
    func converseRow(row1: Int, row2: Int) {
        for i in row1 * 9..<row1 * 9 + 9 {
            let j = i + (row2 - row1) * 9
            let k = numbersToDisplay[i]
            numbersToDisplay[i] = numbersToDisplay[j]
            numbersToDisplay[j] = k
        }
    }
    
    func converseLine(line1: Int, line2: Int) {
        for i in 0..<9 {
            let k = numbersToDisplay[i * 9 + line1]
            numbersToDisplay[i * 9 + line1] = numbersToDisplay[i * 9 + line2]
            numbersToDisplay[i * 9 + line2] = k
        }
    }
    
    func converseBlockInLine(line1: Int, line2: Int) {
        converseLine(line1: 3 * line1 + 1, line2: 3 * line2 + 1)
        converseLine(line1: 3 * line1 + 2, line2: 3 * line2 + 2)
        converseLine(line1: 3 * line1, line2: 3 * line2)
    }
    
    func converseBlockInRow(row1: Int, row2: Int) {
        converseRow(row1: 3 * row1 + 1, row2: 3 * row2 + 1)
        converseRow(row1: 3 * row1 + 2, row2: 3 * row2 + 2)
        converseRow(row1: 3 * row1, row2: 3 * row2)
    }
    
    func checkForPlacement(place: Int) -> Bool {
        let i = place / 9
        let j = place % 9
        
        for x in 0..<81 {
            if (x / 9 == i || x % 9 == j) && (x != place) {
                if numbersToDisplay[place] == numbersToDisplay[x] {
                    return false
                }
            }
        }
        
        if (i == 0 || i == 3 || i == 6 ) && (j == 0 || j == 3 || j == 6) {
            if numbersToDisplay[place] == numbersToDisplay[place + 10] || numbersToDisplay[place] == numbersToDisplay[place + 11] || numbersToDisplay[place] == numbersToDisplay[place + 19] || numbersToDisplay[place] == numbersToDisplay[place + 20] {
                return false
            }
        } else if (i == 0 || i == 3 || i == 6) && (j == 1 || j == 4 || j == 7) {
            if numbersToDisplay[place] == numbersToDisplay[place + 10] || numbersToDisplay[place] == numbersToDisplay[place + 17] || numbersToDisplay[place] == numbersToDisplay[place + 8] || numbersToDisplay[place] == numbersToDisplay[place + 19] {
                return false
            }
        } else if (i == 0 || i == 3 || i == 6) && (j == 2 || j == 5 || j == 8) {
            if numbersToDisplay[place] == numbersToDisplay[place + 8] || numbersToDisplay[place] == numbersToDisplay[place + 17] || numbersToDisplay[place] == numbersToDisplay[place + 7] || numbersToDisplay[place] == numbersToDisplay[place + 16] {
                return false
            }
        } else if (i == 1 || i == 4 || i == 7) && (j == 0 || j == 3 || j == 6) {
            if numbersToDisplay[place] == numbersToDisplay[place - 8] || numbersToDisplay[place] == numbersToDisplay[place - 7] || numbersToDisplay[place] == numbersToDisplay[place + 10] || numbersToDisplay[place] == numbersToDisplay[place + 11] {
                return false
            }
        } else if (i == 1 || i == 4 || i == 7) && (j == 1 || j == 4 || j == 7) {
            if numbersToDisplay[place] == numbersToDisplay[place + 10] || numbersToDisplay[place] == numbersToDisplay[place + 8] || numbersToDisplay[place] == numbersToDisplay[place - 8] || numbersToDisplay[place] == numbersToDisplay[place - 10] {
                return false
            }
        } else if (i == 1 || i == 4 || i == 7) && (j == 2 || j == 5 || j == 8) {
            if numbersToDisplay[place] == numbersToDisplay[place + 7] || numbersToDisplay[place] == numbersToDisplay[place + 8] || numbersToDisplay[place] == numbersToDisplay[place - 11] || numbersToDisplay[place] == numbersToDisplay[place - 10] {
                return false
            }
        } else if (i == 2 || i == 5 || i == 8) && (j == 2 || j == 5 || j == 8) {
            if numbersToDisplay[place] == numbersToDisplay[place - 20] || numbersToDisplay[place] == numbersToDisplay[place - 19] || numbersToDisplay[place] == numbersToDisplay[place - 11] || numbersToDisplay[place] == numbersToDisplay[place - 10] {
                return false
            }
        } else if (i == 2 || i == 5 || i == 8) && (j == 1 || j == 4 || j == 7) {
            if numbersToDisplay[place] == numbersToDisplay[place - 17] || numbersToDisplay[place] == numbersToDisplay[place - 19] || numbersToDisplay[place] == numbersToDisplay[place - 8] || numbersToDisplay[place] == numbersToDisplay[place - 10] {
                return false
            }
        } else if (i == 2 || i == 5 || i == 8) && (j == 0 || j == 3 || j == 6) {
            if numbersToDisplay[place] == numbersToDisplay[place - 7] || numbersToDisplay[place] == numbersToDisplay[place - 17] || numbersToDisplay[place] == numbersToDisplay[place - 8] || numbersToDisplay[place] == numbersToDisplay[place - 16] {
                return false
            }
        }
        return true
    }
}
