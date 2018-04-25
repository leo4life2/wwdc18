import UIKit
import SpriteKit

public class Scene5:SceneTemplate{
    var actionForButton = SKAction.fadeIn(withDuration: 0.3)
    var teleportAction = SKAction()
    var portalIn = SKSpriteNode()
    var portalOut = SKSpriteNode()
    var level = SKLabelNode()
    var clear = SKLabelNode()
    var hint = SKLabelNode()
    var portalSavedPhysicsBody = SKPhysicsBody()
    var tries = 0
    
    override open func didMove(to view: SKView) {
        
        initOnMoveToView()
        
        // Set the center of the sling
        center = CGPoint(x: 340, y: 1600)
        addBall()
        circle.strokeColor = UIColor(red: 87/255, green: 87/255, blue: 87/255, alpha: 1)
        circle.lineWidth = 5.0
        circle.position = CGPoint(x: 340, y: 1600)
        addChild(circle)
        
        //Hole
        let hole = self.childNode(withName: "blackHole1") as! SKSpriteNode
        self.blackHole.position = hole.position
        
        //setup nodes
        self.portalIn = self.childNode(withName: "portalIN") as! SKSpriteNode
        self.portalSavedPhysicsBody = self.portalIn.physicsBody!
        self.portalIn.physicsBody = nil
        self.portalOut = self.childNode(withName: "portalOUT") as! SKSpriteNode
        self.level = self.childNode(withName: "level") as! SKLabelNode
        self.clear = self.childNode(withName: "clear") as! SKLabelNode
        self.hint = self.childNode(withName: "hint") as! SKLabelNode
        
        self.teleportAction = SKAction.move(to: CGPoint(x:self.portalOut.position.x,y:self.portalOut.position.y), duration: 0)
    }
    
    func buttonActions(){
        self.portalIn.physicsBody = self.portalSavedPhysicsBody
        self.portalIn.run(actionForButton)
        self.portalOut.run(actionForButton)
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
            shape.physicsBody?.velocity = CGVector(dx: 231, dy: -231)
            
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tries+=1
        if tries == 8{
            self.hint.run(actionForButton)
        }
        if let touch = touches.first {
            if (state == .launched){
                self.shape.removeFromParent()
                self.state = .stopped
                self.addBall()
            }
            if (state == .stopped) {
                // Start rotating the ball around the sling
                state = .rotating
            }
        }
    }
    
}
