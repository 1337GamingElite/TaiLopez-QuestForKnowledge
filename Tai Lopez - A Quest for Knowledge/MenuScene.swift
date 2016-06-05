//
//  MenuScene.swift
//  Tai Lopez - A Quest for Knowledge
//
//  Created by John Marcus Mabanta on 2016-05-26.
//  Copyright © 2016 1337GamingElite. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    let playButton = SKLabelNode(fontNamed: "LemonMilk")
    let viewInstructions = SKLabelNode(fontNamed: "LemonMilk")
    
    override func didMoveToView(view: SKView) {
        
        currentGameState = gameState.preGame
        
        // Background Init
        let bg = SKSpriteNode(imageNamed: "background2")
        bg.size = self.size
        bg.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        bg.zPosition = 0
        self.addChild(bg)
        
        // Title Text
        let titleLabel = SKLabelNode(fontNamed: "Lobster1.4")
        titleLabel.text = "Tai Lopez"
        titleLabel.fontSize = 190
        titleLabel.fontColor = SKColor.magentaColor()
        titleLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        titleLabel.zPosition = 1
        self.addChild(titleLabel)
        
        // Subtitle text
        let subtitleLabel = SKLabelNode(fontNamed: "Lobster1.4")
        subtitleLabel.text = "A Quest for Knowledge!"
        subtitleLabel.fontSize = 120
        subtitleLabel.fontColor = SKColor.magentaColor()
        subtitleLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.6)
        subtitleLabel.zPosition = 1
        self.addChild(subtitleLabel)
        
        // Play Button
        playButton.text = "Start Game"
        playButton.fontSize = 70
        playButton.fontColor = SKColor.magentaColor()
        playButton.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.25)
        playButton.zPosition = 1
        self.addChild(playButton)
        
        // How to Play Button
        viewInstructions.text = "How to Play"
        viewInstructions.fontSize = 70
        viewInstructions.fontColor = SKColor.magentaColor()
        viewInstructions.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.2)
        viewInstructions.zPosition = 1
        self.addChild(viewInstructions)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let pointOfTouch = touch.locationInNode(self)
            
            if playButton.containsPoint(pointOfTouch) {
                
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.doorsOpenHorizontalWithDuration(1)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            } else if viewInstructions.containsPoint(pointOfTouch){
                
                let sceneToMoveTo = HowToPlayScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransistion = SKTransition.doorsOpenHorizontalWithDuration(1)
                self.view!.presentScene(sceneToMoveTo, transition: myTransistion)
                
            }
            
        }
        
    }
    
}