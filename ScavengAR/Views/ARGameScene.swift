//
//  ARGameScene.swift
//  ScavengAR
//
//  Created by Lauren Champeau on 11/25/17.
//  Copyright © 2017 Lauren Champeau. All rights reserved.
//

import ARKit
import Firebase

class ARGameScene: SKScene {
    let ref = FIRDatabase.database().reference(withPath: "alien-list")
    var arSceneViewVar: ARSKView {
        return view as! ARSKView
    }
    var target: SKSpriteNode!
    var setupComplete = false
    var currAliens = [Alien]()
    let gameSize = CGSize(width: 2, height: 2)
    var didOnce = false

    
    // check to make sure the environment has a current frame and is ready to have stuff added to it
    private func setupAREnvironment() {
        self.currAliens = globalAliens

        
        guard let thisFrame = arSceneViewVar.session.currentFrame, let scene = SKScene(fileNamed: "AlienScene") else { return }
       // print("CHILD COUNT \(self.children.count)")
        //let aliensNotTarget = self.children.dropFirst()
        for node in scene.children{
            if let node = node as? SKSpriteNode{
                // crazy matrix math to make them have different depths
                var transMatrix = matrix_identity_float4x4
               // let xPos = node.position.x / self.size.width
                //let yPos = node.position.y / self.size.height
                //transMatrix.columns.3.x = Float(xPos * gameSize.width)
                transMatrix.columns.3.x = Float.random(min: -1, max: 1)
                transMatrix.columns.3.y = Float.random(min: -1, max: 1)
                transMatrix.columns.3.z = Float.random(min: -3, max: -0.2)

                //transMatrix.columns.3.z = -Float(yPos * gameSize.height)
                // can be anywhere y direction +/- 0.25 m from phone height
                //transMatrix.columns.3.y = Float(drand48() - 0.25)
                let transformedMatrix = simd_mul(thisFrame.camera.transform, transMatrix)
                let sceneAnchor = Anchor(transform: transformedMatrix)
                // figure out what color alien it is, specify appropriate anchor type
               // print("name \(node.name)")
                //print("type \(AlienType(rawValue: node.name!))")
                if let name = node.name, let type = AlienType(rawValue: name){
                    sceneAnchor.type = type
                    arSceneViewVar.session.add(anchor: sceneAnchor)
                    print("type \(type)")
                } else { print("what hte actual fuck")}
            }
        }
        /*let handler: (Array<Alien>?) -> Void = { (array) in
            self.currAliens = array!
        }
        self.loadAliens(completionHandler: handler)*/
        print("glob size \(globalAliens.count)")
        setupComplete = true
        // identity matrix to do matrix math stuff with later
        /*
        var transMatrix = matrix_identity_float4x4
        transMatrix.columns.3.z = -0.3
        let transformedMatrix = thisFrame.camera.transform * transMatrix
        let sceneAnchor = ARAnchor(transform: transformedMatrix)
        arSceneViewVar.session.add(anchor: sceneAnchor)
        self.loadAliens()
        setupComplete = true*/
    }
    
    override func update(_ currTime: TimeInterval){
        if !setupComplete {
            setupAREnvironment()
        }
    }
    
    override func didMove(to view: SKView) {
        /*if !setupComplete {
            setupAREnvironment()
        }*/
        target = SKSpriteNode(imageNamed: "target")
        addChild(target)
        
        //let height = self.view!.frame.height
        //let width = self.view!.frame.width
        currAliens = globalAliens
        /*
        if (didOnce == false){
            for alien in globalAliens{
                let newAlienNode = SKSpriteNode(imageNamed:alien.pic)
                newAlienNode.name = alien.pic
            
            
            /* let aspectRatio = Int(newAlienNode.frame.width) / Int(newAlienNode.frame.height)
             newAlienNode.xScale = CGFloat(0.2)
             newAlienNode.yScale = CGFloat(0.2)*/
                addChild(newAlienNode)

            }
            print("HOW MANY TIMES AM I RUNNING THIS")
            didOnce = true
        }*/
/*
        print ("curr aliens count didmove: \(currAliens.count)")
        for alien in currAliens{
            let newAlienNode = SKSpriteNode(imageNamed:alien.pic)
            newAlienNode.name = alien.pic

            
           /* let aspectRatio = Int(newAlienNode.frame.width) / Int(newAlienNode.frame.height)
            newAlienNode.xScale = CGFloat(0.2)
            newAlienNode.yScale = CGFloat(0.2)*/
            addChild(newAlienNode)
            print("here")
        }
        // seed random number generator
        srand48(Int(Date.timeIntervalSinceReferenceDate))
 */
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currTargetLocation = target.position
        let whatGotShot = nodes(at: currTargetLocation)
        print("what shot \(whatGotShot.debugDescription)")
        
        var shotAlien: SKNode?
        for node in whatGotShot {
            if node.name == "yellow_alien" || node.name == "blue_alien" || node.name == "red_alien" {
                shotAlien = node
                print("!!!!: \(shotAlien.debugDescription)")
                break
            }
        }
        //let currFrameAnchor = arSceneViewVar.anchor(for: shotAlien!)

        if let shotAlien = shotAlien,
            let currFrameAnchor = arSceneViewVar.anchor(for: shotAlien) {
            let shotAction = SKAction.run {
                print("shot al \(shotAlien.debugDescription)")
                self.arSceneViewVar.session.remove(anchor: currFrameAnchor)
                Game.shared().increaseScore()
            }
            shotAlien.run(shotAction)
            //Game.shared().increaseScore()
        }
        
    }
    /*
    typealias alienArrClosure = (Array<Alien>?) -> Void
    func loadAliens(completionHandler:@escaping alienArrClosure){
            self.ref.observe(.value, with: { snapshot in
                var newAlienList: [Alien] = []
                for alien in snapshot.children{
                    let newAlien = Alien(snapshot: alien as! FIRDataSnapshot)
                    newAlienList.append(newAlien)
                }
                if (newAlienList.isEmpty){
                    completionHandler(nil)
                } else {
                    completionHandler(newAlienList)
                }
                //self.currAliens = newAlienList
                //print("curr size in load \(self.currAliens.count)")
            })
            print("loaded")
        

    }
    */
//    func random() -> CGFloat {
//        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
//    }
//
//    func random(min: CGFloat, max: CGFloat) -> CGFloat {
//        return random() * (max - min) + min
//    }
    
}

public extension Float {
    
    // Returns a random floating point number between 0.0 and 1.0, inclusive.
    
    public static var random:Float {
        get {
            return Float(arc4random()) / 0xFFFFFFFF
        }
    }
    /*
     Create a random num Float
     
     - parameter min: Float
     - parameter max: Float
     
     - returns: Float
     */
    public static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}
