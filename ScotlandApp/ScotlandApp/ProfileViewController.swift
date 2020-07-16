//
//  ProfileViewController.swift
//  ScotlandApp
//
//  Created by Belanie Nagiel on 4/1/20.
//  Copyright © 2020 Zhixue (Mary) Wang. All rights reserved.
//

import UIKit
import HealthKit
import CoreData

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    
    @IBOutlet weak var profileScroll: UIScrollView!
    @IBOutlet weak var bannerTop: UILabel!
    @IBOutlet weak var userNameTop: NSLayoutConstraint!
    var firstUserBool: Bool!
    
    var context: NSManagedObjectContext?
    var profile: NSManagedObject!
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var userImage: UIImageView!
    @IBAction func uploadImage(_ sender: Any) {
        print("uploading image...")
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            userImage.image = image
            profile.setValue(image.pngData() as NSData?, forKey: "image")
            do{
                try context!.save()
            }
            catch{
                print("Error - CoreData failed saving")
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var userName: UITextView!
    var nameEditingMode = false
    @IBOutlet weak var nameButton: UIButton!
    @IBAction func editName(_ sender: UIButton) {
        print("editing name...")
        
        nameEditingMode = !nameEditingMode
        if(nameEditingMode){
            sender.setTitle("Done", for: .normal)
            userName.isEditable = true
        }
        else{
            sender.setTitle("Edit", for: .normal)
            userName.isEditable = false
            profile.setValue(userName.text, forKey: "name")
            do{
                try context!.save()
            }
            catch{
                print("Error - CoreData failed saving")
            }
            
            if (userName.contentSize.height > 75) {
                 while userName.contentSize.height > 75 {
                     userName.font = UIFont.init(name: userName.font?.fontName ?? "Arial", size: (userName.font?.pointSize ?? 25) - 1)
                 }
             } else if (userName.contentSize.height < 70){
                 while userName.contentSize.height < 70 {
                     userName.font = UIFont.init(name: userName.font?.fontName ?? "Arial", size: (userName.font?.pointSize ?? 25) + 1)
                 }
             }
        }
    }
    
    @IBOutlet weak var allergyList: UITextView!
    @IBOutlet weak var dietList: UITextView!
    @IBOutlet weak var preferenceList: UITextView!
    
    var allergiesFromHealthKit = ""
    
    @IBOutlet weak var allergyButton: UIButton!
    var allergyEditingMode = false
    @IBAction func editAllergies(_ sender: UIButton) {
        print("editing allergies...")
        
        allergyEditingMode = !allergyEditingMode
        if(allergyEditingMode){
            sender.setTitle("Done", for: .normal)
            allergyList.isEditable = true
        }
        else{
            sender.setTitle("Edit", for: .normal)
            allergyList.isEditable = false
            profile.setValue(allergyList.text, forKey: "allergies")
            do{
                try context!.save()
            }
            catch{
                print("Error - CoreData failed saving")
            }
        }
    }
    @IBAction func fetchAllergiesFromHealthKit(_ sender: Any) {
        print("fetching allergies from healthkit...")
        let healthKitStore = HKHealthStore()
        do{
            guard let allergyType = HKObjectType.clinicalType(forIdentifier: .allergyRecord) else {
                fatalError("*** Unable to create the allergy type ***")
            }
            
            let allergyQuery = HKSampleQuery(sampleType: allergyType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
                
                guard let actualSamples = samples else {
                    // Handle the error here.
                    print("*** An error occurred: \(error?.localizedDescription ?? "nil") ***")
                    return
                }
                
                let allergySamples = actualSamples as? [HKClinicalRecord]
                var allAllergies: [String] = []
                for item in allergySamples!{
                    allAllergies.append(item.displayName)
                }
                self.allergiesFromHealthKit = allAllergies.joined(separator: ",")
                if ((self.profile.value(forKey: "allergies") as? String == "No allergies") || ((self.profile.value(forKey: "allergies") as? String)!.count == 0)){
                    self.profile.setValue(self.allergiesFromHealthKit, forKey: "allergies")
                    if(self.allergiesFromHealthKit.count > 0){
                        DispatchQueue.main.async{
                            self.allergyList.text  = self.allergiesFromHealthKit
                        }
                    }
                    print("allergies: " + self.allergiesFromHealthKit)
                }
                else{
                    var array = (self.profile.value(forKey: "allergies") as? String)?.components(separatedBy: ",")
                    let curAllergies = self.allergiesFromHealthKit.components(separatedBy: ",")
                    for item in curAllergies{
                        if !array!.contains(item){
                            array!.append(item)
                        }
                    }
                    self.allergiesFromHealthKit = (array?.joined(separator: ","))!
                    self.profile.setValue(self.allergiesFromHealthKit, forKey: "allergies")
                    if(self.allergiesFromHealthKit.count > 0){
                        DispatchQueue.main.async{
                            self.allergyList.text  = self.allergiesFromHealthKit
                        }
                    }
                    
                }
                do{
                    try self.context!.save()
                }
                catch{
                    print("Error - CoreData failed saving")
                }
            }
            healthKitStore.execute(allergyQuery)
        }
    }
    
    @IBOutlet weak var dietButton: UIButton!
    var dietEditingMode = false
    @IBAction func editDiet(_ sender: UIButton) {
        print("editing dietary restrictions...")
        
        dietEditingMode = !dietEditingMode
        if(dietEditingMode){
            sender.setTitle("Done", for: .normal)
            dietList.isEditable = true
        }
        else{
            sender.setTitle("Edit", for: .normal)
            dietList.isEditable = false
            profile.setValue(dietList.text, forKey: "diets")
            do{
                try context!.save()
            }
            catch{
                print("Error - CoreData failed saving")
            }
        }
    }
    
    @IBOutlet weak var preferenceButton: UIButton!
    var preferenceEditingMode = false
    @IBAction func editPreferences(_ sender: UIButton) {
        print("editing preferences...")
        
        preferenceEditingMode = !preferenceEditingMode
        if(preferenceEditingMode){
            sender.setTitle("Done", for: .normal)
            preferenceList.isEditable = true
        }
        else{
            sender.setTitle("Edit", for: .normal)
            preferenceList.isEditable = false
            profile.setValue(preferenceList.text, forKey: "preferences")
            do{
                try context!.save()
            }
            catch{
                print("Error - CoreData failed saving")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
        authorizeHealthKit()
        
        firstUserBool = false
        setUpCoreData()
        
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        
        userName.usesStandardTextScaling = true
        userName.adjustsFontForContentSizeCategory = true
        
        if (userName.contentSize.height > 75) {
            while userName.contentSize.height > 75 {
                userName.font = UIFont.init(name: userName.font?.fontName ?? "Arial", size: (userName.font?.pointSize ?? 25) - 1)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        super.viewWillAppear(animated)
        
        let windowWidth = UIScreen.main.bounds.width
        let contentHeight = profileScroll.bounds.height*1.1
        
        profileScroll.contentSize = CGSize(width: windowWidth, height: contentHeight)
        
        if (userName.contentSize.height > 75) {
            while userName.contentSize.height > 75 {
                userName.font = UIFont.init(name: userName.font?.fontName ?? "Arial", size: (userName.font?.pointSize ?? 25) - 1)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (userName.text == "Jane Doe" && firstUserBool) {
            print("first")
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "welcome") as! WelcomeViewController
            
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.profileParent = self
            
            present(vc, animated: true, completion: nil)
            
            firstUserBool = false
        }
        
        userName.delegate = self
        allergyList.delegate = self
        dietList.delegate = self
        preferenceList.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func authorizeHealthKit(){
        
        HealthKitSetup.authorizeHealthKit { (authorized, error) in
            
            guard authorized else {
                
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                
                return
            }
            
            print("HealthKit Successfully Authorized.")
        }
        
    }
    
    func setUpCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Profile")
        request.returnsObjectsAsFaults = false
        do{
            var result = try context?.fetch(request)
            if(result!.count == 0){
                let entity = NSEntityDescription.entity(forEntityName: "Profile", in: context!)
                let newProfile = NSManagedObject(entity: entity!, insertInto: context)
                
                firstUserBool = true
                
                newProfile.setValue("Jane Doe", forKey: "name")
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
            
            userName.isEditable = false;
            allergyList.isEditable = false;
            dietList.isEditable = false;
            preferenceList.isEditable = false;
            
            self.userName.text = profile.value(forKey: "name") as? String
            if let picture = profile.value(forKey: "image") as? Data {
                self.userImage.image = UIImage(data: picture)
            }
            self.allergyList.text = profile.value(forKey: "allergies") as? String
            self.dietList.text = profile.value(forKey: "diets") as? String
            self.preferenceList.text = profile.value(forKey: "preferences") as? String
        }
        catch{
            print("Error - CoreData failed reading")
        }
        
        
    }
    
    func checkForAllergies(){
        
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
