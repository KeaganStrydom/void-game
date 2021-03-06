//
//  Powerup.swift
//  Game
//
//  Created by Keagan Strydom on 2018/07/19.
//  Copyright © 2018 Lighthouse. All rights reserved.
//

import SpriteKit

protocol Powerup {
    var radius : CGFloat {get}
    var theme : Theme {get}
    var image : UIImage {get}
    func affect(_ scene : GameScene)
    func revert(_ scene : GameScene)
    func collision(with node : SKNode, in scene: GameScene)
    func barrier(at position : CGPoint, in scene: GameScene)
}

class PowerupFactory {
    static func makeRandom(in scene: GameScene, at position : CGPoint) -> Powerup? {
        let randomNumber = Random.generateNumber(between: 0, and: 100)
        
        if (0...45).contains(randomNumber) {
            return makeFreeze(in: scene, at: position)
        } else if (45...90).contains(randomNumber) {
            return makeDoublePoints(in: scene, at: position)
        } else if (90...100).contains(randomNumber) {
            return makeInvincibility(in: scene, at: position)
        }
        
        return nil
    }
    
    private static func makeFreeze(in scene : GameScene, at position : CGPoint) -> Powerup {
        return Freeze.init(in: scene, at: position)
    }
    private static func makeInvincibility(in scene : GameScene, at position : CGPoint) -> Powerup {
        return Invincibility.init(in: scene, at: position)
    }
    private static func makeDoublePoints(in scene : GameScene, at position : CGPoint) -> Powerup {
        return DoublePoints.init(in: scene, at: position)
    }
}

struct PowerupDelegate {
    private init() {}
    static func addMovement(to powerup: SKSpriteNode ) {
        let moveOffScreen = SKAction.moveTo(y: -Screen.height, duration: 4)
        powerup.run(moveOffScreen) {powerup.removeFromParent()}
    }
    static func addPhysics(to powerup : SKSpriteNode) {
        let radius = powerup.size.width/2
        powerup.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        powerup.physicsBody?.affectedByGravity = false
        powerup.physicsBody?.isDynamic = false
        powerup.physicsBody?.categoryBitMask = CollisionCategory.powerupCategory
        powerup.physicsBody?.collisionBitMask = CollisionCategory.ballCategory
    }
    static func removePowerups(from scene: GameScene ) {
        for child in scene.children {
            if child is Powerup {
                child.removeFromParent()
            }
        }
    }
    
    static func wait(in scene : GameScene) {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_)  in
            removePowerups(from: scene)
        }
    }
    
    static func changeDarkness(to color: UIColor, in scene: GameScene) {
        let theme = scene.gameInfo.selectedTheme
        for child in scene.children {
                if child is UIDarkness {
                    (child as? UIDarkness)?.emitter.particleColor = color
                }
            }
        }
}

