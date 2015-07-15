//
//  MainMenu.swift
//  ProjectRainbewbs
//
//  Created by Saketh Undurty on 6/21/15.
//  Copyright © 2015 CSK. All rights reserved.
//

import SpriteKit

class MainMenu: SKScene {
    
    private var buttonWidth = ButtonWidth.Large
        
    override func didMoveToView(view: SKView) {
        
        let backgroundTexture = SKTexture(imageNamed: "mainmenubknd.png")
        let backgroundImage = SKSpriteNode(texture: backgroundTexture, size: view.frame.size)
        backgroundImage.position = view.center
        self.addChild(backgroundImage)
        
        let title = SKLabelNode(fontNamed: "Monoton-Regular")
        title.text = "Title"
        title.fontColor = UIColor.blackColor()
        title.fontSize = 45
        title.position = CGPointMake(self.size.width * CGFloat(0.3), self.size.height * CGFloat(0.15))
        addChild(title)
        
        
        let playButton = SKLabelNode(fontNamed: "Arial")
        playButton.name = "Play"
        playButton.text = "How To Play"
        playButton.fontSize = fontSize
        playButton.position = CGPointMake(self.size.width/2, self.size.height * 0.85 - 10)
        playButton.zPosition = buttonTextZ
        addChild(playButton)
        let playButtonNode = SKShapeNode(rectOfSize: CGSizeMake(self.size.width * buttonWidth, self.size.height*buttonWidth*0.2), cornerRadius: CGFloat(10.0))
        playButtonNode.fillColor = buttonColor
        playButtonNode.position = CGPointMake(self.size.width/2, self.size.height*0.85)
        playButtonNode.name = "tutorialButtonNode"
        playButtonNode.zPosition = buttonNodeZ
        addChild(playButtonNode)
        
        let singlePlayerButton = SKLabelNode(fontNamed: "Arial")
        singlePlayerButton.name = "SinglePlayer"
        singlePlayerButton.text = "Single Player"
        singlePlayerButton.fontSize = fontSize
        singlePlayerButton.position = CGPointMake(self.size.width/2, self.size.height*0.65-10)
        singlePlayerButton.zPosition = buttonTextZ
        addChild(singlePlayerButton)
        let singlePlayerNode = SKShapeNode(rectOfSize: CGSizeMake(self.size.width * buttonWidth, self.size.height*buttonWidth*0.2), cornerRadius: CGFloat(10.0))
        singlePlayerNode.fillColor = buttonColor

        singlePlayerNode.position = CGPointMake(self.size.width/2, self.size.height*0.65)
        singlePlayerNode.name = "singlePlayerNode"
        singlePlayerNode.zPosition = buttonNodeZ
        addChild(singlePlayerNode)
        
        let multiPlayerButton = SKLabelNode(fontNamed: "Arial")
        multiPlayerButton.name = "MultiPlayer"
        multiPlayerButton.text = "Versus"
        multiPlayerButton.fontSize = fontSize
        multiPlayerButton.position = CGPointMake(self.size.width/2, self.size.height*0.45-10)
        multiPlayerButton.zPosition = buttonTextZ
        addChild(multiPlayerButton)
        let multiPlayerNode = SKShapeNode(rectOfSize: CGSizeMake(self.size.width * buttonWidth, self.size.height*buttonWidth*0.2), cornerRadius: CGFloat(10.0))
        multiPlayerNode.fillColor = buttonColor
        multiPlayerNode.position = CGPointMake(self.size.width/2, self.size.height*0.45)
        multiPlayerNode.name = "multiPlayerNode"
        multiPlayerNode.zPosition = buttonNodeZ
        addChild(multiPlayerNode)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(location)
            if touchedNode.name == "singlePlayerNode" || touchedNode.name == "SinglePlayer"{
                let gameScene = GameScene(size: self.size)
                let transition = SKTransition.fadeWithDuration(1.0)
                gameScene.scaleMode = SKSceneScaleMode.AspectFill
                self.scene!.view?.presentScene(gameScene, transition: transition)
            }
            
        
        }
    }
    
    
    
    
    
        

}
