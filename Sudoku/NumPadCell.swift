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
    
    func configureViews() {
        layer.cornerRadius = 2
    }
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func selectNumPad(_ sender: UIButton) {
        delegate?.fillNum(num: displayedNum)
    }
}
