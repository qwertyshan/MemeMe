//
//  MemeEditViewController.swift
//  MemeMeVer2
//
//  Created by Shantanu Rao on 10/29/15.
//  Copyright © 2015 Shantanu Rao. All rights reserved.
//


import UIKit

class MemeEditViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePicker: UIBarButtonItem!
    @IBOutlet weak var cameraPicker: UIBarButtonItem!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    
    @IBOutlet weak var toolbarTop: UIToolbar!
    @IBOutlet weak var toolbarBottom: UIToolbar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var memeIndex: Int? = nil
    var meme: Meme? = nil
    
    override func viewWillAppear(animated: Bool) {
        cameraPicker.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        setView()
    }
    
    func setView() {
        // If existing meme is being edited, open that meme
        if let memeIndex = memeIndex {
            meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[memeIndex]
            imagePickerView.image = meme!.image
            imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
            
            setMemeTextAttributes(textTop)
            textTop.text = meme!.textTop
            textTop.hidden = false
            setMemeTextAttributes(textBottom)
            textBottom.text = meme!.textBottom
            textBottom.hidden = false
            toolbarTop.hidden = false
        }
        // Else, when memeIndex is nil, reset views
        else {
            imagePickerView.image = nil
            
            resetText(textTop)
            textTop.hidden = true
            resetText(textBottom)
            textBottom.hidden = true
            toolbarTop.hidden = true
        }
    }
    
    // MARK: Text Field Methods
    
    func memeTextAttributes() -> [String: AnyObject] {
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -2.0
        ]
        return memeTextAttributes
    }
    
    func resetText(textfield: UITextField){
        // Set attributed on placeholder text
        var position: String
        switch textfield {
        case textTop:
            position = "TOP"
        default:
            position = "BOTTOM"
        }
        textfield.attributedPlaceholder = NSAttributedString(string: position, attributes: self.memeTextAttributes())
        textfield.text = nil
        textfield.clearsOnBeginEditing = true
        setMemeTextAttributes(textfield)
    }
    
    func setMemeTextAttributes(textfield: UITextField){
        textfield.delegate = self
        textfield.defaultTextAttributes = memeTextAttributes()
        textfield.textAlignment = NSTextAlignment.Center
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.clearsOnBeginEditing {
            textField.text = ""
            textField.borderStyle=UITextBorderStyle.None
            textField.clearsOnBeginEditing = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("textFieldDidEndEditing")
        textField.resignFirstResponder()
    }
    
    // MARK: Keyboard notification methods
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    var shiftUp = false
    
    func keyboardWillShow(notification: NSNotification) {
        if textBottom.isFirstResponder() && !shiftUp {
            view.frame.origin.y -= getKeyboardHeight(notification)
            shiftUp = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if shiftUp {
            view.frame.origin.y += getKeyboardHeight(notification)
            shiftUp = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // MARK: IBAction methods
    
    enum ImageSource {  //Define image sources
        case Camera
        case Library
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        pickImage(ImageSource.Library)
    }
    
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        pickImage(ImageSource.Camera)
    }
    
    func pickImage (imageSource: ImageSource) {         // Helper function to select image from specified source
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        switch imageSource {
        case .Camera:
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        case .Library:
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject)  {
        let memedImage = generateMemedImage()
        let sharedImage = [memedImage as AnyObject]
        let activityVC = UIActivityViewController(activityItems: sharedImage, applicationActivities: nil)
        self.save()
        activityVC.completionWithItemsHandler = {
            (s: String?, b: Bool, a: [AnyObject]?, n: NSError?) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(activityVC, animated: true, completion: nil)
    }

    @IBAction func cancelMeme(sender: AnyObject) {
        
        // Return meme to initial configuration
        dismissViewControllerAnimated(true, completion: nil)
    }
 
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            dismissViewControllerAnimated(true, completion: nil)
            textTop.hidden = false
            textBottom.hidden = false
            toolbarTop.hidden = false
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {  
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save() {
        let memedImage = generateMemedImage()
        let memeToSave = Meme(textTop: textTop.text!, textBottom: textBottom.text!, image: imagePickerView.image!, memedImage: memedImage)
        
        // If meme is new, append to the memes array in the Application Delegate
        
        if self.memeIndex == nil {
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(memeToSave)
        } else {
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes[memeIndex!] = memeToSave
            self.memeIndex = nil
        }
    }
    
    func generateMemedImage() -> UIImage
    {
        toolbarTop.hidden = true
        toolbarBottom.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolbarTop.hidden = false
        toolbarBottom.hidden = false
        
        return memedImage
    }
    
}

