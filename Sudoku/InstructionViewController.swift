//
//  InstructionViewController.swift
//  Sudoku
//
//  Created by 张翌璠 on 2021-02-27.
//

import UIKit

class InstructionViewController: UIViewController {
    @IBOutlet weak var instruction: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instruction.text = "This is a classic sudoku game.\n\nTo win the game, you need to fill in every empty block without an error.\n\nSingle tap a block to select it.\nAnd choose a number from 1 - 9 to fill in.\nYou can change the number that you already filled.\n\nOne digit can only exist once in per row, column and 3 × 3 box.\nOtherwise an error occurs.\n\nThere may be more than one solution for each game.\nEnjoy!🤪"
    }
}
