//
//  HowToPlayPG2.swift
//  Tai Lopez - A Quest for Knowledge
//
//  Created by John Marcus Mabanta on 2016-06-06.
//  Copyright © 2016 1337GamingElite. All rights reserved.
//

import Foundation
import SpriteKit

class HowToPlayPG2: SKScene {
    
    let prevPage = SKLabelNode(fontNamed: "LemonMilk")
    let playGame = SKLabelNode(fontNamed: "LemonMilk")
    
    override func didMoveToView(view: SKView) {
        
        currentGameState = gameState.preGame
        
        // Background init
        let bg = SKSpriteNode(imageNamed: "background2")
        bg.size = self.size
        bg.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        bg.zPosition = 0
        self.addChild(bg)
        
        // PowerUp title
        let powerTitle = SKLabelNode(fontNamed: "Lobster1.4")
        powerTitle.text = "Power Ups"
        powerTitle.fontSize = 150
        powerTitle.fontColor = SKColor.magentaColor()
        powerTitle.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.75)
        powerTitle.zPosition = 1
        self.addChild(powerTitle)
        
        // Subtitle Title
        let subTitle = SKLabelNode(fontNamed: "LemonMilk")
        subTitle.text = "You can find PowerUPs while you play."
        subTitle.fontSize = 50
        subTitle.fontColor = SKColor.magentaColor()
        subTitle.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.65)
        subTitle.zPosition = 1
        self.addChild(subTitle)
        
        // PowerUp intro
        let powerUpIntro = SKLabelNode(fontNamed: "LemonMilk")
        powerUpIntro.text = "These powerups are:"
        powerUpIntro.fontSize = 50
        powerUpIntro.fontColor = SKColor.magentaColor()
        powerUpIntro.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.60)
        powerUpIntro.zPosition = 1
        self.addChild(powerUpIntro)
        
        // Infinite PowerUP Img
        let rapidFire = SKSpriteNode(imageNamed: "rapidFirePowerUp")
        rapidFire.setScale(0.75)
        rapidFire.position = CGPoint(x: self.size.width * 0.35, y: self.size.height / 2 + 15)
        rapidFire.zPosition = 1
        self.addChild(rapidFire)
        // Infinite PowerUp Label
        let rapidFireLabel = SKLabelNode(fontNamed: "LemonMilk")
        rapidFireLabel.text = "- Rapid Fire"
        rapidFireLabel.fontSize = 70
        rapidFireLabel.fontColor = SKColor.magentaColor()
        rapidFireLabel.position = CGPoint(x: self.size.width * 0.6, y: rapidFire.position.y - 30)
        rapidFireLabel.zPosition = 1
        self.addChild(rapidFireLabel)
        
        // SlowMo PowerUp
        let slowMo = SKSpriteNode(imageNamed: "slowTime")
        slowMo.setScale(1.9)
        slowMo.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.35 + 15)
        slowMo.zPosition = 1
        self.addChild(slowMo)
        
        // SlowMo PowerUp Label
        let slowMoLabel = SKLabelNode(fontNamed: "LemonMilk")
        slowMoLabel.text = "- Slow Motion"
        slowMoLabel.fontSize = 70
        slowMoLabel.fontColor = SKColor.magentaColor()
        slowMoLabel.position = CGPoint(x: self.size.width * 0.625, y: slowMo.position.y - 30)
        slowMoLabel.zPosition = 1
        self.addChild(slowMoLabel)
        
        // PrevPage
        prevPage.text = "Previous Page"
        prevPage.fontSize = 70
        prevPage.fontColor = SKColor.magentaColor()
        prevPage.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.15)
        prevPage.zPosition = 1
        self.addChild(prevPage)
        
        // Play Game
        playGame.text = "Play Game"
        playGame.fontSize = 70
        playGame.fontColor = SKColor.magentaColor()
        playGame.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.1)
        playGame.zPosition = 1
        self.addChild(playGame)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.locationInNode(self)
            
            if prevPage.containsPoint(pointOfTouch) {
                
                let sceneToMoveTo = HowToPlayScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.doorsCloseHorizontalWithDuration(1)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            } else if playGame.containsPoint(pointOfTouch) {
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.doorsOpenHorizontalWithDuration(1)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }
            
        }
        
    }
    
}