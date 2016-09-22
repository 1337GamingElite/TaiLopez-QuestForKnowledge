//
//  GameOverScene.swift
//  Tai Lopez - A Quest for Knowledge
//
//  Created by John Marcus Mabanta on 2016-05-25.
//  Copyright © 2016 1337GamingElite. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene{
    
    // Variables Initialized for the Class
    let restartLabel = SKLabelNode(fontNamed: "LemonMilk")
    let menuLabel = SKLabelNode(fontNamed: "LemonMilk")
    
    // Runs when scenes load
    override func didMove(to view: SKView) {
        
        currentGameState = gameState.afterGame
        
        // Background Init
        let bg = SKSpriteNode(imageNamed: "background2")
        bg.size = self.size
        bg.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        // Layering
        bg.zPosition = 0
        self.addChild(bg)

        // Game Over Label Init
        let gameOverLabel = SKLabelNode(fontNamed: "Lobster1.4")
        gameOverLabel.text = "GAME OVER!!!"
        gameOverLabel.fontSize = 190
        gameOverLabel.fontColor = SKColor.magenta
        gameOverLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
        
        // Score Label
        let scoreLabel = SKLabelNode(fontNamed: "LemonMilk")
        scoreLabel.text = "Materialistic Things Shot: \(gameScore)"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.magenta
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.55)
        scoreLabel.zPosition = 1
        self.addChild(scoreLabel)
        
        // User Defaults (Sets & Gets High Score)
        let defaults = UserDefaults()
        var highScoreNumber = defaults.integer(forKey: "highScoreSaved")
        
        if gameScore > highScoreNumber{
            highScoreNumber = gameScore
            defaults.set(highScoreNumber, forKey: "highScoreSaved")
        }
        
        // High Score Label
        let highScoreLabel = SKLabelNode(fontNamed: "LemonMilk")
        highScoreLabel.text = "HIGH SCORE: \(highScoreNumber)"
        highScoreLabel.fontSize = 105
        highScoreLabel.fontColor = SKColor.magenta
        highScoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.45)
        highScoreLabel.zPosition = 1
        self.addChild(highScoreLabel)
        
        // Restart Button
        restartLabel.text = "Play Again"
        restartLabel.fontSize = 70
        restartLabel.fontColor = SKColor.magenta
        restartLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.3)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)
        
        // Menu Label
        menuLabel.text = "Back to Start Menu"
        menuLabel.fontSize = 70
        menuLabel.fontColor = SKColor.magenta
        menuLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        menuLabel.zPosition = 1
        self.addChild(menuLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            if restartLabel.contains(pointOfTouch){
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.doorsOpenHorizontal(withDuration: 1)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            } else if menuLabel.contains(pointOfTouch){
                
                let sceneToMoveTo = MenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.doorsOpenHorizontal(withDuration: 1)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }
            
        }
        
    }
    
}
