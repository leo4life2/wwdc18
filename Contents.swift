import UIKit
import SpriteKit
import PlaygroundSupport

var ctrl = MyViewController(collectionViewLayout: UICollectionViewFlowLayout())
ctrl.preferredContentSize = CGSize(width: 375, height: 501)
PlaygroundPage.current.liveView = ctrl
