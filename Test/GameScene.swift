//
//  GameScene.swift
//  Test
//
//  Created by Saketh Undurty on 7/15/15.
//  Copyright (c) 2015 Saketh Undurty. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var player1: Person! = nil
    var player2: Person! = nil
    var ground: Ground! = nil
    var ai: AI! = nil
    var defenseNode: SKSpriteNode! = nil
    var player1Bar: EnergyBar! = nil
    var player2Bar: EnergyBar! = nil
    
    var inRange = true
    var defenseObject: AnyObject! = nil

    
    private let gravityMultiplier = CGFloat(-0.001)
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: gravityMultiplier * self.size.height)
        
        ground = Ground(sceneSize: self.size) //new ground object
        ground.position = CGPointMake(self.size.width / 2, ground.size.height / 2) //position ground (anchor point is in the center of the sprite)
        ground.zPosition = 0
        self.addChild(ground) //add it to the scene
        
        maxDistance = self.size.width * maxDistance
        
        player1 = Person(sceneObject: self, sceneSize: self.size)
        player1.position = CGPointMake(self.size.width / 3, ground.size.height + player1.size.height / 2) //places person in the center of the screen, 15 pixels above the top of the ground
        self.addChild(player1)
        
        player2 = Person(sceneObject: self, sceneSize: self.size)
        player2.position = CGPointMake(self.size.width - self.size.width / 3, ground.size.height + player2.size.height / 2) //places person in the center of the screen, 15 pixels above the top of the ground
        player2.turnLeft()
        self.addChild(player2)
        
        player1.myEnemy = player2
        player2.myEnemy = player1
        
        ai = AI(sceneSize: self.size, level: "easy", host: player2, hero: player1)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.restitution = CGFloat(0.0)
        
        defenseNode = SKSpriteNode(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(self.size.width / 4, self.size.height))
        defenseNode.position = CGPointMake(0, ground.size.height)
        defenseNode.name = "defenseNode"
        defenseNode.zPosition = 0
        self.addChild(defenseNode)

        player1Bar = EnergyBar(sceneSize: self.size, person: player1, difficulty: 0.1)
        player1Bar.position = CGPointMake(0, self.size.height * 0.95)
        player1.myEnergyBar = player1Bar
        self.addChild(player1Bar)
        
        player2Bar = EnergyBar(sceneSize: self.size, person: player2, difficulty: 0.07)
        player2Bar.position = CGPointMake(self.size.width * 0.6, self.size.height * 0.95)
        player2.myEnergyBar = player2Bar
        self.addChild(player2Bar)
        
        
        let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedRight:"))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        
        
        let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("swipedLeft:"))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        for touch in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)

            if touchedNode.name == "defenseNode" {
                player1.defend()
                defenseObject = touch
            }
        }
      
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            if touch.isEqual(defenseObject) {
                player1.stopDefending()
            }
        }
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if fabs(player1.position.x - player2.position.x) > maxDistance && !inRange{
            self.runAction(SKAction.waitForDuration(2), completion: { () -> Void in
                if (fabs(self.player1.position.x - self.player2.position.x) > maxDistance) {
                    self.player1.updateMovement("right")
                    self.player2.updateMovement("left")
                }
            })
            self.inRange = true
            
            
        }
        
        if fabs(player1.position.x - player2.position.x) <= maxDistance && inRange {
            self.inRange = false
            player1.updateMovement("stop")
            player2.updateMovement("stop")
        }
        
       
       
       
        
        
    }
    func swipedRight(sender:UISwipeGestureRecognizer){
        player1.slash()
    }
    
    func swipedLeft(sender:UISwipeGestureRecognizer){
        player1.tele(false)
    }
}
