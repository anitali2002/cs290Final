//
//  WelcomeViewController.swift
//  ScotlandApp
//
//  Created by Zhixue (Mary) Wang on 4/14/20.
//  Copyright © 2020 Zhixue (Mary) Wang. All rights reserved.
//

import UIKit
import CoreData

class WelcomeViewController: UIViewController, UITextFieldDelegate {
    
    var context: NSManagedObjectContext?
    var profile: NSManagedObject!

    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    
    var profileParent: ProfileViewController?
    
    @IBAction func retNewuser(_ sender: UIButton) {
        let name = (firstname.text ?? "Jane") + " " + (lastname.text ?? "Doe")
        profileParent?.userName.text = name
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Profile")
        request.returnsObjectsAsFaults = false
            
        do{
            var result = try context?.fetch(request)
            if(result!.count == 0){
                let entity = NSEntityDescription.entity(forEntityName: "Profile", in: context!)
                let newProfile = NSManagedObject(entity: entity!, insertInto: context)
                    
                newProfile.setValue(name, forKey: "name")
                newProfile.setValue("No allergies", forKey: "allergies")
                newProfile.setValue("No special diets", forKey: "diets")
                newProfile.setValue("No preferences", forKey: "preferences")
                    
                do{
                    try context!.save()
                }
                catch{
                    print("Error - CoreData failed saving")
                }
                    result = try context?.fetch(request)
            }
            print(result!.count)
            profile = result![0] as? NSManagedObject
                    
        }
        catch{
            print("Error - CoreData failed reading")
        }
            
        profile.setValue(name, forKey: "name")
        do{
            try context!.save()
        }
        catch{
            print("Error - CoreData failed saving")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstname.delegate = self
        lastname.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
