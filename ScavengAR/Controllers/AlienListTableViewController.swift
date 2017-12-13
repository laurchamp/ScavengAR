//
//  AlienListTableViewController.swift
//  ScavengAR
//
//  Created by Lauren Champeau on 12/5/17.
//  Copyright © 2017 Lauren Champeau. All rights reserved.
//

import UIKit
import Firebase


class AlienListTableViewController: UITableViewController {
    
    let ref = FIRDatabase.database().reference(withPath: "alien-list")
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // background tasks to load data from firebase and display selected alien list
        
        let bgTimeRemaining = UIApplication.shared.backgroundTimeRemaining
        let backgroundQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        backgroundQueue.async {
            var backgroundTask : UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
            backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                UIApplication.shared.endBackgroundTask(backgroundTask)
                backgroundTask = UIBackgroundTaskInvalid
            })
            
            // database calll
            self.ref.observe(.value, with: { snapshot in

                var newAlienList: [Alien] = []
                for alien in snapshot.children{
                    if (bgTimeRemaining < 6) {
                        break
                    }
                    let newAlien = Alien(snapshot: alien as! FIRDataSnapshot)
                    newAlienList.append(newAlien)
                    globalAliens = newAlienList
                    self.tableView.reloadData()
                }
            })
            // end background task
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = UIBackgroundTaskInvalid
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalAliens.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        let currAlien = globalAliens[indexPath.row]
        cell.textLabel?.text = currAlien.alienName
        cell.imageView?.image = UIImage(named: currAlien.pic)

        return cell
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // delete from firebase
            let currAlien = globalAliens[indexPath.row]
            currAlien.ref?.removeValue()
        }
    }

}
