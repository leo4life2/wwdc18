import UIKit
import SpriteKit

public class Scene4:SceneTemplate{
    var fadeAction = SKAction.fadeIn(withDuration: 0.3)
    var fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
    var wallMoveDownAction = SKAction.moveTo(y: 600, duration: 0.5)
    var teleportAction = SKAction()
    var portalsIn = [SKSpriteNode]()
    var portalOut = SKSpriteNode()
    var level = SKLabelNode()
    var clear = SKLabelNode()
    var wallLeft = SKSpriteNode()
    var hole = SKSpriteNode()
    
    override open func didMove(to view: SKView) {
        
        initOnMoveToView()
        
        // Set the center of the sling
        center = CGPoint(x: 440, y: 1720)
        addBall()
        circle.strokeColor = UIColor(red: 87/255, green: 87/255, blue: 87/255, alpha: 1)
        circle.lineWidth = 5.0
        circle.position = CGPoint(x: 440, y: 1720)
        addChild(circle)
        
        //Hole
        self.hole = self.childNode(withName: "blackHole1") as! SKSpriteNode
        self.blackHole.position = self.hole.position
        
        //setup nodes
        
        //get all entry portals
        let children = self.children
        for child in children{
            if child.name == "portalIN"{
                self.portalsIn.append(child as! SKSpriteNode)
            }
        }
        
        self.portalOut = self.childNode(withName: "portalOUT") as! SKSpriteNode
        self.level = self.childNode(withName: "level") as! SKLabelNode
        self.clear = self.childNode(withName: "clear") as! SKLabelNode
        self.wallLeft = self.childNode(withName: "wallLeft") as! SKSpriteNode
        self.hole = self.childNode(withName: "blackHole1") as! SKSpriteNode
        
        self.teleportAction = SKAction.move(to: CGPoint(x:self.portalOut.position.x,y:self.portalOut.position.y), duration: 0)
    }
    
    func buttonActions(){
        for node in self.portalsIn{
            node.run(fadeOutAction)
            node.removeFromParent()
        }
        self.portalOut.run(fadeOutAction)
        self.wallLeft.run(wallMoveDownAction)
        self.hole.run(fadeAction)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //When ball contacts...
        print(contact.bodyA.categoryBitMask)
        print(contact.bodyB.categoryBitMask)
        
        saveViewController()
        
        //Back to menu
        if contact.bodyA.categoryBitMask == CategoryBitMask.Back && contact.bodyB.categoryBitMask == CategoryBitMask.Ball{
            viewController.dismiss(animated: true, completion: nil)
        }
        
        //Goal
        if contact.bodyA.categoryBitMask == CategoryBitMask.Hole && contact.bodyB.categoryBitMask == CategoryBitMask.Ball{
            
            viewController.levelsCleared[3] = true
            
            blackHole.physicsBody?.collisionBitMask = 0
            shape.physicsBody?.collisionBitMask = 0
            let p = shape.position
            let dx = blackHole.position.x - p.x
            let dy = blackHole.position.y - p.y
            shape.physicsBody?.velocity = CGVector(dx: dx, dy: dy-25)
            shape.physicsBody?.linearDamping = 1
            
            self.level.alpha = 1
            self.clear.alpha = 1
        }
        
        //Button touched
        if contact.bodyA.categoryBitMask == CategoryBitMask.Button && contact.bodyB.categoryBitMask == CategoryBitMask.Ball{
            print(contact.bodyA.mass)
            
            shape.physicsBody?.linearDamping = 0.99
            
            buttonActions()
        }
        
        //Enter & Exit Portal
        if contact.bodyA.categoryBitMask == CategoryBitMask.EntryPortal && contact.bodyB.categoryBitMask == CategoryBitMask.Ball{
            //Check source, unlock next level
            shape.run(self.teleportAction)
            shape.physicsBody?.velocity = CGVector(dx: -328, dy: 0)
            
        }
    }
    
}
