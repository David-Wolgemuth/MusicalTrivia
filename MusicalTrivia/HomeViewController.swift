//
//  HomeViewController1.swift
//  MusicalTrivia
//
//  Created by David Wolgemuth on 1/25/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, HomeTableViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    let imagePicker = UIImagePickerController()
    var embedTableView: HomeTableViewController?
    
    override func viewDidLoad()
    {
        imagePicker.delegate = self
        AudioPlayer.sharedInstance
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "EmbedTableView" {
            embedTableView = segue.destinationViewController as? HomeTableViewController
            embedTableView!.delegate = self
        }
    }
    func pickImage()
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        UserData.setUserImage(image)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

