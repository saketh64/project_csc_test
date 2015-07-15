//
//  EnergyBar.swift
//  Blah
//
//  Created by Saketh Undurty on 7/15/15.
//  Copyright © 2015 Saketh Undurty. All rights reserved.
//

import SpriteKit

class EnergyBar: SKSpriteNode {
    
    let barWidth = CGFloat(0.4)
    var myPerson: Person! = nil
    var redBar: SKSpriteNode!
    private var aiDifficulty = CGFloat(0.1) //Lower number means harder difficulty
    
    init(sceneSize: CGSize, person: Person, difficulty: CGFloat) {
        
        super.init(texture: nil, color: UIColor.greenColor(), size: CGSizeMake(sceneSize.width * barWidth, sceneSize.width * barWidth * 0.1))
        self.anchorPoint = CGPointMake(0, 0)
        myPerson = person
        aiDifficulty = difficulty
        redBar = SKSpriteNode(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(0, sceneSize.width * barWidth * 0.1))
        redBar.anchorPoint = CGPointMake(0, 0)
        self.addChild(redBar)
    }
    
    func updateBar() {
        let redBarWidth = redBar.size.width + (myPerson.myScene.size.width * aiDifficulty)
        redBar.size.width = redBarWidth
        redBar.color = UIColor.redColor()
        print(redBar.size.width)
        print(self.size.width)
        if (redBarWidth >= self.size.width ) {
            myPerson.die()
            print("reached")
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}