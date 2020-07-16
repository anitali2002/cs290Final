//
//  SavedRecipesTableViewController.swift
//  ScotlandApp
//
//  Created by Anita Li on 4/2/20.
//  Copyright © 2020 Zhixue (Mary) Wang. All rights reserved.
//

import UIKit
import CoreData

class SavedRecipesTableViewController: UITableViewController {

    var context: NSManagedObjectContext?
    var savedRecipes: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        savedRecipes = []
        setUpCoreData()
        self.tableView.contentInset = UIEdgeInsets(top: 5,left: 0,bottom: 0,right: 0)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedRecipes = []
        setUpCoreData()
        self.tableView.reloadData()
    }
    
    func setUpCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedRecipe")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context?.fetch(request)
            print(result!.count)
            savedRecipes = (result! as? [NSManagedObject])!
        }
        catch{
            print("Error - CoreData failed reading")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.savedRecipes.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipeCell", for: indexPath) as! RecipeTableViewCell
        
        cell.recipeName.text = savedRecipes[indexPath.section].value(forKey: "name") as? String
        let urlString = savedRecipes[indexPath.section].value(forKey: "imageurl") as? String
        if urlString != nil && urlString != "" {
            let url = URL(string: urlString!)
            let data = try? Data(contentsOf: url!)
            cell.recipeImage?.image = UIImage(data: data!)
        }
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
    
    // Make the background color show through
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // Set the spacing between sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC = segue.destination as! RecipeViewController

        // Pass the selected object to the new view controller.
        let myRow = tableView!.indexPathForSelectedRow
        let myCurrCell = tableView!.cellForRow(at: myRow!) as! RecipeTableViewCell

        // set the destVC variables from the selected row
        destVC.id = savedRecipes[myRow!.section].value(forKey: "id") as? Int
        destVC.image = (myCurrCell.recipeImage!.image)!
        destVC.name = (myCurrCell.recipeName!.text)!
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
   

}
