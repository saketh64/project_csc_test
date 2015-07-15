//
//  Person.swift
//  ProjectRainbewbs
//
//  Created by Calvin Pelletier on 6/16/15.
//  Copyright (c) 2015 CSK. All rights reserved.
//

import SpriteKit
import MultipeerConnectivity

class Person: SKSpriteNode {
    
    //VALUES FOR GAME MECHANICS
    private var runningSpeed = CGFloat(0.3) //speed before width adjustments
    private var tumbleDistance = CGFloat(0.12) //tumble distance before width adjustments
    private var teleDistance = CGFloat(0.12)
    private let teleAnimationSize = CGFloat(0.03)
    
    
    private var armYOffsetWhenSwordDown: CGFloat!
    private var armYOffsetWhenSwordUp: CGFloat!
    private var armXOffset: CGFloat!
        
   
    
    //GLOBAL VARIABLES
    var inMotion = false
    var onGround = true
    var direction = "right"
    var swordUp = true //used for checking whether sword is down or up
    var hasSword = true
    var slashing = false
    var teleporting = false
    var dead = false
    var inDefense = false
    var isHero = false
    
    
    //REFERENCES TO OTHER OBJECTS
    var mySword: Sword! = nil
    var arm: SKSpriteNode!
    var myScene: GameScene!
    var myEnemy: Person! = nil
    var myEnergyBar: EnergyBar! = nil
    
    //TEXTURE STUFF
    //still textures
    private let textureWithSword = SKTexture(imageNamed: "person_with_sword")
    private let textureWithoutSword = SKTexture(imageNamed: "person_without_sword")
    
    //cooldown textures
    private let numCooldownFrames = 8
    private var cooldownFrames = [SKTexture]()
    
    //running textures
    private let numFrames = 9 //number of running animation frames, not including the standing image
    private var runningFramesWithSword = [SKTexture]() //array of textures for the frames
    private var runningFramesWithoutSword = [SKTexture]()
    private let timePerRunFrame = CGFloat(0.04)
    private var activeRunningFrames = [SKTexture]() //set equal to one of the other frame arrays depending on state of sword
    
    //tumble textures
    let numTumbleFrames = 7 //number of tumble animation frames
    private var tumbleFrames = [SKTexture]()
    let timePerTumbleFrame = CGFloat(0.1)
    
    //slash textures
    let numInitialSlashFrames = 5 //first half of slash animation, contact occurs after this animation completes
    private var initialSlashUpFrames = [SKTexture]()
    private var initialSlashDownFrames = [SKTexture]()
    let timePerInitialSlashFrame = CGFloat(0.05)
    let numReturnSlashFrames = 5 //second half of slash animation, user can slash again once this completes
    private var returnSlashUpFrames = [SKTexture]()
    private var returnSlashDownFrames = [SKTexture]()
    let timePerReturnSlashFrame = CGFloat(0.1)
    
    //dying textures
    private let numDyingFrames = 5 //dying animation
    private var dyingFrames = [SKTexture]()
    private let timePerDyingFrame = CGFloat(0.1)
    
    //teleport textures
    private let numTeleFrames = 3 //teleport animation
    private var teleFrames = [SKTexture]()
    private var teleFramesBackwards = [SKTexture]()
    private let timePerTeleFrames = CGFloat(0.1)
    
    init(sceneObject: SKScene, sceneSize: CGSize) {
        super.init(texture: textureWithSword, color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: CGSizeMake(sceneSize.width * personWidth, sceneSize.width * personWidth * 2)) //initialize
        
        myScene = sceneObject as! GameScene
        
        //ADJUST VALUES FOR GAME MECHANICS
        runningSpeed *= sceneSize.width //speed after width adjustments (so speed stays constant regardless of device)
        tumbleDistance *= sceneSize.width //tumble distance after width adjustments
        teleDistance *= sceneSize.width
        
        
        //ARM STUFF
        armYOffsetWhenSwordUp = self.size.height / 6
        armYOffsetWhenSwordDown = self.size.height / -12
        armXOffset = self.size.width / -7
        arm = SKSpriteNode(texture: SKTexture(imageNamed: "sword_up"), color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: CGSizeMake(sceneSize.width * armWidth, sceneSize.width * armWidth))
        arm.anchorPoint = CGPointMake(0.0, 0.5)
        arm.position = CGPointMake(armXOffset, armYOffsetWhenSwordUp)
        self.addChild(arm)
        
        
        //PHYSICS STUFF
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size) //give person physics
        self.physicsBody?.mass = CGFloat(1.0) //ALWAYS INITIALIZE MASS TO KEEP PHYSICS CONSTANT REGARDLESS OF SIZE
        self.physicsBody?.allowsRotation = false //doesnt spin when a torque is applied (precautionary)
        self.physicsBody?.usesPreciseCollisionDetection = true //because sprite is an odd shape
        self.physicsBody?.affectedByGravity = true //gravity is defined in GameScene.swift
        self.physicsBody?.restitution = CGFloat(0.0) //so he doesn't bounce
        self.physicsBody?.friction = CGFloat(0.0) //so he doesn't slow down
        self.physicsBody?.linearDamping = CGFloat(0.0)
        //COLLISION STUFF IS EXPLAINED AT THE TOP OF GAMESCENE.SWIFT
        self.physicsBody?.categoryBitMask = CollisionCategory.Person //collision category (defined at beginning of GameScene.swift
        self.physicsBody?.collisionBitMask = CollisionCategory.Ground | CollisionCategory.Person  //stop person when in contact with ground
        self.physicsBody?.contactTestBitMask = CollisionCategory.Ground | CollisionCategory.Trophy //used for updating onGround (in GameScene.swift)
        
