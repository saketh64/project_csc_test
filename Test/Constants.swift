//
//  Constants.swift
//  ProjectRainbewbs
//
//  Created by Saketh Undurty on 6/29/15.
//  Copyright © 2015 CSK. All rights reserved.
//

import Foundation
import SpriteKit


//~~~~~~~~~~~~~BUTTONS (NAVIGATION - GAME OVER, MAIN MENU)~~~~~~~~~~~~~~~~~~~~

struct ButtonWidth {
    static let Large: CGFloat = 0.8
    static let Small: CGFloat = 0.2
    static let ActionBar: CGFloat = 0.1
}
let buttonColor = UIColor.grayColor()
let fontSize = CGFloat(30)
let buttonNodeZ = CGFloat(10)
let buttonTextZ = CGFloat(100)


//~~~~~~~~~~~~~~COLLISION CATEGORIES~~~~~~~~~~~~~~~~~~~~~~~~~

struct CollisionCategory {
    static let Ground: UInt32 = 1
    static let Person: UInt32 = 2
    static let Sword: UInt32 = 4
    static let GroundAndPerson: UInt32 = 3
    static let Walls: UInt32 = 8
    static let Trophy: UInt32 = 16
}
//bit masks work by bit-wise ANDing category bit masks with collision and contact test bit masks. Category bit masks are unique to each object and it must be a power of 2 (1,2,4,8,16). Collision bit masks are used by the physics engine. Contact bit masks are used to populate the allContactedBodies array of SKPhysicsBody objects. I'll use the sword as an example: its bit mask is 100, because thats the next unique power of 2, and its contact bit mask is 011, because it our code needs to be notified when it hits ground (001) and person (010). when, for example, it contacts the person, it ANDs 011 (its contact bit mask) with 010 (the person) and gets a value thats not zero, therefore it adds person to allContactedBodies.


//~~~~~~~~~~~~~~~~PERSON.SWIFT~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

let personWidth = CGFloat(0.04) //person's width as a percentage of scene width. height is calculated from width
let armWidth = CGFloat(0.045)
var armsReach = CGFloat(1.5)
var maxDistance = CGFloat(0.3)


//~~~~~~~~~~~~~~~SWORD.SWIFT~~~~~~~~~~~~~~~~~~~~~~~~~

let swordWidth = CGFloat(0.4) //sizes should be relative to the screen size


//~~~~~~~~~~~~~~~~GROUND.SWIFT~~~~~~~~~~~~~~~~~~~~~~~~

let groundHeight = CGFloat(0.3) //ground height as a percentage of screen height










