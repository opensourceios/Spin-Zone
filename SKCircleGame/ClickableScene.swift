//
//  ClickableScene.swift
//  SKCircleGame
//
//  Created by Nicholas Grana on 1/3/17.
//  Copyright © 2017 Nicholas Grana. All rights reserved.
//

import SpriteKit

class ClickableScene: DynamicBackground {

    var model: MenuModel!
    
    var prevSelected: ButtonSprite? = nil
    var selected: ButtonSprite? = nil
    
    var touching = false
    var makingCricle = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touching {
            return
        }
        
        touching = true
        if let button = buttonFrom(touches: touches) {
            if prevSelected == nil {
                prevSelected = button
            }
            selected = button
            button.pressed()
        } else {
            super.touchesMoved(touches, with: event)
            makingCricle = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let button = buttonFrom(touches: touches), prevSelected == button {
            selected = button
            button.pressed()
        } else {
            if selected != nil {
                prevSelected = selected
                selected?.letGo()
                selected = nil
            }
        }
        
        if makingCricle {
            super.touchesMoved(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let clicked = selected {
            if let name = clicked.name?.lowercased() {
                clicked.runOnClick()
                clicked.letGo()
                if let sceneType = model.scenes[name], let transition = model.transitions[name] {
                    let newScene = model.create(scene: sceneType, current: self)
                    transition.pausesIncomingScene = true
                    self.view?.presentScene(newScene, transition: transition)
                    // return to pretend creating / editing of superclass's circle creation
                    return
                }
                prevSelected = nil
                selected = nil
                touching = false
                makingCricle = false
                return
            }
        }
        
        prevSelected = nil
        selected = nil
        touching = false
        makingCricle = false
        super.touchesEnded(touches, with: event)
    }
    
    func buttonFrom(touches: Set<UITouch>) -> ButtonSprite? {
        
        guard let touch = touches.first else {
            return nil
        }
        
        let nodes = self.nodes(at: touch.location(in: self))
        
        for node in nodes {
            if let n = node as? ButtonSprite {
                return n
            }
        }
        return nil
    }
    
}
