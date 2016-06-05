//
//  GameScene.swift
//  Tai Lopez - A Quest for Knowledge
//
//  Created by John Marcus Mabanta on 2016-05-24.
//  Copyright (c) 2016 1337GamingElite. All rights reserved.
//

import SpriteKit
import Foundation

// Asset Initialization for use in All Classes
var gameScore = 0

// Game States
enum gameState{
    case preGame // Before the game starts (menu & instructions)
    case inGame // During the game
    case afterGame // After the Game
}

var currentGameState = gameState.preGame

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Asset Initialization for Use In Class
    let scoreLabel = SKLabelNode(fontNamed: "LemonMilk")
    
    var knowledgeNumber = 3
    let knowledgeLabel = SKLabelNode(fontNamed: "LemonMilk")
    
    var levelNumber = 0
    
    var bulletBank = 0
    var bulletBankRefresh = NSTimeInterval()
    let bulletBankLabel = SKLabelNode(fontNamed: "LemonMilk")
    
    let player = SKSpriteNode(imageNamed: "player")
    
    var hitPauseButton: Bool = false
    let pauseButton = SKSpriteNode(imageNamed: "pauseButton")
    let pauseBG = SKSpriteNode(imageNamed: "pauseBG")
    let pauseText = SKLabelNode(fontNamed: "LemonMilk")
    
    let bulletSound = SKAction.playSoundFileNamed("bulletsound.wav", waitForCompletion: false)
    let bulletHit = SKAction.playSoundFileNamed("bulletHit.wav", waitForCompletion: false)
    let loseSound = SKAction.playSoundFileNamed("lose.wav", waitForCompletion: false)
    
    var enableRapidFire : Bool = false
    var heldDown : Bool = false
    var rapidFireTimer = NSTimer()
    var rapidFireTimerValue: Int = 0
    
    // Physics Categories
    struct PhysicsCategories {
        static let None : UInt32 = 0
        
        static let Player : UInt32 = 0b1 // 1
        static let RapidFire : UInt32 = 0b10 // 2
        static let Bullet : UInt32 = 0b100 // 4
        static let Enemy : UInt32 = 0b1000 // 8
    }
    
    // Generates Random Number
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    // Sets Playable Area
    let gameArea: CGRect
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Runs when Scene Loads
    override func didMoveToView(view: SKView) {
        
        currentGameState = gameState.inGame
        gameScore = 0
        bulletBank = 0
        bulletBankRefresh = 1
        hitPauseButton = false
        enableRapidFire = false
        heldDown = false
        rapidFireTimerValue = 0
        
        self.speed = 1
        
        self.physicsWorld.contactDelegate = self
        
        // Background Init
        let bg = SKSpriteNode(imageNamed: "background2")
        bg.size = self.size
        bg.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        // Layering
        bg.zPosition = 0
        self.addChild(bg)
        
        //Player Settings
        player.setScale(1.5)
        player.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.2)
        //Layering
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        // Score Label
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = SKColor.greenColor()
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        scoreLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.95)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        // Lives Label
        knowledgeLabel.text = "Knowledge Left: 3"
        knowledgeLabel.fontSize = 50
        knowledgeLabel.fontColor = SKColor.greenColor()
        knowledgeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        knowledgeLabel.position = CGPoint(x: self.size.width * 0.85, y: self.size.height * 0.03)
        knowledgeLabel.zPosition = 100
        self.addChild(knowledgeLabel)
        
        // Bullet Count Label
        bulletBankLabel.text = "Bullets Left: 0"
        bulletBankLabel.fontSize = 50
        bulletBankLabel.fontColor = SKColor.greenColor()
        bulletBankLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        bulletBankLabel.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.03)
        bulletBankLabel.zPosition = 100
        self.addChild(bulletBankLabel)
        
        // Pause Button
        pauseButton.setScale(0.25)
        pauseButton.position = CGPoint(x: self.size.width * 0.81, y: self.size.height * 0.95)
        pauseButton.zPosition = 100
        self.addChild(pauseButton)
        
        // Darkens Screen During Paused
        pauseBG.size = self.size
        pauseBG.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        pauseBG.zPosition = 10
        
        // "Paused" Text
        pauseText.text = "PAUSED"
        pauseText.fontSize = 100
        pauseText.fontColor = SKColor.greenColor()
        pauseText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        pauseText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        pauseText.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        pauseText.zPosition = 100
        
        // Change Bullet Count
        let waitTime = SKAction.waitForDuration(bulletBankRefresh)
        let addToBulletBank = SKAction.runBlock(addBulletBank)
        let bulletCountSequence = SKAction.sequence([waitTime, addToBulletBank])
        self.runAction(SKAction.repeatActionForever(bulletCountSequence))
        
        startNewLevel()
        
    }
    
    func pauseGame(){
        hitPauseButton = true
        pauseButton.texture = SKTexture(imageNamed: "unpauseButton")
        self.speed = 0
        self.addChild(pauseBG)
        self.addChild(pauseText)
    }
    
    func continueGame(){
        hitPauseButton = false
        pauseButton.texture = SKTexture(imageNamed: "pauseButton")
        self.speed = 1
        pauseBG.removeFromParent()
        pauseText.removeFromParent()
    }
    
    func getDumber(){
        
        knowledgeNumber -= 1
        knowledgeLabel.text = "Knowledge Left: \(knowledgeNumber)"
        
        let scaleUp = SKAction.scaleTo(1.5, duration: 0.2)
        let scaleDown = SKAction.scaleTo(1, duration: 0.2)
        let dumberSequence = SKAction.sequence([scaleUp, scaleDown])
        
        knowledgeLabel.runAction(dumberSequence)
        
        if knowledgeNumber == 0 {
            gameOver()
        }
        
    }
    
    func addScore(){
        
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        if gameScore == 5 || gameScore == 10 || gameScore == 15 || gameScore == 20 || gameScore == 30
            || gameScore == 50 || gameScore == 60 || gameScore == 75 || gameScore == 100 || gameScore == 200 {
            startNewLevel()
        }
        
        if gameScore % 5 == 0 {
            spawnRapidFire()
        }
        
    }
    
    func startRapidFireTimer(){
        rapidFireTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(GameScene.rapidFire), userInfo: nil, repeats: true)
    }
    
    func rapidFire(){
        rapidFireTimerValue += 1
        if rapidFireTimerValue < 60{
            fireBullet()
        } else {
            rapidFireTimer.invalidate()
        }
    }
    
    func addBulletBank(){
        bulletBank += 1
        bulletBankLabel.text = "Bullets Left: \(bulletBank)"
    }
    
    func removeBulletBank(){
        bulletBank -= 1
        bulletBankLabel.text = "Bullets Left: \(bulletBank)"
    }
    
    func gameOver(){
        
        currentGameState = gameState.afterGame
        
        self.removeAllActions()
        rapidFireTimer.invalidate()
        
        // Stops Bullets in Game Over
        self.enumerateChildNodesWithName("Books"){
            bullet, stop in
            bullet.removeAllActions()
        }
        
        // Stops Enemies in Game Over
        self.enumerateChildNodesWithName("Lamborghini"){
            enemy, stop in
            enemy.removeAllActions()
        }
        
        // Stops Rainbow Enemy
        self.enumerateChildNodesWithName("Bugatti"){
            rainbowEnemy, stop in
            rainbowEnemy.removeAllActions()
        }
        
        // Stops Rainbow Enemy Bullets
        self.enumerateChildNodesWithName("Money"){
            rainbowCarBullet, stop in
            rainbowCarBullet.removeAllActions()
        }
        
        // Goes to Game Over screen
        let changeSceneAction = SKAction.runBlock(changeScene)
        let waitToChangeScene = SKAction.waitForDuration(1.5)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])
        self.runAction(changeSceneSequence)
        
    }
    
    func changeScene(){
        
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.doorsCloseHorizontalWithDuration(1)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
        
    }
    
    // Runs when physics bodies made contact
    func didBeginContact(contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        // Enemy Hits Player
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy{
            
            if body1.node != nil {
                spawnKnowlegdeLose(body1.node!.position)
            }
            
            if body2.node != nil {
                spawnKnowlegdeLose(body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
            gameOver()
            
        }
        
        // Bullet Hits Enemy
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy &&
            body2.node?.position.y < self.size.height{
            
            addScore()
            
            if body2.node != nil {
                spawnKnowlegdePoint(body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
        }
        
        // Player Gets Rapid Fire Thing
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.RapidFire{
            
            startRapidFireTimer()
            
            body2.node?.removeFromParent()
            
        }
        
    }
    
    // Explosion
    func spawnKnowlegdePoint(spawnPosition: CGPoint){
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scaleTo(3, duration: 0.1)
        let fadeOut = SKAction.fadeOutWithDuration(0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([bulletHit, scaleIn, fadeOut, delete])
        explosion.runAction(explosionSequence)
        
    }
    
    func spawnKnowlegdeLose(spawnPosition: CGPoint){
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scaleTo(3, duration: 0.1)
        let fadeOut = SKAction.fadeOutWithDuration(0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([loseSound, scaleIn, fadeOut, delete])
        explosion.runAction(explosionSequence)
        
    }

    
    func startNewLevel(){
        
        levelNumber += 1
        
        if self.actionForKey("spawningEnemies") != nil {
            self.removeActionForKey("spawningEnemies")
        }
        
        var lvlDuration = NSTimeInterval()
        
        // Enemy Spawn Duration every Lvl
        switch levelNumber {
        case 1:
            lvlDuration = 2
        case 2:
            lvlDuration = 1.8
        case 3:
            lvlDuration = 1.6
        case 4:
            lvlDuration = 1.4
        case 5:
            lvlDuration = 1.2
        case 6:
            lvlDuration = 1
        case 7:
            lvlDuration = 0.8
        case 8:
            lvlDuration = 0.7
        case 9:
            lvlDuration = 0.6
        case 10:
            lvlDuration = 0.5
        case 11:
            self.speed = 2
        default:
            lvlDuration = 0.5
            print("Level Info Invalid")
        }
        
        // Spawns Enemy
        let spawn = SKAction.runBlock(spawnEnemy)
        // Spawn Wait Time
        let waitToSpawn = SKAction.waitForDuration(lvlDuration)
        
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatActionForever(spawnSequence)
        
        self.runAction(spawnForever, withKey: "spawningEnemies")
        
    }
    
    // Fires Bullet
    func fireBullet(){
        
        // Bullet Init
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Books"
        bullet.setScale(1.5)
        bullet.position = CGPoint(x: player.position.x - 70, y: player.position.y)
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(bullet)
        
        // Moves Bullet
        let moveBullet = SKAction.moveToY(self.size.height + bullet.size.height, duration: 1)
        
        // Deletes Bullet
        let deleteBullet = SKAction.removeFromParent()
        
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        
        bullet.runAction(bulletSequence)
        
    }
    
    // Spawns Enemies
    func spawnEnemy(){
        
        //Location Generation
        let randomXStart = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let randomXEnd = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        //Enemy Init
        let enemy = SKSpriteNode(imageNamed: "enemy")
        enemy.name = "Lamborghini"
        enemy.setScale(1.5)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enemy)
        
        // Movement
        let moveEnemy = SKAction.moveTo(endPoint, duration: 2)
        // Deletes enemy
        let deleteEnemy = SKAction.removeFromParent()
        // Loses Knowledge
        let getRetarded = SKAction.runBlock(getDumber)
        
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, getRetarded])
        
        if currentGameState == gameState.inGame {
            enemy.runAction(enemySequence)
        }
        
        // Rotates Enemy
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y

        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
        
    }
    
    func createRapidFirePowerUp(){
        
        // Generates Random Location for Power Up
        let posX = random(min: CGRectGetMinX(gameArea), max: CGRectGetMaxX(gameArea))
        let posY = random(min: self.size.height - 20, max: 20)
        
        let position = CGPoint(x: posX - 20, y: posY)
        
        // Object Init
        let rapidFirePower = SKSpriteNode(imageNamed: "rapidFirePowerUp")
        rapidFirePower.name = "RapidFire"
        rapidFirePower.setScale(0.75)
        rapidFirePower.position = position
        rapidFirePower.zPosition = 4
        rapidFirePower.physicsBody = SKPhysicsBody(rectangleOfSize: rapidFirePower.size)
        rapidFirePower.physicsBody!.affectedByGravity = false
        rapidFirePower.physicsBody!.categoryBitMask = PhysicsCategories.RapidFire
        rapidFirePower.physicsBody!.collisionBitMask = PhysicsCategories.None
        rapidFirePower.physicsBody!.contactTestBitMask = PhysicsCategories.Player
        self.addChild(rapidFirePower)
        
    }
    
    func spawnRapidFire(){
        
        var chance = random(min: 1, max: 3)
        
        if chance == 2 {
            createRapidFirePowerUp()
        } else {
            chance = 0
        }
        
        chance = random(min: 1, max: 3)
        
    }
    
    //Method calls when screen is un-touched
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.locationInNode(self)
            
            if pauseButton.containsPoint(pointOfTouch){
                if hitPauseButton == false{
                    pauseGame()
                } else {
                    continueGame()
                }
            }
         
            // Checks if the game is still going + Checks if there are bullets in bullet bank + Checks if not touching Tai Lopez
            if currentGameState == gameState.inGame && bulletBank != 0 && self.speed == 1
                && !pauseButton.containsPoint(pointOfTouch) && !player.containsPoint(pointOfTouch) && !enableRapidFire{
                fireBullet()
                removeBulletBank()
            }
            
        }
        
    }
    
    // Runs when touch moves
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        for touch: AnyObject in touches{
            
            let pointOfTouch = touch.locationInNode(self)
            let previousPointofTouch = touch.previousLocationInNode(self)
            
            let amountDraggedX = pointOfTouch.x - previousPointofTouch.x
            let amountDraggedY = pointOfTouch.y - previousPointofTouch.y
            
            // Checks if the game is still going
            if currentGameState == gameState.inGame && self.speed != 0{
                player.position.x += amountDraggedX
                player.position.y += amountDraggedY
            }
            
            // Prevents Player from Going Of Screen
            if player.position.x > CGRectGetMaxX(gameArea) - player.size.width / 2{
                player.position.x = CGRectGetMaxX(gameArea) - player.size.width / 2
            }
            
            if player.position.x < CGRectGetMinX(gameArea) + player.size.width / 2{
                player.position.x = CGRectGetMinX(gameArea) + player.size.width / 2
            }
            
            if player.position.y > self.size.height + player.size.height / 2{
                player.position.y = self.size.height + player.size.height / 2
            }
            
            if player.position.y < player.size.height / 2{
                player.position.y = player.size.height / 2
            }
            
        }
        
    }

}