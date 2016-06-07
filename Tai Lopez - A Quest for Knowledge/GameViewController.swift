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
        let musicPath = NSBundle.mainBundle().pathForResource("backingAudio", ofType: "mp3")
        let musicNSURL = NSURL(fileURLWithPath: musicPath!)
        
        do { bgMusic = try AVAudioPlayer(contentsOfURL: musicNSURL) }
        catch { return print("Cannot find the damn mixtape!") }
        
        bgMusic.numberOfLoops = -1
        bgMusic.volume = 0.5
        bgMusic.play()

        let scene = MenuScene(size: CGSize(width: 1536, height: 2048))
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
        
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
