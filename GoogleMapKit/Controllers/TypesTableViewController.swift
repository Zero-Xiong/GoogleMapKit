//
//  TypesTableViewController.swift
//  GoogleMapKit
//
//  Created by xiong on 5/5/16.
//  Copyright © 2016 Zero Inc. All rights reserved.
//

import UIKit

class TypesTableViewController: UITableViewController {
    
    var selectedTypes: [String]!
    let possibleTypesDictionary = ["bakery":"Bakery", "bar":"Bar", "cafe":"Cafe", "grocery_or_supermarket":"Supermarket", "restaurant":"Restaurant"]
    
    var sortedKeys: [String] {
        return possibleTypesDictionary.keys.sort()
    }
    
    weak var delegate: TypesTableViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return possibleTypesDictionary.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        let key = sortedKeys[indexPath.row]
        let type = possibleTypesDictionary[key]!
        
        print("The cell indexPath.item = [\(indexPath.row)] and key=[\(key)] and type=[\(type)]")
        
        cell.textLabel?.text = type
        cell.imageView?.image = UIImage(named: key)
        cell.accessoryType = (selectedTypes!).contains(key) ? .Checkmark : .None

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let key = sortedKeys[indexPath.row]
        if (selectedTypes!).contains(key) {
            selectedTypes = selectedTypes.filter({$0 != key})
        } else {
            selectedTypes.append(key)
        }
        
        tableView.reloadData()

    }
    
    
    @IBAction func donePressed(sender: AnyObject) {
        delegate?.typesController(self, didSelectTypes: selectedTypes)
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
