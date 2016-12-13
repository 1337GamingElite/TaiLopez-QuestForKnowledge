//
//  GameViewController.swift
//  Tai Lopez - A Quest for Knowledge
//
//  Created by John Marcus Mabanta on 2016-05-24.
//  Copyright (c) 2016 1337GamingElite. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class GameViewController: UIViewController {

    var bgMusic = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loads the Background Audio
        let musicPath = Bundle.main.path(forResource: "backingAudio", ofType: "mp3")
        let musicNSURL = URL(fileURLWithPath: musicPath!)
        
        do { bgMusic = try AVAudioPlayer(contentsOf: musicNSURL) }
        catch { return print("Cannot find the damn mixtape!") }
        
        bgMusic.numberOfLoops = -1
        bgMusic.volume = 0.15
        bgMusic.play()

        let scene = MenuScene(size: CGSize(width: 1536, height: 2048))
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
        
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        
    }
    
    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
