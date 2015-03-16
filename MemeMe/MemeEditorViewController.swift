//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Antonio Maradiaga on 9/03/2015.
//  Copyright (c) 2015 Antonio Maradiaga. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var shareButton:UIBarButtonItem?
    var cancelButton:UIBarButtonItem?
    var editMeme:MemeObject?
    
    @IBOutlet var cameraBarButton:UIBarButtonItem?
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var editorToolbar: UIToolbar!
    @IBOutlet weak var editorNavigation: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var memeTextDelegate = MemeTextDelegate()
    
    let memeTextAttributes = [
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSFontAttributeName : UIFont(name:"Impact", size:36)!,
        NSStrokeWidthAttributeName : -3.0,
    ]
    
    // MARK: - Setup View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        shareButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "shareAction:")
        shareButton?.enabled = false
        self.navigationItem.leftBarButtonItem = shareButton
        
        cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "cancelAction:")
        self.navigationItem.rightBarButtonItem = cancelButton
       
        setTextField(topText)
        setTextField(bottomText)
        
        if editMeme != nil {
            topText.text = editMeme?.topText
            bottomText.text = editMeme?.bottomText
            memeImageView.image = editMeme?.originalImage
            self.shareButton?.enabled = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == false){
            cameraBarButton?.enabled = false
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardNotification:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setTextField(textField: UITextField){
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
        textField.delegate = memeTextDelegate
        textField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
    }
    
    // MARK: - UIBarButton Actions
    
    func cancelAction(sender:UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func shareAction(sender:UIBarButtonItem) {
        self.topText.resignFirstResponder()
        self.bottomText.resignFirstResponder()
        
        var memedImage = generateMemedImage()
        var shareActionView = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        shareActionView.completionWithItemsHandler = sharingCompleted
        self.presentViewController(shareActionView, animated: true, completion: nil)
    }
    
    func sharingCompleted(activityType:String!, completed:Bool, returnedItems:[AnyObject]!, activityError:NSError!) -> Void {
        if(completed){
            saveMeme()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func openCamera (sender:UIBarButtonItem) {
        let cameraView = UIImagePickerController()
        cameraView.sourceType = UIImagePickerControllerSourceType.Camera
        
        cameraView.allowsEditing = true
        cameraView.delegate = self
        
        self.presentViewController(cameraView, animated: true, completion: nil)
    }
    
    @IBAction func photoFromAlbum (sender:UIBarButtonItem) {
        let photoAlbumView = UIImagePickerController()
        photoAlbumView.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        photoAlbumView.allowsEditing = true
        photoAlbumView.delegate = self
        self.presentViewController(photoAlbumView, animated: true, completion: nil)
    }
    
    // MARK: - ImagePicker Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = image
            self.shareButton?.enabled = true
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var isKeyboardUp: Bool = false
    
    func handleKeyboardNotification(notification: NSNotification) {
        let keyboardHeight = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue().height
        
        if(notification.name == UIKeyboardDidShowNotification && bottomText.isFirstResponder() && isKeyboardUp == false) {
            self.view.frame.origin.y -= keyboardHeight
            isKeyboardUp = true
        } else if(notification.name == UIKeyboardWillHideNotification && bottomText.isFirstResponder() && isKeyboardUp == true) {
            self.view.frame.origin.y += keyboardHeight
            isKeyboardUp = false
        }
        
        UIView.commitAnimations()
    }
    
    // MARK: - Meme Object manipulation
    
    func saveMeme(){
        var meme = MemeObject(topText: self.topText.text, bottomText: self.bottomText.text, originalImage: self.memeImageView.image!, memedImage: self.generateMemedImage())
        
        (UIApplication.sharedApplication().delegate as AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage
    {
        hideNavigationAndToolbar(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        hideNavigationAndToolbar(false)
        
        return memedImage
    }
    
    func hideNavigationAndToolbar(b: Bool){
        editorToolbar.hidden = b
        self.navigationItem.titleView?.hidden = b
        
    }
}
