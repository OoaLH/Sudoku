//
//  ViewController.swift
//  Sudoku
//
//  Created by 张翌璠 on 2021-02-09.
//

import UIKit
import GameKit

class ViewController: UIViewController {
    @IBOutlet weak var gamePad: UICollectionView!
    @IBOutlet weak var numPad: UICollectionView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var isNoteMode: Bool = false
    
    let row1 = UIView()
    let row2 = UIView()
    let line1 = UIView()
    let line2 = UIView()
    
    var timer: Timer?
    
    var time: TimeInterval = 0 {
        didSet {
            var second = String(Int(time) % 60)
            if Int(time) % 60 < 10 {
                second = "0" + second
            }
            timerLabel.text = String(Int(time/60)) + ":" + second
        }
    }
    
    var selectedGamePadIndex: Int?
    var selectedNumPadIndex: Int?
    
    var timesOfMistake: Int = 0 {
        didSet {
            if timesOfMistake == 3 {
                lose()
            } else {
                textLabel.text = "Wrong: " + String(timesOfMistake)
            }
        }
    }
    
    var wrongCellIndex: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        start()
    }
    
    override func viewDidLayoutSubviews() {
        configureLayout()
    }
    
    func configureViews() {
        startButton.layer.cornerRadius = 20
        
        row1.backgroundColor = .black
        row2.backgroundColor = .black
        line1.backgroundColor = .black
        line2.backgroundColor = .black
        view.addSubview(row1)
        view.addSubview(row2)
        view.addSubview(line1)
        view.addSubview(line2)
    }
    
    func configureLayout() {
        let x = gamePad.frame.minX
        let y = gamePad.frame.minY
        let delta = (gamePad.frame.width - 8)/3 + 2
        let width = gamePad.frame.width
        row1.frame = CGRect(x: x, y: y + delta, width: width, height: 2)
        row2.frame = CGRect(x: x, y: y + 2*delta, width: width, height: 2)
        line1.frame = CGRect(x: x + delta, y: y, width: 2, height: width)
        line2.frame = CGRect(x: x + 2*delta, y: y, width: 2, height: width)
    }
    
    func start() {
        time = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            self?.time += 1
        })
        
        GameDataManager.shared.refreshData()
        GameDataManager.shared.generateData()
        timesOfMistake = 0
        
        gamePad.reloadData()
        numPad.reloadData()
        gamePad.isUserInteractionEnabled = true
        numPad.isUserInteractionEnabled = true
        
        textLabel.text = "Started!"
        textLabel.textColor = UIColor.systemGreen
        
        selectedGamePadIndex = nil
        selectedNumPadIndex = nil
    }
    
    func win() {
        timer?.invalidate()
        
        textLabel.text = "You win!"
        textLabel.textColor = UIColor.red
        
        gamePad.isUserInteractionEnabled = false
        numPad.isUserInteractionEnabled = false
        
        let alert = UIAlertController(title: "You win!", message: "Upload your record now!", preferredStyle: .alert)
        let upload = UIAlertAction(title: "upload", style: .default) { [unowned self] _ in
            uploadScore()
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(upload)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func lose() {
        timer?.invalidate()
        
        textLabel.text = "You lose!"
        textLabel.textColor = .red
        
        gamePad.isUserInteractionEnabled = false
        numPad.isUserInteractionEnabled = false
    }
    
    func uploadScore() {
        if !NetworkReachability.isConnectedToNetwork() {
            let alert = UIAlertController(title: "No Internet Connection", message: "Please connect to Internet to upload your score.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            return
        }
        let currentTime = time
        if GKLocalPlayer.local.isAuthenticated {
            GKLeaderboard.submitScore(Int(currentTime), context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["best_time"]) { error in
            }
        } else {
            GKLocalPlayer.local.authenticateHandler = { [unowned self] viewController, error in
                if let viewController = viewController {
                    self.present(viewController, animated: true, completion: nil)
                    return
                }
                if error != nil {
                    return
                }
                GKLeaderboard.submitScore(Int(currentTime), context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["best_time"]) { error in
                }
            }
        }
    }
    
    @IBAction func newRound(_ sender: UIButton) {
        start()
    }
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noteTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        isNoteMode.toggle()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == gamePad {
            return 81
        } else {
            return 9
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == gamePad {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Game", for: indexPath) as! GamePadCell
            if GameDataManager.shared.numbersToDisplay[indexPath.row] != 0 {
                cell.status = .displayedAtBeginning
                cell.displayedNum = GameDataManager.shared.numbersToDisplay[indexPath.row]
            } else {
                cell.status = .empty
            }
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Num", for: indexPath) as! NumPadCell
            cell.displayedNum = indexPath.row + 1
            cell.delegate = self
            cell.configureViews()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 8) / 9, height: (collectionView.frame.width - 8) / 9)
    }
}

extension ViewController: GamePadCellDelegate {
    func selectGamePad(index: Int) {
        guard let cell = gamePad.cellForItem(at: IndexPath(row: index, section: 0)) as? GamePadCell else { return }
        if let oldNumPadIndex = selectedNumPadIndex {
            numPad.cellForItem(at: IndexPath(row: oldNumPadIndex, section: 0))?.isSelected = false
        }
        if cell.isSelected {
            cell.isSelected = false
            selectedGamePadIndex = nil
            selectedNumPadIndex = nil
            
            NotificationCenter.default.post(name: Notification.Name("SelectionChanged"), object: 0)
        } else {
            cell.isSelected = true
            if let oldIndex = selectedGamePadIndex {
                gamePad.cellForItem(at: IndexPath(row: oldIndex, section: 0))?.isSelected = false
            }
            selectedGamePadIndex = index
            
            if cell.displayedNum != 0 && cell.status != .displayedAtBeginning {
                numPad.cellForItem(at: IndexPath(row: cell.displayedNum - 1, section: 0))?.isSelected = true
                selectedNumPadIndex = cell.displayedNum - 1
            } else {
                selectedNumPadIndex = nil
            }
            
            if cell.status == .displayedAtBeginning {
                NotificationCenter.default.post(name: Notification.Name("SelectionChanged"), object: cell.displayedNum)
            } else {
                NotificationCenter.default.post(name: Notification.Name("SelectionChanged"), object: 0)
            }
        }
    }
}

extension ViewController: NumPadCellDelegate {
    func fillNum(num: Int) {
        guard let index = selectedGamePadIndex else { return }
        guard let cell = gamePad.cellForItem(at: IndexPath(row: index, section: 0)) as? GamePadCell else { return }
        if cell.status == .displayedAtBeginning {
            return
        }
        if isNoteMode {
            if cell.status == .empty {
                cell.addNote(num: num)
            }
            return
        }
        if let oldNumPadIndex = selectedNumPadIndex {
            numPad.cellForItem(at: IndexPath(row: oldNumPadIndex, section: 0))?.isSelected = false
            if oldNumPadIndex == num - 1 {
                cell.status = .empty
                GameDataManager.shared.emptyNum += 1
                GameDataManager.shared.numbersToDisplay[index] = 0
                selectedNumPadIndex = nil
                return
            }
        }
        numPad.cellForItem(at: IndexPath(row: num - 1, section: 0))?.isSelected = true
        selectedNumPadIndex = num - 1
        let oldNum = cell.displayedNum
        cell.displayedNum = num
        GameDataManager.shared.numbersToDisplay[index] = num
        if cell.status == .empty {
            GameDataManager.shared.emptyNum -= 1
        } else {
            let row = index / 9
            let column = index % 9
            let rowSection = row < 3 ? 0 : (row < 6 ? 1 : 2)
            let columnSection = column < 3 ? 0 : (column < 6 ? 1 : 2)
            for wrongIndex in wrongCellIndex {
                let wrongCell = gamePad.cellForItem(at: IndexPath(row: wrongIndex, section: 0)) as! GamePadCell
                if wrongIndex != index && wrongCell.displayedNum == oldNum && oldNum != num {
                    let i = wrongIndex / 9
                    let j = wrongIndex % 9
                    let iSection = i < 3 ? 0 : (i < 6 ? 1 : 2)
                    let jSection = j < 3 ? 0 : (j < 6 ? 1 : 2)
                    if i == row || j == column || (iSection == rowSection && jSection == columnSection) {
                        if GameDataManager.shared.checkForPlacement(place: wrongIndex) {
                            wrongCell.status = .filled
                            wrongCellIndex.remove(wrongIndex)
                        }
                    }
                }
            }
        }
        if GameDataManager.shared.checkForPlacement(place: index) {
            cell.status = .filled
            if GameDataManager.shared.emptyNum == 0 {
                win()
            }
        }
        else {
            cell.status = .wrong
            timesOfMistake += 1
            wrongCellIndex.insert(index)
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }
}

extension ViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        dismiss(animated: true, completion: nil)
    }
}
