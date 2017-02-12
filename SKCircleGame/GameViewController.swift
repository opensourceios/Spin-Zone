//
//  GameViewController.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 10/10/16.
//  Copyright © 2016 Nicholas Grana. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController, GKGameCenterControllerDelegate {
    
    // MARK: Overriden methods
    
    static var mainView: GameViewController!
    
    var gameStartMenu: GameStartMenu! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authPlayer()
        
        GameViewController.mainView = self
        
        Constants.currentSize = self.view.frame.size
        
        if let newView = self.view as! SKView? {
            gameStartMenu = GameStartMenu(size: Constants.currentSize)

            GoalSprite.loadTextures()
            TrackSprite.loadTextures()
            
            gameStartMenu.scaleMode = .aspectFill
            newView.presentScene(self.gameStartMenu)
            newView.ignoresSiblingOrder = true
        }
        
    }
    
    func authPlayer() {
        let local = GKLocalPlayer.localPlayer()
        
        local.authenticateHandler = {
            (view, error) in
            
            if view != nil {
                self.present(view!, animated: true, completion: {})
            } else {
                print("authenticated")
            }
        }
        
    }
    
    func showLeaderboards() {
        let leaderboardViewController = GKGameCenterViewController()
        leaderboardViewController.viewState = .leaderboards
        leaderboardViewController.leaderboardTimeScope = .today
        leaderboardViewController.leaderboardIdentifier = "spinzone.levels"
        leaderboardViewController.gameCenterDelegate = self
        self.present(leaderboardViewController, animated: true, completion: {})
    }
    
    func sendScores() {
        let shareViewController = UIActivityViewController(activityItems: ["I'm on level \(GameModel.currentLevel) in Spin Zone! Check it out, it's free: https://itunes.apple.com/app/id1200316153"], applicationActivities: nil)
        self.present(shareViewController, animated: true, completion: {})
    }
    
    func link() {
        UIApplication.shared.open(URL(string: "https://itunes.apple.com/app/id1200316153")!)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        self.dismiss(animated: true, completion: {})
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
