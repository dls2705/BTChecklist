//
//  ViewController.swift
//  Checklists
//
//  Created by Diego Legua on 26/08/16.
//  Copyright © 2016 DL.Training. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var dataModel = [Checklist]()
    var indexPathToEdit:NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* REPLACED BY LOADCHECKLIST()
 
        dataModel.append(Checklist(WithTitle: "Promener le chien"))
        dataModel.append(Checklist(WithTitle: "Brosser mes dents"))
        dataModel.append(Checklist(WithTitle: "Apprendre à developper une app"))
        dataModel.append(Checklist(WithTitle: "M'entrainer pour le beer pong"))
        dataModel.append(Checklist(WithTitle: "Dormir"))
        */
        
        loadChecklist()
        
        print("Documents directory: \(documentsDirectory())")
        print("Data file path: \(dataFilePath())")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addItem(list: Checklist){
        dataModel.append(list)
        let indexPath = NSIndexPath(forRow: dataModel.count - 1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addItemSegue"{
            if let navigationController = segue.destinationViewController as? UINavigationController{
                if let addItemViewController = navigationController.topViewController as? AddItemViewController{
                    addItemViewController.addItemViewControllerDelegate = self
                }
            }
        }else if segue.identifier == "editItemSegue"{
            if let navigationController = segue.destinationViewController as? UINavigationController{
                if let addItemViewController = navigationController.topViewController as? AddItemViewController{
                    if let indexPath = self.tableView.indexPathForCell(sender as! UITableViewCell){
                        addItemViewController.addItemViewControllerDelegate = self
                        addItemViewController.checklistToEdit = dataModel[indexPath.row]
                    }
                    
                }
            }
            
        }
    }
    
    //DATA PERSISTANCE
    func documentsDirectory()->String{
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return (documentsDirectory() as NSString).stringByAppendingPathComponent("Checklist.plist")
    }
    
    func saveChecklists(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(dataModel, forKey: "Checklist")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadChecklist(){
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path){
            if let data = NSData(contentsOfFile: path){
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                defer{
                    unarchiver.finishDecoding()
                }
                self.dataModel = unarchiver.decodeObjectForKey("Checklist") as! [Checklist]
            }
        }
    }
    
    
}

extension ChecklistViewController: AddItemViewControllerDelegate{
    func addItemViewControllerDidCancel(controller: AddItemViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addItemViewController(controller: AddItemViewController, didFinishAddingItem item: Checklist) {
        addItem(item)
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        saveChecklists()
    }
    
    func addItemViewController(controller: AddItemViewController, didFinishEditingItem item: Checklist) {
        
        if let index = dataModel.indexOf({checklist in return checklist === item})
        {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
        saveChecklists()
    }
}

extension ChecklistViewController {//: UITableViewDataSource{
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int{
        return dataModel.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("CheckListItem", forIndexPath: indexPath)
        let label = cell.viewWithTag(1000) as! UILabel
        let checklist = dataModel[indexPath.row]
        label.text = checklist.title
        
        //cell.accessoryType = checklist.done ? .Checkmark : .None
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        saveChecklists()
    }
}

extension ChecklistViewController { //: UITableViewDelegate{
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let checklist = self.dataModel[indexPath.row]
        checklist.done = !checklist.done
        
        //tableView.reloadData()//Redemande la datasource et donc met à jour
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        saveChecklists()
        
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

