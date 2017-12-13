//
//  ARScreenViewController.swift
//  ScavengAR
//
//  Created by Lauren Champeau on 11/25/17.
//  Copyright © 2017 Lauren Champeau. All rights reserved.
//

import ARKit
import Firebase

class ARScreenViewController: UIViewController {
    
    var gameSceneView : ARSKView!
    var currAliensInGame = [Alien]()
    let ref = FIRDatabase.database().reference(withPath: "alien-list")
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currAliensInGame = globalAliens
        
        // load and configure ARSKView
        if let view = self.view as? ARSKView {
            gameSceneView = view
            // set view controller to be delegate
            gameSceneView!.delegate = self
            let gameScene = ARGameScene(size: view.bounds.size)
            gameScene.scaleMode = .resizeFill
            gameScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view.presentScene(gameScene)
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "gameOverSegue", sender: nil)
    }
    
    // support rotation automatically
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // hide the status bar because view is camera feed
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // start tracking the session
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        gameSceneView.session.run(configuration)
    }
    
    // pause the session
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameSceneView.session.pause()
    }
}

// ARSKView delegate methods
extension ARScreenViewController: ARSKViewDelegate {
    func session(_ session: ARSession,
                 didFailWithError error: Error) {
        print("AR Session failed. Did you allow ScavengAR access to the camera?")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("AR Session was interrupted.")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        print("AR Session was resumed")
        gameSceneView.session.run(session.configuration!,
                              options: [.resetTracking,
                                        .removeExistingAnchors])
    }
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        var alien: SKNode?
        var count = 0
        // figure out what type of node it is, get the right picture, give it the right type name
        if let anchor = anchor as? Anchor {
            if let type = anchor.type{
                alien = SKSpriteNode(imageNamed: type.rawValue)
                let aspectRatio = Int((alien?.frame.width)!) / Int((alien?.frame.height)!)
                alien?.name = type.rawValue
                count += 1
            }
        }
        print("count: \(count)")
        return alien
    }
}
