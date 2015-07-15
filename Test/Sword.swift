//
//  Sword.swift
//  ProjectRainbewbs
//
//  Created by Calvin Pelletier on 6/19/15.
//  Copyright © 2015 CSK. All rights reserved.
//

import SpriteKit
import MultipeerConnectivity

class Sword: SKSpriteNode {
    
    private var myWielder: Person!
    var myScene: GameScene!
    
    private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    private let swordWidth = CGFloat(0.4)
    private var onGround = false
    
    init(sceneSize: CGSize, wielder: Person, myScene: GameScene) {
        myWielder = wielder
        self.myScene = myScene
        
        super.init(texture: SKTexture(imageNamed: "sword"), color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: CGSizeMake(sceneSize.width * swordWidth * personWidth, sceneSize.width * swordWidth * personWidth * 2)) //initialize. color doesnt matter.
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.mass = CGFloat(0.1)
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.categoryBitMask = CollisionCategory.Sword
        self.physicsBody?.collisionBitMask = CollisionCategory.GroundAndPerson
        self.physicsBody?.contactTestBitMask = CollisionCategory.GroundAndPerson
        self.physicsBody?.usesPreciseCollisionDetection = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*func land() {
        self.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
        self.removeActionForKey("rotating")
        onGround = true
    }
    
    func checkCollision(owner: Person, enemy: Person) {
        if let bodies: NSArray = self.physicsBody?.allContactedBodies() {
            for body in bodies {
                if body.node == owner {
                    myWielder.pickUpSword()
                }
                if body.node == enemy {
                    if !myWielder.myEnemy.swordUp && myWielder.swordUp || !myWielder.swordUp && myWielder.myEnemy.swordUp || ((myWielder.position.x < myWielder.myEnemy.position.x) && myWielder.myEnemy.direction == "right") || ((myWielder.position.x > myWielder.myEnemy.position.x) && myWielder.myEnemy.direction == "left") || (!myWielder.myEnemy.hasSword){
                        myWielder.myEnemy?.die()
                    }
                }
                if body.node??.name == "ground" {
                    self.land()
                }
            }
        }
    }*/
}
