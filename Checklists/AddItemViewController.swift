//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Diego Legua on 29/08/16.
//  Copyright © 2016 DL.Training. All rights reserved.
//

import UIKit

protocol AddItemViewControllerDelegate : class {//Le protocole est limité à des implementations de type class, ceci permet d'utiliser le "weak"
    func addItemViewControllerDidCancel(controller:AddItemViewController)
    func addItemViewController(controller:AddItemViewController, didFinishAddingItem:Checklist)
    func addItemViewController(controller:AddItemViewController, didFinishEditingItem: Checklist)
    
}

/*
 Delegation
 1. Définir le protocole (:class)
 2. Ajouter une propriété délégate au VC enfant (weak)
 3. Appeler les méthodes du delegate dans le VC enfant quand quelque chose se passe
 4. Implementer le protocole dans VC parent
 5. Connecter le VC parent comme delegate du VC enfant
 */

class AddItemViewController: UITableViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    weak var addItemViewControllerDelegate: AddItemViewControllerDelegate?
    var checklistToEdit:Checklist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklistToEdit = self.checklistToEdit{
            textField.text = checklistToEdit.title
            self.title = "Edit item"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
        doneButton.enabled = textField.text!.characters.count > 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(){
        if let AddItemViewControllerDelegate = self.addItemViewControllerDelegate{
            AddItemViewControllerDelegate.addItemViewControllerDidCancel(self)
        }
    }
    
    @IBAction func save(){
        
        let title = self.textField.text
        let trimmedTitle = title?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if trimmedTitle?.characters.count == 0{
            let alert = UIAlertController(title: "Error", message: "Title Empty", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(okAction)
            
            self.presentViewController(alert, animated: true, completion:nil)
            
            return
        }else{
            if let addItemViewControllerDelegate = self.addItemViewControllerDelegate{
                if let checklistToEdit = self.checklistToEdit{
                    checklistToEdit.title = trimmedTitle!
                    addItemViewControllerDelegate.addItemViewController(self, didFinishEditingItem: checklistToEdit)
                }else{
                    let checklist = Checklist(WithTitle: trimmedTitle!)
                    addItemViewControllerDelegate.addItemViewController(self, didFinishAddingItem: checklist)
                }
            }
        }
    }
    

}

//UITableViewDelegate implementation
extension AddItemViewController{
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
}

extension AddItemViewController:UITextFieldDelegate{
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let newText = (oldText as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if newText.characters.count > 0{
            doneButton.enabled = true
        } else {
            doneButton.enabled = false
        }
        return true
    }
}

