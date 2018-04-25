import UIKit
import SpriteKit

enum State {
    case stopped
    case rotating
    case launched
}

let two_pi = CGFloat(.pi*2.0)
let pi = CGFloat(Double.pi)

// These are useful vector/point operators
func * (left:CGPoint, right:CGFloat) -> CGPoint {
    return CGPoint(x:left.x*right, y:left.y*right)
}

func += ( left:inout CGPoint, right:CGPoint) {
    left = CGPoint(x:left.x+right.x, y:left.y+right.y)
}

func * (left:CGVector, right:CGFloat) -> CGVector {
    return CGVector(dx:left.dx*right, dy:left.dy*right)
}

func / (left:CGVector, right:CGFloat) -> CGVector {
    return CGVector(dx:left.dx/right, dy:left.dy/right)
}

public class SceneTemplate: SKScene, SKPhysicsContactDelegate {
    let shape = SKShapeNode(circleOfRadius: 25)
    let blackHole = SKSpriteNode(imageNamed: "hole.png")
    let circle = SKShapeNode(circleOfRadius: 70)
    let radius:CGFloat = 70.0
    var center = CGPoint.zero
    var currentAngle = -pi/2
    let angleIncr = two_pi / 60.0
    var state:State = .stopped
    var viewController = MyViewController()
    
    struct CategoryBitMask {
        static let Ball: UInt32 = 0b1 << 0
        static let Hole: UInt32 = 0b1 << 1
        static let Back: UInt32 = 0b1 << 2
        static let Button: UInt32 = 0b1 << 3
        static let EntryPortal: UInt32 = 0b1 << 4
    }
    
    func saveViewController(){
        viewController = self.view?.window?.rootViewController as! MyViewController
    }
    
    func initOnMoveToView(){
        self.size = CGSize(width: 1437, height: 1920)
        self.backgroundColor = UIColor(red: 169/255, green: 221/255, blue: 123/255, alpha: 1)
        
        self.physicsWorld.contactDelegate = self
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        let sceneBound = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        sceneBound.friction = 0
        sceneBound.restitution = 0
        self.physicsBody = sceneBound
    }
    
    func addBall() {
        print(viewController.levelsCleared)
        
        currentAngle = pi
        shape.fillColor = SKColor.white
        shape.strokeColor = UIColor.clear
        shape.position = CGPoint(x:center.x-radius, y:center.y)
        shape.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        shape.physicsBody?.categoryBitMask = CategoryBitMask.Ball
        shape.physicsBody?.contactTestBitMask = CategoryBitMask.Back | CategoryBitMask.EntryPortal | CategoryBitMask.Button
        shape.physicsBody?.affectedByGravity = false
        shape.physicsBody?.mass = 0.0
        shape.physicsBody?.restitution = 1
        shape.physicsBody?.friction = 0
        shape.physicsBody?.linearDamping = 0.0
        shape.zPosition = 1
        addChild(shape)
    }
    
    func configedPhysicsBody(node:SKSpriteNode) -> SKPhysicsBody{
        let physBody = SKPhysicsBody(rectangleOf: node.size)
        physBody.isDynamic = false
        physBody.friction = 0
        physBody.restitution = 1
        return physBody
    }
    
    override open func update(_ currentTime: TimeInterval) {
        switch (state) {
        case .rotating:
            var point = angleToPoint(currentAngle) * radius
            point += center
            shape.position = point
            currentAngle -= angleIncr
            // Wrap at 2 pi
            currentAngle .formTruncatingRemainder(dividingBy: two_pi)
        default:
            break
        }
    }
    
    func angleToPoint(_ angle:CGFloat) -> CGPoint {
        return CGPoint(x:cos(angle), y:sin(angle))
    }
    
    func magnitude(_ v1:CGVector) -> CGFloat {
        return sqrt(v1.dx*v1.dx+v1.dy*v1.dy)
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (state == .rotating) {
            // Launch the ball on a vector tangent to its current position on the circle
            state = .launched
            // Normal vector
            var normal = CGVector(dx:shape.position.x-center.x, dy:shape.position.y-center.y)
            normal = normal / magnitude(normal)
            // Convert angular to linear speed
            let speed = angleIncr * 45.0 * radius
            shape.physicsBody?.velocity = normal*speed
        }
    }
    
}
