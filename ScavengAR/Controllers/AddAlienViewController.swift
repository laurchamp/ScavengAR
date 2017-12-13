//
//  AddAlienViewController.swift
//  ScavengAR
//
//  Created by Lauren Champeau on 12/5/17.
//  Copyright © 2017 Lauren Champeau. All rights reserved.
//

import UIKit
import Firebase

class AddAlienViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var alienImageView: UIImageView!
    var imageDesc : String!
    let ref = FIRDatabase.database().reference(withPath: "alien-list")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // default to yellow
        self.imageDesc = "yellow_alien"
        self.nameTF.delegate = self
    }
    
    // dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let name = nameTF.text else { return }
        let newAlien = Alien(pic: self.imageDesc, alienName: name)
        let alienRef = self.ref.child(name.lowercased())
        alienRef.setValue(newAlien.toDict())
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segControlChanged(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex){
        case 0:
            self.alienImageView.image = UIImage(named: "yellow_hidef")
            self.imageDesc = "yellow_alien"
            break
        case 1:
            self.alienImageView.image = UIImage(named: "red_hidef")
            self.imageDesc = "red_alien"
            break
        case 2:
            self.alienImageView.image = UIImage(named: "blue_hidef")
            self.imageDesc = "blue_alien"
            break
        default:
            break
        }
    }

}
