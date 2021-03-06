//
//  NumPadCell.swift
//  Sudoku
//
//  Created by 张翌璠 on 2021-02-09.
//

import UIKit

protocol NumPadCellDelegate: class {
    func fillNum(num: Int)
}

class NumPadCell: UICollectionViewCell {
    weak var delegate: NumPadCellDelegate?
    var displayedNum: Int = 0 {
        didSet {
            button.setTitle(String(displayedNum), for: .normal)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = UIColor(red: 238/255, green: 1, blue: 148/255, alpha: 1)//EEFF94
                button.setTitleColor(UIColor.systemOrange, for: .normal)
            }
            else {
                backgroundColor = UIColor.systemOrange
                button.setTitleColor(UIColor(red: 238/255, green: 1, blue: 148/255, alpha: 1), for: .normal)
            }
        }
    }
    
    func configureViews() {
        layer.cornerRadius = 2
    }
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func selectNumPad(_ sender: UIButton) {
        delegate?.fillNum(num: displayedNum)
    }
}
