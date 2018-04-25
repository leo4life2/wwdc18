import UIKit
import SpriteKit
import SceneKit

public class MyViewController: UICollectionViewController {
    
    var tableView: UITableView!
    var items = [UIImage]()
    
    var levelsCleared = [false,false,false,false]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        items = [UIImage(named: "0.png")!,
                 UIImage(named: "1.png")!,
                 UIImage(named: "2L.png")!,
                 UIImage(named: "3L.png")!,
                 UIImage(named: "4L.png")!,
                 UIImage(named: "5L.png")!
        ]
        
        //Check unlocked levels
        print(levelsCleared)
        
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 187, height: 167)
        print(self.view.frame.width)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        self.collectionView!.collectionViewLayout = layout
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        //set images for locked levels
        for x in 0...3{
            if levelsCleared[x]{
                //unlocked
                let name = String(x+2) + ".png"
                items[x+2] = UIImage(named: name)!
            }else{
                //locked
                let name = String(x+2) + "L.png"
                items[x+2] = UIImage(named: name)!
            }
        }
        
        self.collectionView?.reloadData()
    }
    
    // DataSource
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor(patternImage: self.items[indexPath.row])
        return cell
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = GameViewController()
        
        //Check unlocked levels in each case
        switch indexPath.row {
        case 0:
            print(levelsCleared)
        case 1:
        
            let scene = Scene1(fileNamed: "Scene0")
            
            scene?.scaleMode = .aspectFit
            
            let gameView = SKView(frame: CGRect(x: 0, y: 0, width: 375, height: 501))
            gameView.presentScene(scene)
            vc.view = gameView
            self.present(vc, animated: true, completion: nil)
            
        case 2:
            if levelsCleared[0]{
                let scene = Scene2(fileNamed: "Scene1")
                scene?.scaleMode = .aspectFit
                
                let gameView = SKView(frame: CGRect(x: 0, y: 0, width: 375, height: 501))
                gameView.presentScene(scene)
                vc.view = gameView
                self.present(vc, animated: true, completion: nil)
            }
        case 3:
            if levelsCleared[1]{
                let scene = Scene3(fileNamed: "Scene2")
                scene?.scaleMode = .aspectFit
                
                let gameView = SKView(frame: CGRect(x: 0, y: 0, width: 375, height: 501))
                gameView.presentScene(scene)
                vc.view = gameView
                self.present(vc, animated: true, completion: nil)
            }
        case 4:
            if levelsCleared[2]{
                let scene = Scene4(fileNamed: "Scene3")
                scene?.scaleMode = .aspectFit
                
                let gameView = SKView(frame: CGRect(x: 0, y: 0, width: 375, height: 501))
                gameView.presentScene(scene)
                vc.view = gameView
                self.present(vc, animated: true, completion: nil)
            }
        case 5:
            if levelsCleared[3]{
                let scene = Scene5(fileNamed: "Scene4")
                scene?.scaleMode = .aspectFit
                
                let gameView = SKView(frame: CGRect(x: 0, y: 0, width: 375, height: 501))
                gameView.presentScene(scene)
                vc.view = gameView
                self.present(vc, animated: true, completion: nil)
            }
        default:
            break
        }
        
    }
}
