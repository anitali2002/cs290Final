//
//  FridgeTableViewController.swift
//  ScotlandApp
//
//  Created by Anita Li on 4/2/20.
//  Copyright © 2020 Zhixue (Mary) Wang. All rights reserved.
//

import UIKit
import CoreData

class MyCustomHeader: UITableViewHeaderFooterView {
    let title = UILabel()
    let image = UIImageView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureContents() {
        image.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(image)
        contentView.addSubview(title)
        contentView.backgroundColor = UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true

        // Center the image vertically and place it near the leading
        // edge of the view. Constrain its width and height to 30 points.
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            image.widthAnchor.constraint(equalToConstant: 30),
            image.heightAnchor.constraint(equalToConstant: 30),
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        
            // Center the label vertically, and use it to fill the remaining
            // space in the header view.
            title.heightAnchor.constraint(equalToConstant: 30),
            title.leadingAnchor.constraint(equalTo: image.trailingAnchor,
                   constant: 15),
            title.trailingAnchor.constraint(equalTo:
                   contentView.layoutMarginsGuide.trailingAnchor),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        title.font = UIFont.boldSystemFont(ofSize: 18)
    }
}

class FridgeTableViewController: UITableViewController {
    
    @IBAction func barButton(_ sender: UIBarButtonItem) {
        showInputDialog()
    }
    @IBAction func quantChange(_ sender: UIStepper) {
        let position = sender.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: position)
        let cell = self.tableView.cellForRow(at: indexPath!) as! FridgeTableViewCell
        
        quantity[indexPath!.section][indexPath!.row] = Int(cell.quantity.text ?? "0") ?? 0
        
