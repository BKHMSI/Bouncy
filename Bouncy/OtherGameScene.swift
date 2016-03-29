//
//  OtherGameScene.swift
//  Bouncy
//
//  Created by Badr AlKhamissi on 3/12/16.
//  Copyright © 2016 Badr AlKhamissi. All rights reserved.
//

import UIKit
import SpriteKit

class OtherGameScene: SKScene, SKPhysicsContactDelegate {
    
    var isFingerOnBall = false
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        super.didMoveToView(view)
        createBoundary()
        setCategories()
    }
    
    func createBoundary(){
        // Create a physics body that borders the screen
        let borderBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height*2))
        
        borderBody.friction = 0
        
        let bottomRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 45)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        addChild(bottom)
        
        let ball = childNodeWithName(BallCategoryName) as! SKSpriteNode
        self.physicsBody = borderBody
        ball.physicsBody!.categoryBitMask = BallCategory
        physicsWorld.contactDelegate = self

    }
    
    
    func setCategories(){
        let ball = childNodeWithName(BallCategoryName) as! SKSpriteNode
        let destination = childNodeWithName(DestinationName) as! SKSpriteNode
        ball.physicsBody!.categoryBitMask = BallCategory
        destination.physicsBody!.categoryBitMask = DestinationCategory
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        let touch = touches.first
        let touchLocation = touch!.locationInNode(self)
        
        if let body = physicsWorld.bodyAtPoint(touchLocation) {
            if body.node!.name == BallCategoryName {
                isFingerOnBall = true
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 1. Check whether user touched the paddle
        if isFingerOnBall {
            // 2. Get touch location
            let touch = touches.first
            let touchLocation = touch!.locationInNode(self)
            let previousLocation = touch!.previousLocationInNode(self)
            
            // 3. Get node for paddle
            let ball = childNodeWithName(BallCategoryName) as! SKSpriteNode
            
            let dx = touchLocation.x - previousLocation.x
            let dy = touchLocation.y - previousLocation.y
            let mag = CGFloat(2)
            ball.physicsBody!.applyImpulse(CGVectorMake(mag*dx, mag*dy))
            
        }
    }
    
    // MARK: Contact Delegate
    
    func didBeginContact(contact: SKPhysicsContact) {
        // 1. Create local variables for two physics bodies
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        // 2. Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 3. react to the contact between ball and bottom
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == DestinationCategory {
            print("Reached Distantion")
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isFingerOnBall = false
    }
    
    override func update(currentTime: CFTimeInterval) {
        let ball = childNodeWithName(BallCategoryName) as! SKSpriteNode
        let camera = childNodeWithName("Camera") as! SKCameraNode
        if(ball.position.y>320 && ball.position.y<frame.height*2-320){
            let action = SKAction.moveToY(ball.position.y, duration: 0.25);
            camera.runAction(action)
        }
    }
}
