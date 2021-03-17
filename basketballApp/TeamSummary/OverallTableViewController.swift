//
//  OverallTableViewController.swift
//  basketballApp
//
//  Created by Hesham Hussain on 12/2/19.
//  Copyright © 2019 David Zucco. All rights reserved.
//

import UIKit

class OverallTableViewController: UITableViewController {
    
    @IBOutlet weak var usTOs: UILabel!
    @IBOutlet weak var oppTOs: UILabel!
    
    @IBOutlet weak var usFGpercent: UILabel!
    @IBOutlet weak var oppFGpercent: UILabel!
    
    
    @IBOutlet weak var usOreb: UILabel!
    @IBOutlet weak var oppOreb: UILabel!
    
    @IBOutlet weak var usFTs: UILabel!
    @IBOutlet weak var oppOts: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usFTs.text = "22"
        let usFTnum = Int(usFTs.text!)
        if usFTnum! > 3
        {
            usFTs.textColor = UIColor.red
        }
        if usFTnum! < 2
        {
            usFTs.textColor = UIColor.green
        }
        usTOs.sizeToFit()
        oppTOs.sizeToFit()
        
        usFGpercent.sizeToFit()
        oppFGpercent.sizeToFit()
        
        usOreb.sizeToFit()
        oppOreb.sizeToFit()
        
        usFTs.sizeToFit()
        oppOts.sizeToFit()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
