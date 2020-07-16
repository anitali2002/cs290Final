//
//  GroceryTableViewController.swift
//  ScotlandApp
//
//  Created by Zhixue (Mary) Wang on 4/8/20.
//  Copyright © 2020 Zhixue (Mary) Wang. All rights reserved.
//

import UIKit
import CoreData

class GroceryTableViewController: UITableViewController {
    @IBAction func groceryAdd(_ sender: Any) {
        showInputDialog()
    }
    
    @IBAction func changeSwitch(_ sender: UISwitch) {
        let position = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: position)
        
        incomplete[indexPath!.row] = !incomplete[indexPath!.row]
    }
    
    var context: NSManagedObjectContext?
    var grocery_data: NSManagedObject!
    
    var tobuys : [String] = ["Water (2 gallons)", "Eggs (1 dozen)"]
    var incomplete : [Bool] = [true, true]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.init(red: 149/255, green: 239/255, blue: 99/255, alpha: 1)
        self.navigationItem.title = "Grocery list";
        
        setUpCoreData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpCoreData()
        self.tableView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        saveCoreData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return incomplete.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Items to buy"
    }
       
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
       
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
           
        let itemToMove = tobuys[sourceIndexPath.row]
        tobuys.remove(at: sourceIndexPath.row)
        tobuys.insert(itemToMove, at: destinationIndexPath.row)
           
        let valToMove = incomplete[sourceIndexPath.row]
        incomplete.remove(at: sourceIndexPath.row)
        incomplete.insert(valToMove, at: destinationIndexPath.row)
    }
       
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            tobuys.remove(at: indexPath.row)
            incomplete.remove(at: indexPath.row)
               
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }

     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath) as! GroceryTableViewCell

           // Configure the cell...
        cell.foodItem.text = tobuys[indexPath.row]
        cell.incomplete.setOn(incomplete[indexPath.row], animated: false)

        return cell
    }
       
    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Out of groceries?", message: "Let's keep track of the groceries you need to buy by adding them here!", preferredStyle: .alert)
           
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
               
            //getting the input values from user
            let food = alertController.textFields?[0].text
            let amt = alertController.textFields?[1].text
            
            let display = food! + " (" + amt! + ")"
               
            self.tobuys.append(display)
            self.incomplete.append(true)
               
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [
                (NSIndexPath(row: self.tobuys.count-1, section: 0) as IndexPath)], with: .automatic)
            self.tableView.endUpdates()
               
        }
           
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
           
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter grocery here"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter quantity here"
        }
           
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
           
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setUpCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Groceries")
        request.returnsObjectsAsFaults = false
        do{
            var result = try context?.fetch(request)
            if(result!.count == 0){
                let entity = NSEntityDescription.entity(forEntityName: "Groceries", in: context!)
                let newGroceries = NSManagedObject(entity: entity!, insertInto: context)
                
                newGroceries.setValue("Water (2 gallons); Eggs (1 dozen)", forKey: "buylist")
                newGroceries.setValue("true; true", forKey: "notdone")
                
                do {
                    try context!.save()
                }
                catch {
                    print("Error - CoreData failed saving")
                }
                result = try context?.fetch(request)
            }
            grocery_data = result![0] as? NSManagedObject
            
            self.tobuys = (grocery_data.value(forKey: "buylist") as? String)?.components(separatedBy: "; ") ?? []
            
            self.incomplete = []
            let incompleteStr : [String]  = (grocery_data.value(forKey: "notdone") as? String)?.components(separatedBy: "; ") ?? []
            for str in incompleteStr {
                if (str == "true") {
                    self.incomplete.append(true)
                } else if (str == "false"){
                    self.incomplete.append(false)
                }
            }
            
            if (self.incomplete.count == 0) {
                self.tobuys = []
            }
        }
        catch {
            print("Error - CoreData failed reading")
        }
    }
    
    func saveCoreData(){
        grocery_data.setValue(self.tobuys.joined(separator: "; "), forKey: "buylist")
        
        var incompleteStr : [String] = []
        for b in incomplete {
            if (b) {
                incompleteStr.append("true")
            } else {
                incompleteStr.append("false")
            }
        }
        grocery_data.setValue(incompleteStr.joined(separator: "; "), forKey: "notdone")
                
        do {
            try context!.save()
        }
        catch {
            print("Error - CoreData failed saving")
        }
    }

}
