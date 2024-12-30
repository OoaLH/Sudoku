//
//  GamePadCell.swift
//  Sudoku
//
//  Created by 张翌璠 on 2021-02-09.
//

import UIKit

enum GamePadCellStatus {
    case displayedAtBeginning
    case filled
    case wrong
    case empty
}

protocol GamePadCellDelegate: class {
    func selectGamePad(index: Int)
}

class GamePadCell: UICollectionViewCell {
    var index: Int = 0
    weak var delegate: GamePadCellDelegate?
    var status: GamePadCellStatus = .empty {
        didSet {
            switch status {
            case .displayedAtBeginning:
                button.setTitleColor(UIColor.black, for: .normal)
            case .wrong:
                button.setTitleColor(UIColor.red, for: .normal)
            case .empty:
                displayedNum = 0
                button.setTitleColor(UIColor.systemOrange, for: .normal)
                button.setTitle("", for: .normal)
            case .filled:
                button.setTitleColor(UIColor.systemOrange, for: .normal)
            }
        }
    }
    
    var displayedNum: Int = 0 {
        didSet {
            if displayedNum != 0 {
                button.setTitle(String(displayedNum), for: .normal)
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderWidth = 2
                layer.borderColor = UIColor.red.cgColor
            }
            else {
                layer.borderWidth = 0
            }
        }
    }
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func selectGamePad(_ sender: UIButton) {
        delegate?.selectGamePad(index: index)
    }
}
