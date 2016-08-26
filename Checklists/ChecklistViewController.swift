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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataModel.append(Checklist(WithTitle: "Promener le chien"))
            dataModel.append(Checklist(WithTitle: "Brosser mes dents"))
        dataModel.append(Checklist(WithTitle: "Apprendre à developper une app"))
        dataModel.append(Checklist(WithTitle: "M'entrainer pour le beer pong"))
        dataModel.append(Checklist(WithTitle: "Dormir"))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        cell.accessoryType = checklist.done ? .Checkmark : .None
        return cell
    }
}

extension ChecklistViewController {//: UITableViewDelegate{
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let checklist = self.dataModel[indexPath.row]
        checklist.done = !checklist.done
        
        //tableView.reloadData()//Redemande la datasource et donc met à jour
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}

