//
//  MemeEditorViewController.swift
//  MemeMe
//
//  This is the controller for the main view -- it contains the photo you are working on
//  and the top and bottom 'Meme' Text
//
//  Created by admin on 10/18/15.
//  Copyright © 2015 admin. All rights reserved.
//

import UIKit
import AVFoundation

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate,
UINavigationControllerDelegate {


    @IBOutlet weak var txtTop: UITextField!
    @IBOutlet weak var txtBottom: UITextField!
    @IBOutlet weak var btnShare: UIBarButtonItem!
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var toolbarBottom: UIToolbar!
    @IBOutlet weak var toolbarTop: UIToolbar!
    
    
    //Meme
    var memedImage: UIImage!
    var meme: Meme?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup the camera - enable button only if available
        btnCamera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    
        
        if let pastMeme = meme{
            setupTextfields(pastMeme.topTextField, textField: txtTop)
            setupTextfields(pastMeme.bottomTextField, textField: txtBottom)
            memeImageView.image = pastMeme.originalImage
            btnShare.enabled = true
        }else{
            setupTextfields("TOP", textField: txtTop)
            setupTextfields("BOTTOM", textField: txtBottom)
            btnShare.enabled = false
        }
        disableTextFields()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
        
    }
    
    func shareMeme() {
        
        let memeToShare = createMemeImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
         self.memeImageView.contentMode = .ScaleAspectFit
         self.memeImageView.image = image
         btnShare.enabled = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /* ToolBar Item Actions */
    
    @IBAction func itemAlbumPressed(sender: UIBarButtonItem) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .PhotoLibrary
        presentViewController(imagePickerController, animated: true, completion: nil)
        enableTextFields()
    }
    
    @IBAction func itemCameraPressed(sender: UIBarButtonItem) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .Camera
        presentViewController(imagePickerController, animated: true, completion: nil)
        enableTextFields()
    }
    

    @IBAction func sharePressed(sender: UIBarButtonItem) {
        shareMeme()
    }
    
    
    /* Text Field Methods */
    func setupTextfields(string: String, textField: UITextField){
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3
        ]
        
        textField.backgroundColor = UIColor.clearColor()
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
        textField.delegate = self
    }
    
    func disableTextFields(){
        txtTop.enabled = false
        txtBottom.enabled = false
    }
    
    func enableTextFields(){
        txtTop.enabled = true
        txtBottom.enabled = true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    //Dismiss Keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /* Keyboard functions to show and hide keyboard */
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    
    func unsubscribeFromKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        if txtBottom.isFirstResponder(){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if txtBottom.isFirstResponder(){
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    
    /* Create Meme Functionality */
    /* This is done by hiding the toolbars and saving the screen as an image */
    
    //Method to show/hide the toolbars
    func toolbarVisibility(visible: Bool){
        toolbarBottom.hidden = !visible
        toolbarTop.hidden = !visible
    }
    

    
    func createMemeImage()-> UIImage{
        //Hide toolbars
        toolbarVisibility(false)
        
        //render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memeImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbars
        toolbarVisibility(true)
        
        return memeImage
    }
    

}

