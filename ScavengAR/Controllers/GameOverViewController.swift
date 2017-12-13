//
//  GameOverViewController.swift
//  ScavengAR
//
//  Created by Lauren Champeau on 12/7/17.
//  Copyright © 2017 Lauren Champeau. All rights reserved.
//

import UIKit
import FBSDKShareKit
import FLAnimatedImage

class GameOverViewController: UIViewController, FBSDKSharingDelegate {
    
    @IBOutlet weak var galaxyCatImageView: FLAnimatedImageView!
    @IBOutlet weak var scoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let score = Game.shared().score {
            self.scoreLabel.text = "Score: \(score)"
        }
        
        // this should be made safer - background gif
        let imgData = try! Data(contentsOf: URL(string: "https://media.giphy.com/media/IeCVaFnmXFpjq/giphy.gif")!)
        let cat: FLAnimatedImage = FLAnimatedImage(animatedGIFData: imgData)
        self.galaxyCatImageView.animatedImage = cat
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goHomeButtonPressed(_ sender: Any) {
        Game.shared().resetScore()
        self.performSegue(withIdentifier: "unwindToHome", sender: nil)
    }
    
    @IBAction func shareOnFacebook(_ sender: Any) {
        // share the high score image
        let icon = UIImage(named:"Spaceship")
        let photo = FBSDKSharePhoto(image: icon, userGenerated: false)
        let content = FBSDKSharePhotoContent()
        content.photos = [photo]
        let dialog = FBSDKShareDialog()
        dialog.fromViewController = self
        dialog.shareContent = content
        dialog.delegate = self
        dialog.mode = .native
        dialog.show()
    }
    
    
    // FBSDKSharingDelegate Methods
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print(results)
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print("There was an error")
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("Cancelled")
    }

}