        if (quantity[indexPath!.section][indexPath!.row] == 0) {
            showGroceryDialog(food: fridge[indexPath!.section][indexPath!.row])
        }
    }
    
    var context: NSManagedObjectContext?
    var fridge_data: NSManagedObject!
    var grocery_data: NSManagedObject!
    
    var fridge : [[String]] = [[],["Lettuce (heads)", "Cabbage (heads)", "Broccoli (heads)", "Potato"],
                               ["Apple", "Orange", "Strawberry"],
                               ["Bread (loaves)", "Rice (lbs)"],
                               ["Chicken", "Beef"],
                               ["Milk (gallons)", "Cheese (lbs)", "Yogurt"],
                               ["Tuna (oz)", "Shrimp (lbs)"],
                               ["Pepper (oz)", "Salt (oz)", "Sugar (lbs)"],
                               ["Vegetable oil (fl oz)"]]
    
    var quantity : [[Int]] = [[],[0, 0, 0, 0],
                                 [0, 0, 0],
                                 [0, 0],
                                 [0, 0],
                                 [0, 0, 0],
                                 [0, 0],
                                 [0, 0, 0],
                                 [0]]
    
    var names : [String] = ["", "Vegetables", "Fruits", "Grains", "Meat and Poultry", "Dairy", "Seafood", "Spice", "Other"]
    
    var sectionImages : [String] = ["", "carrot", "apple", "bread", "meat", "cheese", "seafood", "spice", "other"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.init(red: 149/255, green: 239/255, blue: 99/255, alpha: 1)
        self.navigationItem.title = "Virtual Fridge";
        self.tableView.contentInset = UIEdgeInsets(top: 5,left: 0,bottom: 0,right: 0)
        
        setUpCoreData()
        
        self.tableView.register(MyCustomHeader.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveCoreData()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! MyCustomHeader
        
        if (section == 0) {
            return view
        }
        
        view.title.text = names[section]
        view.image.image = UIImage(named: sectionImages[section])

        return view
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let itemToMove = fridge[sourceIndexPath.section][sourceIndexPath.row]
        fridge[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        fridge[destinationIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)
        
        let valToMove = quantity[sourceIndexPath.section][sourceIndexPath.row]
        quantity[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        quantity[destinationIndexPath.section].insert(valToMove, at: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            fridge[indexPath.section].remove(at: indexPath.row)
            quantity[indexPath.section].remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        // try to implement sections for the different types of foods?
        return 9
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if (section == 0) {
            return 0
        }
        return fridge[section].count
    }
    
    /*
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return names[section]
    }
 */

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FridgeCell", for: indexPath) as! FridgeTableViewCell

        // Configure the cell...
        if (indexPath.section == 0) {
            return cell
        }
        cell.name.text = fridge[indexPath.section][indexPath.row]
        cell.quantity.text = String(quantity[indexPath.section][indexPath.row])
        cell.stepper.value = Double(quantity[indexPath.section][indexPath.row])

        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showInputDialog() {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Went shopping?", message: "Let's add your groceries to the fridge!", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            let category = alertController.textFields?[0].text
            let name = alertController.textFields?[1].text
            let amount = alertController.textFields?[2].text
            var section : Int
            
            switch category {
            case "Vegetables":
                section = 1
            case "Vegetable":
                section = 1
            case "Veggies":
                section = 1
            case "Fruit":
                section = 2
            case "Fruits":
                section = 2
            case "Grain":
                section = 3
            case "Grains":
                section = 3
            case "Meat":
                section = 4
            case "Poultry":
                section = 4
            case "Meat and poultry":
                section = 4
            case "Dairy":
                section = 5
            case "Seafood":
                section = 6
            case "Spice":
                section = 7
            default:
                section = 8
            }
            
            self.fridge[section].append(name!)
            self.quantity[section].append(Int(amount!)!)
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [
                (NSIndexPath(row: self.fridge[section].count-1, section: section) as IndexPath)], with: .automatic)
            self.tableView.endUpdates()
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter category here"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter food name and units here"
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
    
    func showGroceryDialog(food: String) {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Used up your groceries?", message: "Let's add "
            + food.lowercased() + " to your shopping list for the next supermarket run!", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.context = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Groceries")
            request.returnsObjectsAsFaults = false
            do{
                var result = try self.context?.fetch(request)
                if(result!.count == 0){
                    let entity = NSEntityDescription.entity(forEntityName: "Groceries", in: self.context!)
                    let newGroceries = NSManagedObject(entity: entity!, insertInto: self.context)
                    
                    newGroceries.setValue("Water (2 gallons); Eggs (1 dozen); " + food.lowercased(), forKey: "buylist")
                    newGroceries.setValue("true; true; true", forKey: "notdone")
                    
                    do {
                        try self.context!.save()
                    }
                    catch {
                        print("Error - CoreData failed saving")
                    }
                    result = try self.context?.fetch(request)
                }
                self.grocery_data = result![0] as? NSManagedObject
                
                let tobuys = (self.grocery_data?.value(forKey: "buylist") as? String)?.components(separatedBy: "; ") ?? []
                if (tobuys == [""]) {
                    self.grocery_data.setValue(food.lowercased(), forKey: "buylist")
                } else {
                    self.grocery_data.setValue(tobuys.joined(separator: "; ") + "; " + food.lowercased(), forKey: "buylist")
                }
                
                var incomplete : [Bool] = []
                let incompleteStr : [String]  = (self.grocery_data.value(forKey: "notdone") as? String)?.components(separatedBy: "; ") ?? []
                for str in incompleteStr {
                    if (str == "true") {
                        incomplete.append(true)
                    } else if (str == "false"){
                        incomplete.append(false)
                    }
                }
                incomplete.append(true)
                var incompleteSave : [String] = []
                for b in incomplete {
                    if (b) {
                        incompleteSave.append("true")
                    } else {
                        incompleteSave.append("false")
                    }
                }
                self.grocery_data.setValue(incompleteSave.joined(separator: "; "), forKey: "notdone")
                        
                do {
                    try self.context!.save()
                }
                catch {
                    print("Error - CoreData failed saving")
                }
                
            }
            catch {
                print("Error - CoreData failed reading")
            }
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Not now", style: .cancel) { (_) in }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setUpCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Fridge")
        request.returnsObjectsAsFaults = false
        do{
            var result = try context?.fetch(request)
            if(result!.count == 0){
                let entity = NSEntityDescription.entity(forEntityName: "Fridge", in: context!)
                let newFridge = NSManagedObject(entity: entity!, insertInto: context)
                
                newFridge.setValue("Lettuce (heads); Cabbage (heads); Broccoli (heads); Potato", forKey: "veggies")
                newFridge.setValue("Apple; Orange; Strawberry", forKey: "fruit")
                newFridge.setValue("Bread (loaves); Rice (lbs)", forKey: "grain")
                newFridge.setValue("Chicken; Beef", forKey: "meat")
                newFridge.setValue("Milk (gallons); Cheese (lbs); Yogurt", forKey: "dairy")
                newFridge.setValue("Tuna (oz); Shrimp (lbs)", forKey: "seafood")
                newFridge.setValue("Pepper (oz); Salt (oz); Sugar (lbs)", forKey: "spice")
                newFridge.setValue("Vegetable oil (fl oz)", forKey: "other")
                
                newFridge.setValue("0; 0; 0; 0", forKey: "num_veggies")
                newFridge.setValue("0; 0; 0", forKey: "num_fruit")
                newFridge.setValue("0; 0", forKey: "num_grain")
                newFridge.setValue("0; 0", forKey: "num_meat")
                newFridge.setValue("0; 0; 0", forKey: "num_dairy")
                newFridge.setValue("0; 0", forKey: "num_seafood")
                newFridge.setValue("0; 0; 0", forKey: "num_spice")
                newFridge.setValue("0", forKey: "num_other")
                
                do {
                    try context!.save()
                }
                catch {
                    print("Error - CoreData failed saving")
                }
                result = try context?.fetch(request)
            }
            fridge_data = result![0] as? NSManagedObject
            
            if let food = (fridge_data.value(forKey: "veggies") as? String)?.components(separatedBy: "; ") {
                if (food == [""]) {
                    self.fridge[1] = []
                } else {
                    self.fridge[1] = food
                }
            } else {
                self.fridge[1] = []
            }
            if let food = (fridge_data.value(forKey: "fruit") as? String)?.components(separatedBy: "; ") {
                if (food == [""]) {
                    self.fridge[2] = []
                } else {
                    self.fridge[2] = food
                }
            } else {
                self.fridge[2] = []
            }
            if let food = (fridge_data.value(forKey: "grain") as? String)?.components(separatedBy: "; ") {
                if (food == [""]) {
                    self.fridge[3] = []
                } else {
                    self.fridge[3] = food
                }
            } else {
                self.fridge[3] = []
            }
            if let food = (fridge_data.value(forKey: "meat") as? String)?.components(separatedBy: "; ") {
                if (food == [""]) {
                    self.fridge[4] = []
                } else {
                    self.fridge[4] = food
                }
            } else {
                self.fridge[4] = []
            }
            if let food = (fridge_data.value(forKey: "dairy") as? String)?.components(separatedBy: "; ") {
                if (food == [""]) {
                    self.fridge[5] = []
                } else {
                    self.fridge[5] = food
                }
            } else {
                self.fridge[5] = []
            }
            if let food = (fridge_data.value(forKey: "seafood") as? String)?.components(separatedBy: "; ") {
                if (food == [""]) {
                    self.fridge[6] = []
                } else {
                    self.fridge[6] = food
                }
            } else {
                self.fridge[6] = []
            }
            if let food = (fridge_data.value(forKey: "spice") as? String)?.components(separatedBy: "; ") {
                if (food == [""]) {
                    self.fridge[7] = []
                } else {
                    self.fridge[7] = food
                }
            } else {
                self.fridge[7] = []
            }
            if let food = (fridge_data.value(forKey: "other") as? String)?.components(separatedBy: "; ") {
                if (food == [""]) {
                    self.fridge[8] = []
                } else {
                    self.fridge[8] = food
                }
            } else {
                self.fridge[8] = []
            }
            
            if let num = (fridge_data.value(forKey: "num_veggies") as? String)?.components(separatedBy: "; ") {
                if (num == [""]) {
                    self.quantity[1] = []
                } else {
                    self.quantity[1] = num.map { (Int($0)!)}
                }
            } else {
                self.quantity[1] = []
            }
            if let num2 = (fridge_data.value(forKey: "num_fruit") as? String)?.components(separatedBy: "; ") {
                if (num2 == [""]) {
                    self.quantity[2] = []
                } else {
                    self.quantity[2] = num2.map { (Int($0)!)}
                }
            } else {
                self.quantity[2] = []
            }
            if let num3 = (fridge_data.value(forKey: "num_grain") as? String)?.components(separatedBy: "; ") {
                if (num3 == [""]) {
                    self.quantity[3] = []
                } else {
                    self.quantity[3] = num3.map { (Int($0)!)}
                }
            } else {
                self.quantity[3] = []
            }
            if let num4 = (fridge_data.value(forKey: "num_meat") as? String)?.components(separatedBy: "; ") {
                if (num4 == [""]) {
                    self.quantity[4] = []
                } else {
                    self.quantity[4] = num4.map { (Int($0)!)}
                }
            } else {
                self.quantity[4] = []
            }
            if let num5 = (fridge_data.value(forKey: "num_dairy") as? String)?.components(separatedBy: "; ") {
                if (num5 == [""]) {
                    self.quantity[5] = []
                } else {
                    self.quantity[5] = num5.map { (Int($0)!)}
                }
            } else {
                self.quantity[5] = []
            }
            if let num6 = (fridge_data.value(forKey: "num_seafood") as? String)?.components(separatedBy: "; ") {
                if (num6 == [""]) {
                    self.quantity[6] = []
                } else {
                    self.quantity[6] = num6.map { (Int($0)!)}
                }
            } else {
                self.quantity[6] = []
            }
            if let num7 = (fridge_data.value(forKey: "num_spice") as? String)?.components(separatedBy: "; ") {
                if (num7 == [""]) {
                    self.quantity[7] = []
                } else {
                    self.quantity[7] = num7.map { (Int($0)!)}
                }
            } else {
                self.quantity[7] = []
            }
            if let num8 = (fridge_data.value(forKey: "num_other") as? String)?.components(separatedBy: "; ") {
                if (num8 == [""]) {
                    self.quantity[8] = []
                } else {
                    self.quantity[8] = num8.map { (Int($0)!)}
                }
            } else {
                self.quantity[8] = []
            }
        }
        catch {
            print("Error - CoreData failed reading")
        }
    }
    
    func saveCoreData(){
        fridge_data.setValue(self.fridge[1].joined(separator: "; "), forKey: "veggies")
        fridge_data.setValue(self.fridge[2].joined(separator: "; "), forKey: "fruit")
        fridge_data.setValue(self.fridge[3].joined(separator: "; "), forKey: "grain")
        fridge_data.setValue(self.fridge[4].joined(separator: "; "), forKey: "meat")
        fridge_data.setValue(self.fridge[5].joined(separator: "; "), forKey: "dairy")
        fridge_data.setValue(self.fridge[6].joined(separator: "; "), forKey: "seafood")
        fridge_data.setValue(self.fridge[7].joined(separator: "; "), forKey: "spice")
        fridge_data.setValue(self.fridge[8].joined(separator: "; "), forKey: "other")
                
        fridge_data.setValue(self.quantity[1].map { "\($0)" }.joined(separator: "; "), forKey: "num_veggies")
        fridge_data.setValue(self.quantity[2].map { "\($0)" }.joined(separator: "; "), forKey: "num_fruit")
        fridge_data.setValue(self.quantity[3].map { "\($0)" }.joined(separator: "; "), forKey: "num_grain")
        fridge_data.setValue(self.quantity[4].map { "\($0)" }.joined(separator: "; "), forKey: "num_meat")
        fridge_data.setValue(self.quantity[5].map { "\($0)" }.joined(separator: "; "), forKey: "num_dairy")
        fridge_data.setValue(self.quantity[6].map { "\($0)" }.joined(separator: "; "), forKey: "num_seafood")
        fridge_data.setValue(self.quantity[7].map { "\($0)" }.joined(separator: "; "), forKey: "num_spice")
        fridge_data.setValue(self.quantity[8].map { "\($0)" }.joined(separator: "; "), forKey: "num_other")
                
        do {
            try context!.save()
        }
        catch {
            print("Error - CoreData failed saving")
        }
    }

}
