//
//  OverallTableViewController.swift
//  basketballApp
//
//  Created by Hesham Hussain on 12/2/19.
//  Copyright © 2019 David Zucco. All rights reserved.
//

import UIKit

class SeasonOverallTableViewController: UITableViewController {
    
    @IBOutlet weak var usTOs: UILabel!
    @IBOutlet weak var oppTOs: UILabel!
    
    @IBOutlet weak var usFGpercent: UILabel!
    @IBOutlet weak var oppFGpercent: UILabel!
    
    
    @IBOutlet weak var usOreb: UILabel!
    @IBOutlet weak var oppOreb: UILabel!
    
    @IBOutlet weak var usFTs: UILabel!
    @IBOutlet weak var oppOts: UILabel!
 
    var usTOGoal: Int!
    var usFGpercentGoal: Int!
    var usFTGoal: Int!
    var usOrebGoal: Int!

    var oppTOGoal: Int!
    var oppFGpercentGoal: Int!
    var oppFTGoal: Int!
    var oppOrebGoal: Int!


    override func viewDidLoad() {
        super.viewDidLoad()

        usFTs.sizeToFit()
        oppOts.sizeToFit()
        usFTGoal = 80
        oppFTGoal = 80
        usFTs.text = "71"
        oppOts.text = "66"
        let usFTnum = Int(usFTs.text!)
        if usFTnum! > usFTGoal
        {
            usFTs.textColor = UIColor.red
        }
        if usFTnum! < usFTGoal
        {
            usFTs.textColor = UIColor.green
        }
        
        let oppFTnum = Int(oppOts.text!)
        if oppFTnum! > oppFTGoal
        {
            oppOts.textColor = UIColor.red
        }
        if oppFTnum! < oppFTGoal
        {
            oppOts.textColor = UIColor.green
        }


        usTOs.sizeToFit()
        oppTOs.sizeToFit()
        usTOs.text = "7"
        oppTOs.text = "9"
        usTOGoal = 12
        oppTOGoal = 12
        let usTOnum = Int(usTOs.text!)
        if usTOnum! > usTOGoal
        {
            usTOs.textColor = UIColor.red
        }
        if usTOnum! < usTOGoal
        {
            usTOs.textColor = UIColor.green
        }
        
        let oppTOnum = Int(oppTOs.text!)
        if oppTOnum! > oppTOGoal
        {
            oppTOs.textColor = UIColor.red
        }
        if oppTOnum! < oppTOGoal
        {
            oppTOs.textColor = UIColor.green
        }



        usFGpercent.sizeToFit()
        oppFGpercent.sizeToFit()
        usFGpercent.text = "71"
        oppFGpercent.text = "68"
        usFGpercentGoal = 55
        oppFGpercentGoal = 55
        let usFGpercentnum = Int(usFGpercent.text!)
        if usFGpercentnum! > usFGpercentGoal
        {
            usFGpercent.textColor = UIColor.red
        }
        if usFGpercentnum! < usFGpercentGoal
        {
            usFGpercent.textColor = UIColor.green
        }
        
        let oppFGpercentnum = Int(oppFGpercent.text!)
        if oppFGpercentnum! > oppFGpercentGoal
        {
            oppFGpercent.textColor = UIColor.red
        }
        if oppFGpercentnum! < oppFGpercentGoal
        {
            oppFGpercent.textColor = UIColor.green
        }


        usOreb.sizeToFit()
        oppOreb.sizeToFit()
        usOreb.text = "12"
        oppOreb.text = "7"
        usOrebGoal = 10
        oppOrebGoal = 10
        let usOrebnum = Int(usOreb.text!)
        if usOrebnum! > usOrebGoal
        {
            usOreb.textColor = UIColor.red
        }
        if usOrebnum! < usOrebGoal
        {
            usOreb.textColor = UIColor.green
        }
        
        let oppOrebnum = Int(oppOreb.text!)
        if oppOrebnum! > oppOrebGoal
        {
            oppOreb.textColor = UIColor.red
        }
        if oppOrebnum! < oppOrebGoal
        {
            oppOreb.textColor = UIColor.green
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Tadsble view data source

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
