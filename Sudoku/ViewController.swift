//
//  ViewController.swift
//  Sudoku
//
//  Created by 张翌璠 on 2021-02-09.
//

import UIKit

class ViewController: UIViewController {
    var selectedGamePadIndex: Int?
    @IBOutlet weak var gamePad: UICollectionView!
    @IBOutlet weak var numPad: UICollectionView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        start()
    }
    
    func configureViews() {
        startButton.layer.cornerRadius = 20
    }
    
    func start() {
        GameDataManager.shared.refreshData()
        GameDataManager.shared.generateData()
        gamePad.reloadData()
        textLabel.text = "Start!"
        textLabel.textColor = UIColor.systemOrange
    }
    
    func win() {
        textLabel.text = "You win!"
        textLabel.textColor = UIColor.red
    }
    
    @IBAction func newRound(_ sender: UIButton) {
        start()
    }
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == gamePad {
            return 81
        }
        else {
            return 9
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == gamePad {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Game", for: indexPath) as! GamePadCell
            if GameDataManager.shared.shouldDisplay[indexPath.row] != 0 {
                cell.status = .displayedAtBeginning
                cell.displayedNum = GameDataManager.shared.shouldDisplay[indexPath.row]
            }
            else {
                cell.status = .empty
            }
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Num", for: indexPath) as! NumPadCell
            cell.displayedNum = indexPath.row + 1
            cell.delegate = self
            cell.configureViews()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 8)/9, height: (collectionView.frame.width - 8)/9)
    }
}

extension ViewController: GamePadCellDelegate {
    func selectGamePad(index: Int) {
        guard let cell = gamePad.cellForItem(at: IndexPath(row: index, section: 0)) as? GamePadCell else { return }
        if cell.isSelected {
            cell.isSelected = false
            selectedGamePadIndex = nil
            return
        }
        cell.isSelected = true
        if let oldIndex = selectedGamePadIndex {
            gamePad.cellForItem(at: IndexPath(row: oldIndex, section: 0))?.isSelected = false
        }
        selectedGamePadIndex = index
    }
}

extension ViewController: NumPadCellDelegate {
    func fillNum(num: Int) {
        guard let index = selectedGamePadIndex else { return }
        guard let cell = gamePad.cellForItem(at: IndexPath(row: index, section: 0)) as? GamePadCell else { return }
        if cell.status == .displayedAtBeginning {
            return
        }
        cell.displayedNum = num
        GameDataManager.shared.shouldDisplay[index] = num
        if GameDataManager.shared.checkAll(place: index) {
            cell.status = .filled
            GameDataManager.shared.emptyNum -= 1
            if GameDataManager.shared.emptyNum == 0 {
                win()
            }
        }
        else {
            cell.status = .wrong
        }
    }
}
