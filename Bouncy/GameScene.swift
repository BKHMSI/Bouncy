//
//  GameScene.swift
//  Bouncy
//
//  Created by Badr AlKhamissi on 3/12/16.
//  Copyright (c) 2016 Badr AlKhamissi. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var isFingerOnBall = false
    var frames:Int = 1
    var level = 11
 
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        physicsWorld.contactDelegate = self
        initLevel(level);
        createBoundary()
    }
    
    func initLevel(level:Int){
        let location = NSBundle.mainBundle().pathForResource("Levels/L\(level)", ofType: "txt")
        let fileContents = (try! NSString(contentsOfFile: location!, encoding: NSUTF8StringEncoding)) as String!
        let rows = fileContents.componentsSeparatedByString("\n")
        frames = Int(rows[0])!
        
        for y in 1 ..< rows.count {
            let column = rows[y].componentsSeparatedByString(",")
            for x in 0 ..< column.count {
                if column[x] == "1"{
                    let blockBorder = CGRectMake(CGFloat(x*16), CGFloat((frames*70-y)*8), 120, 45)
              
                    let block = SKSpriteNode(imageNamed: "block.png")
                    block.anchorPoint = CGPoint(x: 0, y: 0)
                    block.position = CGPoint(x: x*16, y: (frames*70-y)*8)
                    block.size = CGSize(width: 120, height: 45)
                    block.zPosition = 10
                    block.physicsBody?.categoryBitMask = DestinationCategory

                    
                    let blockPhys = SKNode()
                    blockPhys.physicsBody = SKPhysicsBody(edgeLoopFromRect: blockBorder)
                    
                    if let physics = blockPhys.physicsBody {
                        physics.affectedByGravity = false
                        physics.allowsRotation = false
                        physics.dynamic = false;
                        physics.restitution = 0.2
                        physics.friction = 0.2
                        physics.linearDamping = 0.1
                        physics.angularDamping = 0.1
                    }
                    addChild(block)
                    addChild(blockPhys)
                }
            }
        }
    }
    
    func createBoundary(){
        let borderBody = SKPhysicsBody(edgeLoopFromRect: CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height*CGFloat(frames)))
        borderBody.friction = 0
        
        let bottomRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 45)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        addChild(bottom)
        
        let ball = childNodeWithName(BallCategoryName) as! SKSpriteNode
        self.physicsBody = borderBody
        ball.physicsBody!.categoryBitMask = BallCategory
        ball.physicsBody?.contactTestBitMask = DestinationCategory

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
        if isFingerOnBall {
            // Get touch location
            let touch = touches.first
            let touchLocation = touch!.locationInNode(self)
            let previousLocation = touch!.previousLocationInNode(self)
            
            let ball = childNodeWithName(BallCategoryName) as! SKSpriteNode
            
            let dx = touchLocation.x - previousLocation.x
            let dy = touchLocation.y - previousLocation.y
            if(dy<=5){
                let mag = CGFloat(2)
                ball.physicsBody!.applyImpulse(CGVectorMake(mag*dx, mag*dy))
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isFingerOnBall = false
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let ball = childNodeWithName(BallCategoryName) as! SKSpriteNode
        let camera = childNodeWithName("Camera") as! SKCameraNode
        if(ball.position.y>320 && ball.position.y<frame.height*CGFloat(frames)-320){
            let action = SKAction.moveToY(ball.position.y, duration: 0.25);
            camera.runAction(action)
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        let ball = childNodeWithName(BallCategoryName) as! SKSpriteNode
        ball.texture = SKTexture(imageNamed: "ball.png");
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let ball = childNodeWithName(BallCategoryName) as! SKSpriteNode
        ball.texture = SKTexture(imageNamed: "ball2.png");
    }
}
