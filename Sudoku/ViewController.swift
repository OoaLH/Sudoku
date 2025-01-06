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
    
    let row1 = UIView()
    let row2 = UIView()
    let column1 = UIView()
    let column2 = UIView()
    
    var timer: Timer?
    
    var time: TimeInterval = 0 {
        didSet {
            var second = String(Int(time)%60)
            if Int(time)%60 < 10 {
                second = "0" + second
            }
            timerLabel.text = String(Int(time/60)) + ":" + second
        }
    }
    
    var selectedGamePadIndex: Int?

    var wrongTime: Int = 0 {
        didSet {
            if wrongTime == 3 {
                lose()
            }
            else {
                textLabel.text = "Wrong: " + String(wrongTime)
            }
        }
    }

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
        
        row1.backgroundColor = UIColor.black
        row2.backgroundColor = UIColor.black
        column1.backgroundColor = UIColor.black
        column2.backgroundColor = UIColor.black
        view.addSubview(row1)
        view.addSubview(row2)
        view.addSubview(column1)
        view.addSubview(column2)
    }
    
    func configureLayout() {
        let x = gamePad.frame.minX
        let y = gamePad.frame.minY
        let delta = (gamePad.frame.width - 8)/3 + 2
        let width = gamePad.frame.width
        row1.frame = CGRect(x: x, y: y + delta, width: width, height: 2)
        row2.frame = CGRect(x: x, y: y + 2*delta, width: width, height: 2)
        column1.frame = CGRect(x: x + delta, y: y, width: 2, height: width)
        column2.frame = CGRect(x: x + 2*delta, y: y, width: 2, height: width)
    }
    
    func start() {
        timer?.invalidate()
        time = 0
        wrongTime = 0
        
        gamePad.isHidden = true
        GameDataManager.shared.generateData()
        gamePad.reloadData()
        gamePad.isHidden = false
        
        textLabel.text = "Started!"
        textLabel.textColor = UIColor.systemGreen
        
        gamePad.isUserInteractionEnabled = true
        numPad.isUserInteractionEnabled = true
        
        selectedGamePadIndex = nil
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            self?.time += 1
        })
    }
    
    func win() {
        timer?.invalidate()
        
        textLabel.text = "You win!"
        textLabel.textColor = UIColor.red
        
        gamePad.isUserInteractionEnabled = false
        numPad.isUserInteractionEnabled = false
        
        let alert = UIAlertController(title: "You win!", message: "Upload your record now!", preferredStyle: .alert)
        let upload = UIAlertAction(title: "upload", style: .default) { [unowned self] _ in
            self.uploadScore()
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(upload)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func lose() {
        timer?.invalidate()
        
        textLabel.text = "You lose!"
        textLabel.textColor = UIColor.red
        
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
            GKLeaderboard.submitScore(Int(currentTime), context: 0, player: GKLocalPlayer.local,
                                      leaderboardIDs: ["best_time"]) { error in
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
                GKLeaderboard.submitScore(
                    Int(currentTime),
                    context: 0,
                    player: GKLocalPlayer.local,
                    leaderboardIDs: ["best_time"]) { error in
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
    
    @IBAction func deleteNumber(_ sender: UIButton) {
        guard let index = selectedGamePadIndex,
              let cell = gamePad.cellForItem(at: IndexPath(row: index, section: 0)) as? GamePadCell,
              cell.model?.status == .filled else {
            return
        }
        cell.model?.number = 0
        cell.model?.status = .empty
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == gamePad {
            return GameDataManager.shared.flattenedSudoku.count
        } else {
            return 9
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == gamePad {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Game", for: indexPath) as! GamePadCell
            cell.model = GameDataManager.shared.flattenedSudoku[indexPath.item]
            cell.index = indexPath.row
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Num", for: indexPath) as! NumPadCell
            cell.displayedNum = indexPath.row + 1
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 8)/9, height: (collectionView.frame.width - 8)/9)
    }
}

extension ViewController: GamePadCellDelegate {
    
    func didSelectGamePad(index: Int) {
        guard let cell = gamePad.cellForItem(at: IndexPath(row: index, section: 0)) as? GamePadCell else {
            return
        }
        
        if cell.isSelected {
            cell.isSelected = false
            selectedGamePadIndex = nil
        } else {
            cell.isSelected = true
            if let oldIndex = selectedGamePadIndex {
                gamePad.cellForItem(at: IndexPath(row: oldIndex, section: 0))?.isSelected = false
            }
            selectedGamePadIndex = index
        }
    }
}

extension ViewController: NumPadCellDelegate {
    
    func fillNum(num: Int) {
        guard let index = selectedGamePadIndex,
              let cell = gamePad.cellForItem(at: IndexPath(row: index, section: 0)) as? GamePadCell,
              cell.model?.status != .displayedAtBeginning else {
            return
        }

        let oldNum = GameDataManager.shared.flattenedSudoku[index].number
        GameDataManager.shared.flattenedSudoku[index].number = num
        
        if GameDataManager.shared.checkPlacement(index: index) {
            cell.model?.status = .filled
            
            let empty = GameDataManager.shared.flattenedSudoku.filter {
                $0.number == 0
            }.count
            if empty == 0 {
                win()
            }
        } else {
            wrongTime += 1
            cell.model?.number = oldNum
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
