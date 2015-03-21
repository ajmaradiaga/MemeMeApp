//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Antonio Maradiaga on 13/03/2015.
//  Copyright (c) 2015 Antonio Maradiaga. All rights reserved.
//

import UIKit

let reuseIdentifier = "MemeCell"

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var memeCollectionView: UICollectionView!
    
    var mmDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    var memeActions: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        checkMemeCount()
        memeCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mmDelegate.memes.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: MemeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as MemeCollectionViewCell
    
        cell.memeImage?.image = mmDelegate.memes[indexPath.row].memedImage
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if(self.editing) {
            memeActions = UIAlertController(title: "Delete", message: "Delete Meme?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            memeActions.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: memeActionHandler))
            
            memeActions.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: memeActionHandler))
            
            self.presentViewController(memeActions, animated: true, completion: nil)
            
        } else {
            self.performSegueWithIdentifier("memeDetailFromCollection", sender: indexPath.row)
        }
    }
    
    func memeActionHandler(sender: UIAlertAction!) -> Void{
        if(sender.title == "Delete"){
            println("Delete Meme")
            var selectedItems = memeCollectionView.indexPathsForSelectedItems()
            for(var i = 0; i < selectedItems.count; i++) {
                let indexPath = selectedItems[i] as NSIndexPath
                mmDelegate.memes.removeAtIndex(indexPath.row)
            }
            memeCollectionView.reloadData()
            checkMemeCount()
        } else if(sender.title == "Cancel") {
            memeActions.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //Updates the editing mode of the View based on the amount of Memes created
    func checkMemeCount(){
        if mmDelegate.memes.count == 0 {
            if(self.editing){
                self.setEditing(false, animated: false)
            }
            createNewMeme(nil)
            self.navigationItem.leftBarButtonItem?.enabled = false
        } else {
            self.navigationItem.leftBarButtonItem?.enabled = true
        }
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        (segue.destinationViewController as MemeDetailViewController).memeIndex = sender as Int
    }
    
    @IBAction func createNewMeme(sender: UIBarButtonItem?) {
        let memeEditorVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeNavigationVC") as UIViewController
        mmDelegate.window?.rootViewController?.presentViewController(memeEditorVC, animated: true, completion: nil)
    }
}
