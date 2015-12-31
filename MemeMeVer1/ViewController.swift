//
//  ViewController.swift
//  MemeMeVer1
//
//  Created by Shantanu Rao on 10/29/15.
//  Copyright © 2015 Shantanu Rao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePicker: UIBarButtonItem!
    @IBOutlet weak var cameraPicker: UIBarButtonItem!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    
    @IBOutlet weak var toolbarTop: UIToolbar!
    @IBOutlet weak var toolbarBottom: UIToolbar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewWillAppear(animated: Bool) {
        cameraPicker.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        resetView()
    }
    
    func resetView() {
        imagePickerView.image = nil
        print(imagePicker.image)
        setText(textTop)
        textTop.hidden = true
        setText(textBottom)
        textBottom.hidden = true
        toolbarTop.hidden = true
    }
    
    // MARK: Text Field Methods
    
    func setText(textfield: UITextField){
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -2.0
        ]
        // Set attributed on placeholder text
        switch textfield {
        case textTop:
            textfield.attributedPlaceholder = NSAttributedString(string: "TOP", attributes: memeTextAttributes)
        default:
            textfield.attributedPlaceholder = NSAttributedString(string: "BOTTOM", attributes: memeTextAttributes)
        }
        textfield.delegate = self
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.text = nil
        textfield.clearsOnBeginEditing = true
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
        activityVC.completionWithItemsHandler = {
            (s: String?, b: Bool, a: [AnyObject]?, n: NSError?) -> Void in
            self.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(sender: AnyObject) {
        resetView()
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
    
    func save() -> Meme {
        let memedImage = generateMemedImage()
        let meme = Meme(textTop: textTop.text!, textBottom: textBottom.text!, image: imagePickerView.image!, memedImage: memedImage)
        return meme
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

