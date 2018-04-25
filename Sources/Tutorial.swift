import UIKit
import SpriteKit

public class Scene1:SceneTemplate{
    var actionForButton = SKAction.fadeIn(withDuration: 0.3)
    var teleportAction = SKAction()
    var portalIn = SKSpriteNode()
    var portalOut = SKSpriteNode()
    var aPortal = SKLabelNode()
    var wallLeft = SKSpriteNode()
    var level = SKLabelNode()
    var clear = SKLabelNode()
    var portalSavedPhysicsBody = SKPhysicsBody()
    var wallSavedPhyscisBody = SKPhysicsBody()

    override open func didMove(to view: SKView) {
        
        initOnMoveToView()
        
        // Set the center of the sling
        center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        addBall()
        circle.strokeColor = UIColor(red: 87/255, green: 87/255, blue: 87/255, alpha: 1)
        circle.lineWidth = 5.0
        circle.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        addChild(circle)
        
        // Hole
        self.blackHole.position = (self.childNode(withName: "blackHole1") as! SKSpriteNode).position
        
        //fade in nodes prep
        self.portalIn = self.childNode(withName: "portalIN") as! SKSpriteNode
        self.portalSavedPhysicsBody = self.portalIn.physicsBody!
        self.portalIn.physicsBody = nil
        self.portalOut = self.childNode(withName: "portalOUT") as! SKSpriteNode
        self.wallLeft = self.childNode(withName: "wallLeft") as! SKSpriteNode
        self.wallSavedPhyscisBody = self.wallLeft.physicsBody!
        self.wallLeft.physicsBody = nil
        self.level = self.childNode(withName: "level") as! SKLabelNode
        self.clear = self.childNode(withName: "clear") as! SKLabelNode
        self.aPortal = self.childNode(withName: "aPortal") as! SKLabelNode
        
        self.teleportAction = SKAction.move(to: CGPoint(x:self.portalOut.position.x,y:self.portalOut.position.y), duration: 0)
    }
    
    func buttonActions(){
        self.portalIn.physicsBody = self.portalSavedPhysicsBody
        self.portalIn.run(actionForButton)
        self.portalOut.run(actionForButton)
        self.aPortal.run(actionForButton)
        self.wallLeft.physicsBody = self.wallSavedPhyscisBody
        self.wallLeft.run(actionForButton)
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
            
            viewController.levelsCleared[0] = true
            
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
            print("ball now"+String(describing:shape.position))
            print("exit pos"+String(describing:self.portalOut.position))
            shape.run(self.teleportAction)
            shape.physicsBody?.velocity = CGVector(dx: 0, dy: -328)
            
        }
    }
    
    
}
