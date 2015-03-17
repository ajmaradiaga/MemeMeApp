//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Antonio Maradiaga on 13/03/2015.
//  Copyright (c) 2015 Antonio Maradiaga. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var memeIndex: Int!
    var mmDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    var memeActions: UIAlertController!
    var currentMeme: MemeObject?
    
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var memeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentMeme = mmDelegate.memes[memeIndex]
        memeImage.image = currentMeme?.memedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Method called by the actionButton (UIBarButtonItem). Let's the user Edit or Delete the current Meme
    @IBAction func actionTapped(sender: AnyObject) {
        memeActions = UIAlertController(title: "Actions", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        //Add Actions to UIAlertController
        memeActions.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.Default, handler: memeActionHandler))
        memeActions.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: memeActionHandler))
        memeActions.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: memeActionHandler))
        
        self.presentViewController(memeActions, animated: true, completion: nil)
    }
    
    //Handles the option selected by the user in the memeAction - UIAlertController
    func memeActionHandler(sender: UIAlertAction!) -> Void{
        if(sender.title == "Delete"){
            mmDelegate.memes.removeAtIndex(memeIndex)
            memeActions.dismissViewControllerAnimated(true, completion: nil)
            self.navigationController?.popViewControllerAnimated(true)
        } else  if(sender.title == "Edit"){
            println("Edit Meme")
            let memeEditorVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeNavigationVC") as UINavigationController
            
            (memeEditorVC.viewControllers[0] as MemeEditorViewController).editMeme = currentMeme
            
            mmDelegate.window?.rootViewController?.presentViewController(memeEditorVC, animated: true, completion: nil)
            
        } else if(sender.title == "Cancel") {
            memeActions.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
