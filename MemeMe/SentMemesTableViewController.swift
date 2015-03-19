//
//  FirstViewController.swift
//  MemeMe
//
//  Created by Antonio Maradiaga on 9/03/2015.
//  Copyright (c) 2015 Antonio Maradiaga. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var mmDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set TableView Edit Button
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        if mmDelegate.memes.count == 0 {
            createNewMeme(nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        checkMemeCount()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createNewMeme(sender: UIBarButtonItem?) {
        let memeEditorVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeNavigationVC") as UIViewController
        mmDelegate.window?.rootViewController?.presentViewController(memeEditorVC, animated: true, completion: nil)
    }

    
    // MARK: - TableView DataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mmDelegate.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeTVC") as MemeTableViewCell
        
        let currentMeme = mmDelegate.memes[indexPath.row]
        
        cell.memeImageView.image = currentMeme.memedImage
        cell.memeText.text = currentMeme.topText + " " + currentMeme.bottomText
        
        return cell
    }
    
    // MARK : TableView Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       self.performSegueWithIdentifier("memeDetailFromTable", sender: indexPath.row)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete) {
            mmDelegate.memes.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
            checkMemeCount()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var memeDetailVC = segue.destinationViewController as MemeDetailViewController
        memeDetailVC.memeIndex = sender as Int
    }
    
    //Updates the editing mode of the View based on the amount of Memes created
    func checkMemeCount(){
        if mmDelegate.memes.count == 0 {
            if(self.editing){
                self.setEditing(false, animated: false)
            }
            self.navigationItem.leftBarButtonItem?.enabled = false
        } else {
            self.navigationItem.leftBarButtonItem?.enabled = true
        }
    }
    
}

