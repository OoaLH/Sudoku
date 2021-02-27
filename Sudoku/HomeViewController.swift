//
//  HomeViewController.swift
//  Sudoku
//
//  Created by 张翌璠 on 2021-02-27.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var instructionButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    func configureViews() {
        startButton.layer.cornerRadius = 20
        instructionButton.layer.cornerRadius = 20
        aboutButton.layer.cornerRadius = 20
    }
    
    @IBAction func showAbout(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://github.com/OoaLH")!, options: [:], completionHandler: nil)
    }
}
