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
    //I think this is a misspelling but it breaks other stuff when I change it
    @IBOutlet weak var oppOts: UILabel!
    
    var usTOGoal: Int!
    var usFGpercentGoal: Int!
    var usFTGoal: Int!
    var usOrebGoal: Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usFTs.sizeToFit()
        oppOts.sizeToFit()
        usFTGoal = 80
        usFTs.text = "76"
        let usFTnum = Int(usFTs.text!)
        if usFTnum! > usFTGoal
        {
            usFTs.textColor = UIColor.red
        }
        if usFTnum! < usFTGoal
        {
            usFTs.textColor = UIColor.green
        }
        
        
        usTOs.sizeToFit()
        oppTOs.sizeToFit()
        usTOs.text = "10"
        usTOGoal = 12
        let usTOnum = Int(usTOs.text!)
        if usTOnum! > usTOGoal
        {
            usTOs.textColor = UIColor.red
        }
        if usTOnum! < usTOGoal
        {
            usTOs.textColor = UIColor.green
        }
        
        
        
        usFGpercent.sizeToFit()
        oppFGpercent.sizeToFit()
        usFGpercent.text = "61"
        usFGpercentGoal = 55
        let usFGpercentnum = Int(usFGpercent.text!)
        if usFGpercentnum! > usFGpercentGoal
        {
            usFGpercent.textColor = UIColor.red
        }
        if usFGpercentnum! < usFGpercentGoal
        {
            usFGpercent.textColor = UIColor.green
        }
        
        
        usOreb.sizeToFit()
        oppOreb.sizeToFit()
        usOreb.text = "12"
        usOrebGoal = 10
        let usOrebnum = Int(usOreb.text!)
        if usOrebnum! > usOrebGoal
        {
            usOreb.textColor = UIColor.red
        }
        if usOrebnum! < usOrebGoal
        {
            usOreb.textColor = UIColor.green
        }
        
        


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