        //ADDING IMAGES TO TEXTURE ARRAYS
        //running
        for var i=1;i<=numFrames;i++ {
            runningFramesWithSword.append(SKTexture(imageNamed: "person\(i)ws"))
        }
        for var i=1;i<=numFrames;i++ {
            runningFramesWithoutSword.append(SKTexture(imageNamed: "person\(i)"))
        }
        activeRunningFrames = runningFramesWithSword
        //tumbling
        for var i=1;i<=numTumbleFrames;i++ {
            tumbleFrames.append(SKTexture(imageNamed: "tumble\(i)"))
        }
        //slashing
        for var i=1;i<=numInitialSlashFrames;i++ {
            initialSlashUpFrames.append(SKTexture(imageNamed: "initial_slash_up\(i)"))
            initialSlashDownFrames.append(SKTexture(imageNamed: "initial_slash_down\(i)"))
        }
        for var i=1;i<=numReturnSlashFrames;i++ {
            returnSlashUpFrames.append(SKTexture(imageNamed: "return_slash_up\(i)"))
            returnSlashDownFrames.append(SKTexture(imageNamed: "return_slash_down\(i)"))
        }
        //dying
        for var i=1;i<=numDyingFrames;i++ {
            dyingFrames.append(SKTexture(imageNamed: "dying\(i)"))
        }
        //teleporting
        for var i=1;i<=numTeleFrames;i++ {
            teleFrames.append(SKTexture(imageNamed: "tele\(i)"))
        }
        for var i=numTeleFrames;i>=1;i-- {
            teleFramesBackwards.append(SKTexture(imageNamed: "tele\(i)"))
        }
        //cooldown
        for var i=0;i<numCooldownFrames;i++ {
            cooldownFrames.append(SKTexture(imageNamed: "cooldown\(i)"))
        }
    }
    
    //MOVEMENT
    func updateMovement(joystickDirection: String) {
        if dead {
            return
        }
        
        if joystickDirection == "left" && !inMotion { //check if already in motion as to not repeatedly apply an impulse
            inMotion = true
            self.physicsBody?.applyImpulse(CGVectorMake(runningSpeed * CGFloat(-1.0), 0.0))
            self.xScale = fabs(self.xScale) * CGFloat(-1.0) //turn the image in the proper direction
            direction = "left"
            if self.actionForKey("runningAnimation") == nil {
                animate() //running animation
            }
        }
        
        if joystickDirection == "right" && !inMotion { //same but for right
            inMotion = true
            self.physicsBody?.applyImpulse(CGVectorMake(runningSpeed, 0.0))
            self.xScale = fabs(self.xScale)
            direction = "right"
            if self.actionForKey("runningAnimation") == nil {
                animate()
            }
        }
        
        if joystickDirection == "stop" && onGround { //stop if direction == "none" and person is onGround. the later is because it would look silly for the person to just stop himself horizontally while he's in the air
            inMotion = false
            self.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
            self.removeActionForKey("runningAnimation") //stop animation
            if hasSword {
                self.texture = textureWithSword
            } else {
                self.texture = textureWithoutSword
            }
        }
    }
    //DEFENDING 
    func defend() {
        if slashing || teleporting {
            return
        }
        self.texture = textureWithSword
        self.arm.texture = SKTexture(imageNamed: "initial_slash_up2.png")
        inDefense = true
    }
    
    func stopDefending() {
        self.texture = textureWithSword
        self.arm.texture = SKTexture(imageNamed: "sword_up.png")
        inDefense = false
    }
    
    //SLASHING
    func slash() {
        if  !hasSword ||  dead || slashing || teleporting || inDefense {
            return
        }
        
        slashing = true
        
        self.startRunning(direction)
        self.runAction(SKAction.waitForDuration(0.5)) { () -> Void in
            self.updateMovement("stop")
            if self.swordUp {
            self.arm.runAction(SKAction.animateWithTextures(self.initialSlashUpFrames, timePerFrame: NSTimeInterval(self.timePerInitialSlashFrame), resize: false, restore: true), completion: self.slashInitialAnimationEnded)
            } else {
                self.arm.runAction(SKAction.animateWithTextures(self.initialSlashDownFrames, timePerFrame: NSTimeInterval(self.timePerInitialSlashFrame), resize: false, restore: true), completion: self.slashInitialAnimationEnded)
            }
        }
        
    }
    func slashInitialAnimationEnded() {
        let distance = self.position.x - (myEnemy?.position.x)!
        if (direction == "left" && (distance > CGFloat(0.0) && distance < armsReach * self.size.width)) || (direction == "right" && (distance < CGFloat(0.0) && distance > CGFloat(armsReach * self.size.width * -1))) { //first check if within distance
            if (!myEnemy.inDefense) { //then check if not blocked
                myEnemy?.myEnergyBar.updateBar()
            }

        }
        arm.runAction(SKAction.animateWithTextures(returnSlashUpFrames, timePerFrame: NSTimeInterval(timePerReturnSlashFrame), resize: false, restore: true), completion: slashReturnAnimationEnded)
    }
    func slashReturnAnimationEnded() {
        slashing = false
    }
    
        //TELEPORTING
    func tele(cooldownHidden: Bool) {
        if dead || slashing || inDefense {
            return
        }
        teleporting = true
        
        let teleStart = SKSpriteNode(texture: SKTexture(imageNamed: "tele1"), color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: CGSizeMake(myScene.size.width * teleAnimationSize, myScene.size.width * teleAnimationSize))
        teleStart.position = self.position
        myScene.addChild(teleStart)
        teleStart.runAction(SKAction.animateWithTextures(teleFramesBackwards, timePerFrame: NSTimeInterval(timePerTeleFrames), resize: false, restore: true)) { () -> Void in
            teleStart.removeFromParent()
        }
        
        
        var newPosition = position.x - teleDistance
        if newPosition < self.size.width / 2 {
            newPosition = self.size.width / 2
        }
        position.x = newPosition
            
        let teleFinish = SKSpriteNode(texture: SKTexture(imageNamed: "tele1"), color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: CGSizeMake(myScene.size.width * teleAnimationSize, myScene.size.width * teleAnimationSize))
        teleFinish.position = self.position
        myScene.addChild(teleFinish)
        teleFinish.runAction(SKAction.animateWithTextures(teleFrames, timePerFrame: NSTimeInterval(timePerTeleFrames), resize: false, restore: true)) { () -> Void in
            teleFinish.removeFromParent()
        }
        
        teleporting = false
    }

    
   

    
    //OTHER ACTIONS
    func die() {
        if dead {
            return
        }
        self.updateMovement("stop")
        self.dead = true
        self.arm.hidden = true
        self.removeAllActions()
        self.physicsBody?.categoryBitMask = UInt32(0)
        self.runAction(SKAction.animateWithTextures(dyingFrames, timePerFrame: NSTimeInterval(timePerDyingFrame), resize: false, restore: false))
    }
    
    func hardChangePosition(coords: CGPoint) {
        self.position = coords
    }
    
    func turnLeft() {
        stopRunning()
        self.xScale = fabs(self.xScale) * CGFloat(-1.0)
        self.direction = "left"
    }
    
    func turnRight() {
        stopRunning()
        self.xScale = fabs(self.xScale)
        self.direction = "right"
    }
    
    func startRunning(inDirection: String) {
        self.updateMovement(inDirection)
    }
    
    func stopRunning() {
        self.updateMovement("stop")
    }
    
    func animate() {
        self.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(activeRunningFrames, timePerFrame: NSTimeInterval(timePerRunFrame), resize: false, restore: true)), withKey: "runningAnimation")
        
    }
    
    required init?(coder aDecoder: NSCoder) { //this needs to be added to avoid a compiler error
        fatalError("This error should never occur. Congratulations.")
    }
}
