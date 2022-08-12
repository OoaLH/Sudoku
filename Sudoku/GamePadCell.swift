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

protocol GamePadCellDelegate: AnyObject {
    func selectGamePad(index: Int)
}

class GamePadCell: UICollectionViewCell {
    var index: Int = 0
    var notes: Set<Int> = []
    
    weak var delegate: GamePadCellDelegate?
    
    var status: GamePadCellStatus = .empty {
        didSet {
            switch status {
            case .displayedAtBeginning:
                button.setTitleColor(.black, for: .normal)
            case .wrong:
                button.setTitleColor(.red, for: .normal)
            case .empty:
                displayedNum = 0
                button.setTitleColor(.systemOrange, for: .normal)
                button.setTitle("", for: .normal)
            case .filled:
                button.setTitleColor(.systemOrange, for: .normal)
            }
            
            notes = []
            noteLabel.text = ""
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
            } else {
                layer.borderWidth = 0
            }
        }
    }
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var noteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectionChanged), name: Notification.Name("SelectionChanged"), object: nil)
    }
    
    func addNote(num: Int) {
        if notes.contains(num) {
            notes.remove(num)
        } else {
            notes.insert(num)
        }
        
        noteLabel.text = notes.sorted().map { String($0) }.joined(separator: ", ")
    }
    
    @objc func selectionChanged(notification: NSNotification) {
        if let num = notification.object as? Int {
            if num == displayedNum && num != 0 && !isSelected {
                layer.borderWidth = 2
                layer.borderColor = UIColor.systemYellow.cgColor
            } else if !isSelected {
                layer.borderWidth = 0
            }
        }
    }
    
    @IBAction func selectGamePad(_ sender: UIButton) {
        delegate?.selectGamePad(index: index)
    }
}
