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
    static let mainDuck : UInt32 = 0x1 << 1
    static let ground : UInt32 = 0x1 << 2
    static let wall : UInt32 = 0x1 << 3
    static let scoreGoal : UInt32 = 0x1 << 4
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var textureAtlas = SKTextureAtlas()
    var textureArray = [SKTexture]()
    
    var mainDuck = SKSpriteNode()
    
    var ground = SKSpriteNode()
   // var mainDuck = SKSpriteNode()
    var  wallPair = SKNode()
    var moveAndRemove = SKAction()
    var gameStarted = Bool()
    var gameTimer:Timer!
    var gameOver = Bool()
    var startOver = SKSpriteNode()
    var cloud:SKEmitterNode!
    
    
    
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
        
        cloud = SKEmitterNode(fileNamed: "clouds")
        cloud.position = CGPoint(x: 350, y: 0)
        
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.position = CGPoint(x: -5, y: self.frame.size.height - 870)
        scoreLabel.fontName = "Futura-CondensedExtraBold"
        scoreLabel.fontSize = 125
        scoreLabel.fontColor = UIColor.white
        scoreLabel.zPosition = 4
        self.addChild(scoreLabel)
        
        textureAtlas = SKTextureAtlas(named:"duck")
        
        for i in 1...textureAtlas.textureNames.count - 1{
            let Name = "duck_\(i).png"
            textureArray.append(SKTexture(imageNamed: Name))
        }
        
        mainDuck = SKSpriteNode(imageNamed: "duck_0")
      
        mainDuck.run(SKAction.repeatForever(SKAction.animate(with: textureArray, timePerFrame: 0.1)))
     
        
       // mainDuck = SKSpriteNode(imageNamed: "duck")
        mainDuck.size = CGSize(width: 180, height: 180)
        mainDuck.position = CGPoint(x: self.frame.width / 50 - mainDuck.frame.width, y: -100 )
        mainDuck.physicsBody = SKPhysicsBody(circleOfRadius: mainDuck.frame.height / 4.5)
        mainDuck.physicsBody?.categoryBitMask = physicsCategory.mainDuck
        mainDuck.physicsBody?.collisionBitMask = physicsCategory.ground | physicsCategory.wall
        mainDuck.physicsBody?.contactTestBitMask = physicsCategory.ground | physicsCategory.wall | physicsCategory.scoreGoal
        mainDuck.physicsBody?.affectedByGravity = false
        mainDuck.physicsBody?.isDynamic = true
        
        mainDuck.zPosition = 2
        self.addChild(mainDuck)
    
        
        
        
        ground = SKSpriteNode(imageNamed: "ground")
        ground.setScale(0.8)
        ground.position = CGPoint(x: self.frame.width / 24 ,y: -630)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.categoryBitMask = physicsCategory.ground
        ground.physicsBody?.collisionBitMask = physicsCategory.mainDuck
        ground.physicsBody?.contactTestBitMask = physicsCategory.mainDuck
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        
        ground.zPosition = 4
        
        self.addChild(ground)
        self.addChild(cloud) 
      
        
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
        
        if firstBody.categoryBitMask == physicsCategory.scoreGoal && secondBody.categoryBitMask == physicsCategory.mainDuck || firstBody.categoryBitMask == physicsCategory.mainDuck && secondBody.categoryBitMask == physicsCategory.scoreGoal{
            
                
            score += 1
            print(score)
        }
        
        if firstBody.categoryBitMask == physicsCategory.wall && secondBody.categoryBitMask == physicsCategory.mainDuck || firstBody.categoryBitMask == physicsCategory.mainDuck && secondBody.categoryBitMask == physicsCategory.wall{
            
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
        
        topWall.position = CGPoint(x: self.frame.size.width, y: position + 460)
        topWall.zRotation = 3.14
        bottomWall.position = CGPoint(x: self.frame.size.width, y: position - 610)
        
        
        
        topWall.setScale(0.8)
        bottomWall.setScale(0.8)
    
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = physicsCategory.wall
        topWall.physicsBody?.collisionBitMask = physicsCategory.mainDuck
        topWall.physicsBody?.contactTestBitMask = physicsCategory.mainDuck
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        bottomWall.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.size)
        bottomWall.physicsBody?.categoryBitMask = physicsCategory.wall
        bottomWall.physicsBody?.collisionBitMask = physicsCategory.mainDuck
        bottomWall.physicsBody?.contactTestBitMask = physicsCategory.mainDuck
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
             //self.run(SKAction.playSoundFileNamed("intergalactic", waitForCompletion: false))
            gameStarted = true
            
            mainDuck.physicsBody?.affectedByGravity = true
            
            gameTimer = Timer.scheduledTimer(timeInterval: 1.6, target: self, selector: #selector(createWalls), userInfo: nil, repeats: true)
            
            self.createWalls()
            
        }
        else{
            
            if gameOver == true{
                
             
                
            }
            else{
                mainDuck.physicsBody?.velocity = CGVector(dx:0, dy:-5)
                mainDuck.physicsBody?.applyImpulse(CGVector(dx:0, dy:158))
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
