//
//  GameDataManager.swift
//  Sudoku
//
//  Created by 张翌璠 on 2021-02-25.
//

import Foundation

class GameDataManager {
    static let shared = GameDataManager()
    var number = [6,3,7,1,5,8,4,2,9,4,2,5,6,7,9,1,3,8,8,9,1,2,3,4,6,5,7,2      ,6,4,9,8,5,3,7,1,5,7,8,3,6,1,9,4,2,3,1,9,4,2,7,5,8,6,7,4,6,8,1,3,2,9,5,9,5,2,7,4,6,8,1,3,1,8,3,5,9,2,7,6,4]
    var collection = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    var mapToCollection = Array(repeating: 0, count: 9)
    var shouldDisplay = Array(repeating: 0, count: 81)
    var emptyNum = 81
    
    private init() {}
    
    func refreshData() {
        number = [6,3,7,1,5,8,4,2,9,4,2,5,6,7,9,1,3,8,8,9,1,2,3,4,6,5,7,2      ,6,4,9,8,5,3,7,1,5,7,8,3,6,1,9,4,2,3,1,9,4,2,7,5,8,6,7,4,6,8,1,3,2,9,5,9,5,2,7,4,6,8,1,3,1,8,3,5,9,2,7,6,4]
        collection = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        mapToCollection = Array(repeating: 0, count: 9)
        shouldDisplay = Array(repeating: 0, count: 81)
        emptyNum = 81
    }
    
    func generateData() {
        for i in 0..<9 {
            let num = Int(arc4random_uniform(UInt32(9 - i)))
            mapToCollection[i] = collection[num]
            collection.remove(at: num)
        }
        
        for i in 0..<81 {
            number[i] = mapToCollection[number[i] - 1]
        }
        var row1 = Int(arc4random_uniform(2) + 4)
        var row2 = Int(arc4random_uniform(2) + 4)
        var line1 = Int(arc4random_uniform(2) + 4)
        var line2 = Int(arc4random_uniform(2) + 4)
        converseRow(row1: row1, row2: row2)
        converseLine(line1: line1, line2: line2)
        row1 = Int(arc4random_uniform(2) + 1)
        row2 = Int(arc4random_uniform(2) + 1)
        line1 = Int(arc4random_uniform(2) + 1)
        line2 = Int(arc4random_uniform(2) + 1)
        converseRow(row1: row1, row2: row2)
        converseLine(line1: line1, line2: line2)
        row1 = Int(arc4random_uniform(2) + 7)
        row2 = Int(arc4random_uniform(2) + 7)
        line1 = Int(arc4random_uniform(2) + 7)
        line2 = Int(arc4random_uniform(2) + 7)
        converseRow(row1: row1, row2: row2)
        converseLine(line1: line1, line2: line2)
        
        for i in 0..<81 {
            let k = Int(arc4random_uniform(2))
            if k == 0 {
                shouldDisplay[i] = number[i]
                emptyNum -= 1
            }
        }
    }
    
    func converseRow(row1: Int, row2: Int) {
        for i in (row1 - 1) * 9..<(row1 - 1) * 9 + 9 {
            let j = i + (row2 - row1) * 9
            let k = number[i]
            number[i] = number[j]
            number[j] = k
        }
    }
    
    func converseLine(line1: Int, line2: Int) {
        for i in 0..<9 {
            let k = number[i * 9 + line1]
            number[i * 9 + line1] = number[i * 9 + line2]
            number[i * 9 + line2] = k
        }
    }
    
    func checkAll(place: Int) -> Bool {
        let i = place / 9
        let j = place % 9
        
        for x in 0..<81 {
            if (x / 9 == i || x % 9 == j) && (x != place) {
                if shouldDisplay[place] == shouldDisplay[x] {
                    return false
                }
            }
        }
        
        if (i == 0 || i == 3 || i == 6 ) && (j == 0 || j == 3 || j == 6) {
            if shouldDisplay[place] == shouldDisplay[place + 10] || shouldDisplay[place] == shouldDisplay[place + 11] || shouldDisplay[place] == shouldDisplay[place + 19] || shouldDisplay[place] == shouldDisplay[place + 20] {
                return false
            }
        }
        else if (i == 0 || i == 3 || i == 6) && (j == 1 || j == 4 || j == 7) {
            if shouldDisplay[place] == shouldDisplay[place + 10] || shouldDisplay[place] == shouldDisplay[place + 17] || shouldDisplay[place] == shouldDisplay[place + 8] || shouldDisplay[place] == shouldDisplay[place + 19] {
                return false
            }
        }
        else if (i == 0 || i == 3 || i == 6) && (j == 2 || j == 5 || j == 8) {
            if shouldDisplay[place] == shouldDisplay[place + 8] || shouldDisplay[place] == shouldDisplay[place + 17] || shouldDisplay[place] == shouldDisplay[place + 7] || shouldDisplay[place] == shouldDisplay[place + 16] {
                return false
            }
        }
        else if (i == 1 || i == 4 || i == 7) && (j == 0 || j == 3 || j == 6) {
            if shouldDisplay[place] == shouldDisplay[place - 8] || shouldDisplay[place] == shouldDisplay[place - 7] || shouldDisplay[place] == shouldDisplay[place + 10] || shouldDisplay[place] == shouldDisplay[place + 11] {
                return false
            }
        }
        else if (i == 1 || i == 4 || i == 7) && (j == 1 || j == 4 || j == 7) {
            if shouldDisplay[place] == shouldDisplay[place + 10] || shouldDisplay[place] == shouldDisplay[place + 8] || shouldDisplay[place] == shouldDisplay[place - 8] || shouldDisplay[place] == shouldDisplay[place - 10] {
                return false
            }
        }
        else if (i == 1 || i == 4 || i == 7) && (j == 2 || j == 5 || j == 8) {
            if shouldDisplay[place] == shouldDisplay[place + 7] || shouldDisplay[place] == shouldDisplay[place + 8] || shouldDisplay[place] == shouldDisplay[place - 11] || shouldDisplay[place] == shouldDisplay[place - 10] {
                return false
            }
        }
        else if (i == 2 || i == 5 || i == 8) && (j == 2 || j == 5 || j == 8) {
            if shouldDisplay[place] == shouldDisplay[place - 20] || shouldDisplay[place] == shouldDisplay[place - 19] || shouldDisplay[place] == shouldDisplay[place - 11] || shouldDisplay[place] == shouldDisplay[place - 10] {
                return false
            }
        }
        else if (i == 2 || i == 5 || i == 8) && (j == 1 || j == 4 || j == 7) {
            if shouldDisplay[place] == shouldDisplay[place - 17] || shouldDisplay[place] == shouldDisplay[place - 19] || shouldDisplay[place] == shouldDisplay[place - 8] || shouldDisplay[place] == shouldDisplay[place - 10] {
                return false
            }
        }
        else if (i == 2 || i == 5 || i == 8) && (j == 0 || j == 3 || j == 6) {
            if shouldDisplay[place] == shouldDisplay[place - 7] || shouldDisplay[place] == shouldDisplay[place - 17] || shouldDisplay[place] == shouldDisplay[place - 8] || shouldDisplay[place] == shouldDisplay[place - 16] {
                return false
            }
        }
        return true
    }
}
