//
//  Alien.swift
//  ScavengAR
//
//  Created by Lauren Champeau on 12/5/17.
//  Copyright © 2017 Lauren Champeau. All rights reserved.
//

import UIKit
import Firebase

class Alien: NSObject {
    var pic : String
    var alienName : String
    var key : String
    var ref : FIRDatabaseReference?
    
    // init from variables
    init(pic: String, alienName: String){
        self.pic = pic
        self.alienName = alienName
        self.key = ""
        self.ref = nil
    }
    
    // init from firebase snapshot
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        let snapValue = snapshot.value as! [String: AnyObject]
        alienName = snapValue["alienName"] as! String
        pic = snapValue["pic"] as! String
        ref = snapshot.ref
    }
    
    // conversion to dictionary for firebase
    func toDict() -> Any {
        return [
            "pic":pic,
            "alienName":alienName
        ]
    }
}
