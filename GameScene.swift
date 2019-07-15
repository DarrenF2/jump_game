//
//  GameScene.swift
//  JumpGame
//
//  Created by Darren Freeman on 5/23/19.
//  Copyright © 2019 Darren Freeman. All rights reserved.
//

import SpriteKit
import GameplayKit

struct physicsCategory {
    static let ship : UInt32 = 0x1 << 1
    static let ground : UInt32 = 0x1 << 2
    static let wall : UInt32 = 0x1 << 3
    static let scoreGoal : UInt32 = 0x1 << 4
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ground = SKSpriteNode()
    var ship = SKSpriteNode()
    var  wallPair = SKNode()
    var moveAndRemove = SKAction()
    var gameStarted = Bool()
    var gameTimer:Timer!
    var gameOver = Bool()
    var startOver = SKSpriteNode()
    
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        self.removeFromParent()
        gameOver = false
        gameStarted = false
        score = 0
        createScene()
    
    }
    
    func createScene(){
        
        self.physicsWorld.contactDelegate = self
        
        
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.position = CGPoint(x: -5, y: self.frame.size.height - 870)
        scoreLabel.fontName = "Futura-CondensedExtraBold"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = UIColor.white
        scoreLabel.zPosition = 4
        self.addChild(scoreLabel)
        
        ship = SKSpriteNode(imageNamed: "redship")
        ship.size = CGSize(width: 110, height: 120)
        ship.zRotation = -1.57
        ship.position = CGPoint(x: self.frame.width / 50 - ship.frame.width, y: -100 )
        
        ship.physicsBody = SKPhysicsBody(circleOfRadius: ship.frame.height / 4)
        ship.physicsBody?.categoryBitMask = physicsCategory.ship
        ship.physicsBody?.collisionBitMask = physicsCategory.ground | physicsCategory.wall
        ship.physicsBody?.contactTestBitMask = physicsCategory.ground | physicsCategory.wall | physicsCategory.scoreGoal
        ship.physicsBody?.affectedByGravity = false
        ship.physicsBody?.isDynamic = true
        
        ship.zPosition = 2
        
        self.addChild(ship)
        
        
        
        
        ground = SKSpriteNode(imageNamed: "ground")
        ground.setScale(0.8)
        ground.position = CGPoint(x: self.frame.width / 24 ,y: -630)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.categoryBitMask = physicsCategory.ground
        ground.physicsBody?.collisionBitMask = physicsCategory.ship
        ground.physicsBody?.contactTestBitMask = physicsCategory.ship
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        
        ground.zPosition = 4
        
        self.addChild(ground)
        
      
        
    }
    
    var score : Int = 0{
        didSet {
            scoreLabel.text = " \(score)"
        }
    }
    var scoreLabel : SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        createScene()
      
 
    }
    func createButton(){
        startOver = SKSpriteNode(imageNamed: "reset_button5")
        startOver.position = CGPoint(x: self.frame.width / 55, y: self.frame.height / 50)
        startOver.zPosition = 8
        startOver.setScale(1.5)
        self.addChild(startOver)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == physicsCategory.scoreGoal && secondBody.categoryBitMask == physicsCategory.ship || firstBody.categoryBitMask == physicsCategory.ship && secondBody.categoryBitMask == physicsCategory.scoreGoal{
            
            self.run(SKAction.playSoundFileNamed("goal_sound1", waitForCompletion: false))
                
            score += 1
            print(score)
        }
        
        if firstBody.categoryBitMask == physicsCategory.wall && secondBody.categoryBitMask == physicsCategory.ship || firstBody.categoryBitMask == physicsCategory.ship && secondBody.categoryBitMask == physicsCategory.wall{
            
            gameOver = true
            createButton()
        }
    }
   
    @objc func createWalls(){
        
        let scoreGoal = SKSpriteNode()
        
        
        scoreGoal.size = CGSize(width: 1, height: 1000)
        scoreGoal.position = CGPoint(x: self.frame.width, y: self.frame.height / 10)
        
        scoreGoal.physicsBody = SKPhysicsBody(rectangleOf: scoreGoal.size)
        scoreGoal.physicsBody?.affectedByGravity = false
        scoreGoal.physicsBody?.isDynamic = false
        scoreGoal.physicsBody?.categoryBitMask = physicsCategory.scoreGoal
        scoreGoal.physicsBody?.collisionBitMask = 0
        scoreGoal.physicsBody?.contactTestBitMask = physicsCategory.scoreGoal
       // scoreGoal.color = SKColor.red

        
        
        let  wallPair = SKSpriteNode()
      
        
        let topWall = SKSpriteNode(imageNamed:"shaded_pillar_lower1")
        let bottomWall = SKSpriteNode(imageNamed:"shaded_pillar_lower1")
    
        let randomWallPosition = GKRandomDistribution(lowestValue: -200, highestValue: 400)
        let position = CGFloat(randomWallPosition.nextInt())
        
        topWall.position = CGPoint(x: self.frame.size.width, y: position + 480)
        topWall.zRotation = 3.14
        bottomWall.position = CGPoint(x: self.frame.size.width, y: position - 590)
        
        
        
        topWall.setScale(0.8)
        bottomWall.setScale(0.8)
    
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = physicsCategory.wall
        topWall.physicsBody?.collisionBitMask = physicsCategory.ship
        topWall.physicsBody?.contactTestBitMask = physicsCategory.ship
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)
        bottomWall.physicsBody?.categoryBitMask = physicsCategory.wall
        bottomWall.physicsBody?.collisionBitMask = physicsCategory.ship
        bottomWall.physicsBody?.contactTestBitMask = physicsCategory.ship
        bottomWall.physicsBody?.isDynamic = false
        bottomWall.physicsBody?.affectedByGravity = false
 
          wallPair.zPosition = 3
        wallPair.addChild(topWall)
        wallPair.addChild(bottomWall)
        wallPair.addChild(scoreGoal)
        
      
    
     
        
      //  let randomPosition = CGFloat.random(min: -0.8, max: 2)
       // wallPair.position.y = wallPair.position.y + randomPosition

        let animationDuration:TimeInterval = 2.2
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: -1200, y: 0), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        wallPair.run(SKAction.sequence(actionArray))
        
        self.addChild(wallPair)
        
       
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false{
             self.run(SKAction.playSoundFileNamed("intergalactic", waitForCompletion: false))
            gameStarted = true
            
            ship.physicsBody?.affectedByGravity = true
            
            gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createWalls), userInfo: nil, repeats: true)
            
            self.createWalls()
            
        }
        else{
            
            if gameOver == true{
                
             
                
            }
            else{
                ship.physicsBody?.velocity = CGVector(dx:0, dy:0)
                ship.physicsBody?.applyImpulse(CGVector(dx:0, dy:80))
            }
        }
       
        for touch in touches{
            let location = touch.location(in: self)
            
            if gameOver == true{
                if startOver.contains(location){}
                restartScene()
                gameTimer.invalidate()
                
                
            }
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
