//
//  HomeScreenViewController.swift
//  ScavengAR
//
//  Created by Lauren Champeau on 12/5/17.
//  Copyright © 2017 Lauren Champeau. All rights reserved.
//

import UIKit
import Firebase
import FLAnimatedImage

var globalAliens = [Alien]()

class HomeScreenViewController: UIViewController {
    let ref = FIRDatabase.database().reference(withPath: "alien-list")
    //let twinkles: FLAnimatedImageView = FLAnimatedImageView()
    @IBOutlet weak var twinkleImageView: FLAnimatedImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // gif background
        let imgData = try! Data(contentsOf: URL(string: "https://i.pinimg.com/originals/ec/d6/16/ecd6169a6af845ef53a0c2deb624ab41.gif")!)
        let twinkle: FLAnimatedImage = FLAnimatedImage(animatedGIFData: imgData)
        self.twinkleImageView.animatedImage = twinkle
        
        // database call
        ref.observe(.value, with: { snapshot in
            var newAlienList: [Alien] = []
            for alien in snapshot.children{
                let newAlien = Alien(snapshot: alien as! FIRDataSnapshot)
                newAlienList.append(newAlien)
            }
            globalAliens = newAlienList            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addAliensPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "addAliensSegue", sender: nil)
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue){
        
    }

}
