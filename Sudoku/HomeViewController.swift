//
//  HomeViewController.swift
//  Sudoku
//
//  Created by 张翌璠 on 2021-02-27.
//

import UIKit
import GameKit
import SystemConfiguration

class HomeViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var instructionButton: UIButton!
    @IBOutlet weak var leaderBoardButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var spinView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    func configureViews() {
        startButton.layer.cornerRadius = 20
        instructionButton.layer.cornerRadius = 20
        aboutButton.layer.cornerRadius = 20
        leaderBoardButton.layer.cornerRadius = 20
    }
    
    @IBAction func showBoard(_ sender: UIButton) {
        spinView.startAnimating()
        startButton.isUserInteractionEnabled = false
        instructionButton.isUserInteractionEnabled = false
        aboutButton.isUserInteractionEnabled = false
        leaderBoardButton.isUserInteractionEnabled = false
        if !NetworkReachability.isConnectedToNetwork() {
            let alert = UIAlertController(title: "No Internet Connection", message: "Please connect to Internet to enter leaderboard.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            spinView.stopAnimating()
            startButton.isUserInteractionEnabled = true
            instructionButton.isUserInteractionEnabled = true
            aboutButton.isUserInteractionEnabled = true
            leaderBoardButton.isUserInteractionEnabled = true
            return
        }
        
        if GKLocalPlayer.local.isAuthenticated {
            let vc = GKGameCenterViewController(
                leaderboardID: "best_time",
                playerScope: .global,
                timeScope: .allTime)
            vc.gameCenterDelegate = self
            present(vc, animated: true, completion: nil)
            spinView.stopAnimating()
            startButton.isUserInteractionEnabled = true
            instructionButton.isUserInteractionEnabled = true
            aboutButton.isUserInteractionEnabled = true
            leaderBoardButton.isUserInteractionEnabled = true
        }
        else {
            GKLocalPlayer.local.authenticateHandler = { [unowned self] viewController, error in
                if let viewController = viewController {
                    self.present(viewController, animated: true, completion: nil)
                    return
                }
                if error != nil {
                    self.leaderBoardButton.isEnabled = false
                    return
                }
                let vc = GKGameCenterViewController(
                    leaderboardID: "best_time",
                    playerScope: .global,
                    timeScope: .allTime)
                vc.gameCenterDelegate = self
                present(vc, animated: true, completion: nil)
                spinView.stopAnimating()
                startButton.isUserInteractionEnabled = true
                instructionButton.isUserInteractionEnabled = true
                aboutButton.isUserInteractionEnabled = true
                leaderBoardButton.isUserInteractionEnabled = true
            }
        }
        
    }
    
    @IBAction func showAbout(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://github.com/OoaLH")!, options: [:], completionHandler: nil)
    }
}

extension HomeViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        dismiss(animated: true, completion: nil)
    }
}
