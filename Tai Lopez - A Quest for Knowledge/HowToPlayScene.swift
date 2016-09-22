//
//  HowToPlayScene.swift
//  Tai Lopez - A Quest for Knowledge
//
//  Created by John Marcus Mabanta on 2016-05-26.
//  Copyright © 2016 1337GamingElite. All rights reserved.
//

import Foundation
import SpriteKit

class HowToPlayScene: SKScene{
    
    let playGameButton = SKLabelNode(fontNamed: "LemonMilk")
    
    override func didMove(to view: SKView) {
        
        currentGameState = gameState.preGame
        
        // Background Init
        let bg = SKSpriteNode(imageNamed: "background2")
        bg.size = self.size
        bg.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        bg.zPosition = 0
        self.addChild(bg)
        
        // How to Play Title
        let tutorialLabel = SKLabelNode(fontNamed: "Lobster1.4")
        tutorialLabel.text = "How to Play"
        tutorialLabel.fontSize = 180
        tutorialLabel.fontColor = SKColor.green
        tutorialLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.75)
        tutorialLabel.zPosition = 1
        self.addChild(tutorialLabel)
        
        // "How to move Tai Lopez"
        let movementLabel = SKLabelNode(fontNamed: "LemonMilk")
        movementLabel.text = "To move Tai Lopez, swipe left, right, up, or down."
        movementLabel.fontSize = 50
        movementLabel.fontColor = SKColor.green
        movementLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.65)
        movementLabel.zPosition = 1
        self.addChild(movementLabel)
        
        // "How to Shoot"
        let shootLabel = SKLabelNode(fontNamed: "LemonMilk")
        shootLabel.text = "To shoot, simply tap the screen."
        shootLabel.fontSize = 50
        shootLabel.fontColor = SKColor.green
        shootLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.60)
        shootLabel.zPosition = 1
        self.addChild(shootLabel)
        
        // "Limited Bullets"
        let limitLabel = SKLabelNode(fontNamed: "LemonMilk")
        limitLabel.text = "Remember, your bullets recharge over time"
        limitLabel.fontSize = 50
        limitLabel.fontColor = SKColor.green
        limitLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.55)
        limitLabel.zPosition = 1
        self.addChild(limitLabel)
        
        // "How To Die"
        let deathLabel = SKLabelNode(fontNamed: "LemonMilk")
        deathLabel.text = "You lose lives by missing targets."
        deathLabel.fontSize = 50
        deathLabel.fontColor = SKColor.green
        deathLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        deathLabel.zPosition = 1
        self.addChild(deathLabel)
        
        // "How to John Cena"
        let johnCenaDeathLabel = SKLabelNode(fontNamed: "LemonMilk")
        johnCenaDeathLabel.text = "You get instant K.O'd if you get hit by Lamborghinis."
        johnCenaDeathLabel.fontSize = 40
        johnCenaDeathLabel.fontColor = SKColor.green
        johnCenaDeathLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.45)
        johnCenaDeathLabel.zPosition = 1
        self.addChild(johnCenaDeathLabel)
        
        // PLay Game Button
        playGameButton.text = "Next Page"
        playGameButton.fontSize = 70
        playGameButton.fontColor = SKColor.green
        playGameButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.2)
        playGameButton.zPosition = 1
        self.addChild(playGameButton)
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.location(in: self)
            
            if playGameButton.contains(pointOfTouch){
                
                let sceneToMoveTo = HowToPlayPG2(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.doorsOpenHorizontal(withDuration: 1)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }
            
        }
        
    }
    
}
