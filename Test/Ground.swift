//
//  Ground.swift
//  ProjectRainbewbs
//
//  Created by Calvin Pelletier on 6/15/15.
//  Copyright (c) 2015 CSK. All rights reserved.
//

import SpriteKit

class Ground: SKSpriteNode {
    
    init(sceneSize: CGSize) {
        super.init(texture: SKTexture(imageNamed: "ground"), color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: CGSizeMake(sceneSize.width, sceneSize.height * groundHeight)) //initialize
        
        self.name = "ground"
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size) //give ground physics
        self.physicsBody?.usesPreciseCollisionDetection = false //its a rectangle so not needed
        self.physicsBody?.categoryBitMask = CollisionCategory.Ground //the collision group it's part of (defined in GameScene.swift at beginning)
        self.physicsBody?.dynamic = false //can't be moved
        self.physicsBody?.restitution = CGFloat(0.0) //so person doesn't bounce
        self.physicsBody?.friction = CGFloat(0.0) //so person's speed is constant
        
        //this to fix the bug where the person doesn't quite look like he's touching the ground. extends the ground without extending its collision mask. kinda a cop out but whatever.
        let extraGroundHeight = CGFloat(0.02)
        let extraGround = SKSpriteNode(texture: SKTexture(imageNamed: "ground"), color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: CGSizeMake(sceneSize.width, self.size.height * extraGroundHeight))
        extraGround.position = CGPointMake(0, self.size.height / 2)
        self.addChild(extraGround)
    }
    
    required init?(coder aDecoder: NSCoder) { //this needs to be added to avoid a compiler error
        fatalError("This error should never occur. Congratulations.")
    }
}
