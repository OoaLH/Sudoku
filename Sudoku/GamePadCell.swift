//
//  GamePadCell.swift
//  Sudoku
//
//  Created by 张翌璠 on 2021-02-09.
//

import UIKit

protocol GamePadCellDelegate: AnyObject {
    
    func didSelectGamePad(index: Int)
}

class GamePadCell: UICollectionViewCell {
    
    var model: GamePadCellModel? {
        didSet {
            guard let model else {
                return
            }
            
            modelDidChange()
            
            model.statusDidChange = { [weak self] in
                self?.modelDidChange()
            }
        }
    }
    
    var index: Int = 0
    
    weak var delegate: GamePadCellDelegate?
    
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
        delegate?.didSelectGamePad(index: index)
    }
    
    private func modelDidChange() {
        guard let model else {
            return
        }
        switch model.status {
        case .displayedAtBeginning:
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitle(String(model.number), for: .normal)
        case .empty:
            button.setTitleColor(UIColor.systemOrange, for: .normal)
            button.setTitle("", for: .normal)
        case .filled:
            button.setTitleColor(UIColor.systemOrange, for: .normal)
            button.setTitle(String(model.number), for: .normal)
        }
    }
}
