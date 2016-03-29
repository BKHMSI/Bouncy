//
//  GameViewController.swift
//  Bouncy
//
//  Created by Badr AlKhamissi on 3/12/16.
//  Copyright (c) 2016 Badr AlKhamissi. All rights reserved.
//

import UIKit
import SpriteKit

let DestinationName = "DestinationBlock"
let BallCategoryName = "Bouncy"
let BallCategory : UInt32 = 0x1 << 0
let DestinationCategory : UInt32 = 0x1 << 1

class GameViewController: UIViewController {

    var level = 0
    let backImg = UIImage(named: "back-button.png") as UIImage?
    
    let lblTimer = UILabel()
    let stopwatch:Stopwatch = Stopwatch()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goToLevel()
        createBackButton()
        createTimerLabel()
        stopwatch.startTimer()
        _ = NSTimer.scheduledTimerWithTimeInterval(stopwatch.timeInterval, target: self, selector: #selector(GameViewController.updateTimerLbl), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        if UIDevice.currentDevice().valueForKey("orientation") as! Int != UIInterfaceOrientation.LandscapeLeft.rawValue {
            UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
        }
    }

    override func shouldAutorotate() -> Bool {
        return false
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

    func createTimerLabel(){
        lblTimer.frame = CGRectMake(view.frame.width-50, 0, 70, 70)
        lblTimer.textColor = UIColor.whiteColor()
        lblTimer.font = UIFont(name: lblTimer.font.fontName, size: 30)
        self.view.addSubview(lblTimer)
    }
    
    
    func updateTimerLbl(){
        lblTimer.text = stopwatch.getTimerString()
    }
    
    func createBackButton(){
        let back = UIButton()
        back.frame = CGRectMake(20, 20, 40, 40)
        back.setBackgroundImage(backImg, forState: UIControlState.Normal)
        back.showsTouchWhenHighlighted = true
        back.addTarget(self, action: #selector(GameViewController.btnBackPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(back)
    }
    
    func btnBackPressed(sender:UIButton){
        self.performSegueWithIdentifier("unwindToMenuSegue", sender: self);
    }
    
    func goToLevel(){
        if(level<=3){
            if let scene = GameScene(fileNamed:"GameScene") {
                // Configure the view.
                let skView = self.view as! SKView
                skView.showsFPS = true
                skView.showsNodeCount = true
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
                scene.level = level+10
                skView.presentScene(scene)
            }
        }else{
            if let scene = OtherGameScene(fileNamed:"OtherGameScene") {
                // Configure the view.
                let skView = self.view as! SKView
                skView.showsFPS = true
                skView.showsNodeCount = true
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
                
                skView.presentScene(scene)
            }
        }
    }
    
}
