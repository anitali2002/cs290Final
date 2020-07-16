//
//  SearchViewController.swift
//  ScotlandApp
//
//  Created by Anita Li on 4/2/20.
//  Copyright © 2020 Zhixue (Mary) Wang. All rights reserved.
//
//
//  Spoontacular.swift
//  ScotlandApp
//
//  Created by codeplus on 4/2/20.
//  Copyright © 2020 Zhixue (Mary) Wang. All rights reserved.
//
import UIKit
import CoreData

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var cuisineSearch = dropDownButton()
    var dietSearch = dropDownButton()
    var typeOfMealSearch = dropDownButton()

    @IBOutlet weak var cuisineDrop: UIImageView!
    @IBOutlet weak var mealDrop: UIImageView!
    @IBOutlet weak var dietDrop: UIImageView!
    @IBOutlet weak var advFilterButton: UIButton!
    var advOn: Bool?
    
    @IBOutlet weak var searchResultsTable: UITableView!
    @IBOutlet weak var generalSearch: UITextField!
    @IBOutlet weak var ingredientsSearch: UITextField!
    @IBOutlet weak var intolerancesSearch: UITextField!
    @IBOutlet weak var equipmentSearch: UITextField!
    @IBOutlet weak var maxTimeSearch: UITextField!
    
    @IBOutlet weak var ShrinkSpace: NSLayoutConstraint!
    @IBOutlet weak var CuisineGeneralVertSpace: NSLayoutConstraint!
    @IBOutlet weak var IngredientCuisineVertSpace: NSLayoutConstraint!
    @IBOutlet weak var DietIngredientVertSpace: NSLayoutConstraint!
    @IBOutlet weak var IntoleranceDietVertSpace: NSLayoutConstraint!
    @IBOutlet weak var TypeIntoleranceVertSpace: NSLayoutConstraint!
    @IBOutlet weak var EquipmentTypeVertSpace: NSLayoutConstraint!
    @IBOutlet weak var TimeEquipmentVertSpace: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet var UIView: UIView!
    @IBOutlet weak var placeholder: UILabel!
    @IBAction func search(_ sender: Any) {
        print("searching...")
        print(tableHeight.constant)
        getSearchResults()
        cuisineSearch.isHidden = true
        ingredientsSearch.isHidden = true
        dietSearch.isHidden = true
        intolerancesSearch.isHidden = true
        typeOfMealSearch.isHidden = true
        equipmentSearch.isHidden = true
        maxTimeSearch.isHidden = true
        cuisineDrop.isHidden = true
        mealDrop.isHidden = true
        dietDrop.isHidden = true
//        CuisineGeneralVertSpace.constant = -42
//        IngredientCuisineVertSpace.constant = -42
//        DietIngredientVertSpace.constant = -42
//        IntoleranceDietVertSpace.constant = -42
//        TypeIntoleranceVertSpace.constant = -42
//        EquipmentTypeVertSpace.constant = -42
//        TimeEquipmentVertSpace.constant = 0
        ShrinkSpace.constant = 8
        tableHeight.constant = UIView.frame.size.height-placeholder.frame.origin.y
        temp = searchResultsTable.frame.origin.y
        advFilterButton.setTitle("+ Advanced", for: .normal)
    }

    var temp:CGFloat = 0
    
    @IBAction func advancedFilterToggle(_ sender: Any) {
        print(temp)
        
        if(advOn ?? false) {
            advFilterButton.setTitle("+ Advanced", for: .normal)
        } else {
            advFilterButton.setTitle("- Advanced", for: .normal)
        }
        
        if cuisineSearch.isHidden == false{
            cuisineSearch.isHidden = true
            ingredientsSearch.isHidden = true
            dietSearch.isHidden = true
            intolerancesSearch.isHidden = true
            typeOfMealSearch.isHidden = true
            equipmentSearch.isHidden = true
            maxTimeSearch.isHidden = true
            cuisineDrop.isHidden = true
            mealDrop.isHidden = true
            dietDrop.isHidden = true
//            CuisineGeneralVertSpace.constant = -42
//            IngredientCuisineVertSpace.constant = -42
//            DietIngredientVertSpace.constant = -42
//            IntoleranceDietVertSpace.constant = -42
//            TypeIntoleranceVertSpace.constant = -42
//            EquipmentTypeVertSpace.constant = -42
//            TimeEquipmentVertSpace.constant = 0
            ShrinkSpace.constant = 8
            tableHeight.constant = UIView.frame.size.height-temp
            temp = searchResultsTable.frame.origin.y
        }
        else{
            cuisineSearch.isHidden = false
            ingredientsSearch.isHidden = false
            dietSearch.isHidden = false
            intolerancesSearch.isHidden = false
            typeOfMealSearch.isHidden = false
            equipmentSearch.isHidden = false
            maxTimeSearch.isHidden = false
            cuisineDrop.isHidden = false
            mealDrop.isHidden = false
            dietDrop.isHidden = false
            cuisineSearch.updateConstraints()
            ingredientsSearch.updateConstraints()
            dietSearch.updateConstraints()
            intolerancesSearch.updateConstraints()
            typeOfMealSearch.updateConstraints()
            equipmentSearch.updateConstraints()
            maxTimeSearch.updateConstraints()
//            CuisineGeneralVertSpace.constant = 8
//            IngredientCuisineVertSpace.constant = 8
//            DietIngredientVertSpace.constant = 8
//            IntoleranceDietVertSpace.constant = 8
//            TypeIntoleranceVertSpace.constant = 8
//            EquipmentTypeVertSpace.constant = 8
//            TimeEquipmentVertSpace.constant = 8
            ShrinkSpace.constant = 302
            tableHeight.constant = UIView.frame.size.height-temp
            temp = searchResultsTable.frame.origin.y
        }
                    
        advOn = !(advOn ?? false)
    }
    
    var searchResults: searchResult?
    var context: NSManagedObjectContext?
    var profile: NSManagedObject?
    
    struct result: Codable{
        var id: Int
        var usedIngredientCount: Int?
        var missedIngredientCount: Int?
        var likes: Int?
        var title: String
        var image: String
        var imageType: String
    }
    struct searchResult: Codable{
        var results: [result]
        var offset: Int
        var number: Int
        var totalResults: Int
    }
//should make the url have an if else for each search option and just append info on
    func getSearchResults(){
        var urlString = "https://api.spoonacular.com/recipes/complexSearch?"
        if var text = generalSearch.text, !text.isEmpty{
            //text = text.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            text = text.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
            urlString.append("query=\(text)&")
        }else{}
        if cuisineSearch.titleLabel?.text != "none" && cuisineSearch.titleLabel?.text != "Cuisine"{
            //let text = cuisineSearch.titleLabel?.text?.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil).lowercased() ?? ""
            let text = cuisineSearch.titleLabel?.text?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil).lowercased() ?? ""
            urlString.append("cuisine=\(text)&")
        }else{}
        if var text = ingredientsSearch.text, !text.isEmpty{
            text = text.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            urlString.append("includeIngredients=\(text)&")
        }else{}
        if typeOfMealSearch.titleLabel?.text != "none" && typeOfMealSearch.titleLabel?.text != "Type of Meal"{
            //let text = typeOfMealSearch.titleLabel?.text?.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil) ?? ""
            let text = typeOfMealSearch.titleLabel?.text?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil) ?? ""
            urlString.append("type=\(text)&")
        }else{}
        if var text = equipmentSearch.text, !text.isEmpty{
            text = text.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            urlString.append("equipment=\(text)&")
        }else{}
        if urlString == "https://api.spoonacular.com/recipes/complexSearch?"{
            print("no search information provided")
            DispatchQueue.main.async {
                // Network Error
                let alert1 = UIAlertController(title: "Error", message: "No main search parameters provided.", preferredStyle: .alert)
                alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert1, animated: true)
            }
            return
        }
        if dietSearch.titleLabel?.text != "none" && dietSearch.titleLabel?.text != "Diet"{
            //let text = dietSearch.titleLabel?.text?.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil) ?? ""
            let text = dietSearch.titleLabel?.text?.replacingOccurrences(of: " ", with: "", options: .literal, range: nil) ?? ""
            urlString.append("diet=\(text)&")
        }else{
            var profileDiets = profile?.value(forKey: "diets") as? String
            if(profileDiets == "" || profileDiets == "No special diets"){}
            else{
                //profileDiets = profileDiets?.replacingOccurrences(of: ", ", with: "%252", options: .literal, range: nil)
                profileDiets = profileDiets?.replacingOccurrences(of: ", ", with: ",", options: .literal, range: nil)
                urlString.append("diet=\(profileDiets!)&")
            }
        }
        if var text = intolerancesSearch.text, !text.isEmpty{
            text = text.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            urlString.append("intolerances=\(text)&")
        } else{
            var profileAllergies = profile?.value(forKey: "allergies") as? String
            if(profileAllergies == "" || profileAllergies == "No allergies"){}
            else{
                //profileAllergies = profileAllergies?.replacingOccurrences(of: ", ", with: "%252", options: .literal, range: nil)
                profileAllergies = profileAllergies?.replacingOccurrences(of: ", ", with: ",", options: .literal, range: nil)
                urlString.append("intolerances=\(profileAllergies!)&")
            }
        }
        urlString.append("number=10&apiKey=e2a0175d26364cac91a456a455205da2")
        print(urlString)
        //let newString = location.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: urlString) else { return }

        let dataTask = mySession.dataTask(with: url) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    // Network Error
                    let alert1 = UIAlertController(title: "Error", message: "Error completing request. Please double check network connection and try again.", preferredStyle: .alert)
                    alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert1, animated: true)
                }
                print ("error: \(error!)")
                return
            }
            
            // ensure there is data returned from this HTTP response
            guard let jsonData = data else {
                print("No data")
                return
            }
        
            let decoder = JSONDecoder()
            
            do {
                let search = try decoder.decode(searchResult.self, from: jsonData)
                    
                self.searchResults = search

                DispatchQueue.main.async {
                    print("success")
                    if search.totalResults==0{
                        DispatchQueue.main.async {
                            // Network Error
                            let alert1 = UIAlertController(title: "Error", message: "Search parameters matched with zero recipes", preferredStyle: .alert)
                            alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert1, animated: true)
                        }
                    }
                        self.searchResultsTable.reloadData()
                }
            } catch {
                DispatchQueue.main.async {
                    let alert1 = UIAlertController(title: "Error", message: "Error completing request causing and error in JSON decoding.", preferredStyle: .alert)
                    alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert1, animated: true)
                }
                print("JSON Decode error \(error)")
            }
        }
        
        dataTask.resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // setting up dropdown menus
        cuisineSearch = dropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        cuisineSearch.contentHorizontalAlignment = .left
        cuisineSearch.titleEdgeInsets.left = 5
        cuisineSearch.setTitle("Cuisine", for: .normal)
        cuisineSearch.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(cuisineSearch)
        self.view.bringSubviewToFront(cuisineSearch)
        
        cuisineSearch.centerXAnchor.constraint(equalTo: self.generalSearch.centerXAnchor).isActive = true
        cuisineSearch.centerYAnchor.constraint(equalTo: self.generalSearch.bottomAnchor, constant: 26).isActive = true
        
        cuisineSearch.widthAnchor.constraint(equalTo: self.generalSearch.widthAnchor).isActive = true
        cuisineSearch.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        cuisineSearch.dropView.dropDownOptions = ["none", "African", "American", "British", "Cajun", "Carribean", "Chinese", "Eastern European", "French", "German", "Greek", "Indian", "Irish", "Italian", "Japanese", "Jewish", "Korean", "Latin American", "Mexican", "Middle Eastern", "Nordic", "Southern", "Spanish", "Thai", "Vietnamese"]
                
        dietSearch = dropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        dietSearch.contentHorizontalAlignment = .left
        dietSearch.titleEdgeInsets.left = 5
        dietSearch.setTitle("Diet", for: .normal)
        dietSearch.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(dietSearch)
        self.view.sendSubviewToBack(dietSearch)

        dietSearch.centerXAnchor.constraint(equalTo: self.ingredientsSearch.centerXAnchor).isActive = true
        dietSearch.centerYAnchor.constraint(equalTo: self.ingredientsSearch.bottomAnchor, constant: 26).isActive = true

        dietSearch.widthAnchor.constraint(equalTo: self.ingredientsSearch.widthAnchor).isActive = true
        dietSearch.heightAnchor.constraint(equalToConstant: 34).isActive = true

        //dietSearch.dropView.dropDownOptions = ["none", "lacto-vegetarian", "ovo-vegetarian", "pescetarian", "vegan", "vegetarian"]
        dietSearch.dropView.dropDownOptions = ["none", "gluten-free", "lacto-vegetarian", "ovo-vegetarian", "pescetarian", "vegan", "vegetarian"]

        typeOfMealSearch = dropDownButton.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        typeOfMealSearch.contentHorizontalAlignment = .left
        typeOfMealSearch.titleEdgeInsets.left = 5
        typeOfMealSearch.setTitle("Type of Meal", for: .normal)
        typeOfMealSearch.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(typeOfMealSearch)
        self.view.sendSubviewToBack(typeOfMealSearch)

        typeOfMealSearch.centerXAnchor.constraint(equalTo: self.dietSearch.centerXAnchor).isActive = true
        typeOfMealSearch.centerYAnchor.constraint(equalTo: self.dietSearch.bottomAnchor, constant: 25).isActive = true

        typeOfMealSearch.widthAnchor.constraint(equalTo: self.dietSearch.widthAnchor).isActive = true
        typeOfMealSearch.heightAnchor.constraint(equalToConstant: 34).isActive = true

        typeOfMealSearch.dropView.dropDownOptions = ["none", "appetizer", "beverage", "bread", "breakfast", "dessert", "drink",  "main course", "salad", "sauce", "side dish", "soup"]
        
        // other setup
        searchResultsTable.delegate = self
        searchResultsTable.dataSource = self
        cuisineSearch.isHidden = true
        ingredientsSearch.isHidden = true
        dietSearch.isHidden = true
        intolerancesSearch.isHidden = true
        typeOfMealSearch.isHidden = true
        equipmentSearch.isHidden = true
        maxTimeSearch.isHidden = true
        cuisineDrop.isHidden = true
        mealDrop.isHidden = true
        dietDrop.isHidden = true
        
        generalSearch.delegate = self
        ingredientsSearch.delegate = self
        intolerancesSearch.delegate = self
        equipmentSearch.delegate = self
        maxTimeSearch.delegate = self

//        CuisineGeneralVertSpace.constant = -42
//        IngredientCuisineVertSpace.constant = -42
//        DietIngredientVertSpace.constant = -42
//        IntoleranceDietVertSpace.constant = -42
//        TypeIntoleranceVertSpace.constant = -42
//        EquipmentTypeVertSpace.constant = -42
//        TimeEquipmentVertSpace.constant = 0
        ShrinkSpace.constant = 8
        tableHeight.constant = UIView.frame.size.height-placeholder.frame.origin.y
        temp = searchResultsTable.frame.origin.y
        
        searchResultsTable.contentInset = UIEdgeInsets(top: 5,left: 0,bottom: 0,right: 0)
        advOn = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpCoreData()
    }
    
    func setUpCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Profile")
        request.returnsObjectsAsFaults = false
        do{
            let result = try context?.fetch(request)
            print(result!.count)
            profile = result![0] as? NSManagedObject
        }
        catch{
            print("Error - CoreData failed reading")
        }
    }
    
    // MARK: Table Configuration
    func numberOfSections(in recipeTable: UITableView) -> Int {
        return searchResults?.results.count ?? 0
    }

    /*
    func tableView(_ recipeTable: UITableView, titleForHeaderInSection section: Int) -> String? {
        // section header
        return("Recipe Results")
        
    }
 */
    
    func tableView(_ recipeTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    // MARK: Cell Configuration
    func tableView(_ searchResultsTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultsTable.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeTableViewCell
        
        cell.recipeName.text = searchResults?.results[indexPath.section].title
        let url = URL(string: (searchResults?.results[indexPath.section].image)!)
        let data = try? Data(contentsOf: url!)
        cell.recipeImage?.image = UIImage(data: data!)
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // and cast it to the correct class type (i.e. focusAnimalViewController)

        let destVC = segue.destination as! RecipeViewController

        // Pass the selected object to the new view controller.
        let myRow = searchResultsTable!.indexPathForSelectedRow
        let myCurrCell = searchResultsTable!.cellForRow(at: myRow!) as! RecipeTableViewCell

        // set the destVC variables from the selected row
        destVC.id = searchResults?.results[myRow!.section].id
        destVC.image = (myCurrCell.recipeImage!.image)!
        destVC.name = (myCurrCell.recipeName!.text)!
    }
}

protocol dropDownProtocol {
    func dropDownPressed(string : String)
}

class dropDownButton: UIButton, dropDownProtocol {
    
    func dropDownPressed(string: String) {
        self.titleEdgeInsets.left = 10
        self.contentHorizontalAlignment = .left
        self.contentVerticalAlignment = .center
        self.setTitle(string, for: .normal)
        self.setTitleColor(UIColor.black, for: .normal)
        self.dismissDropDown()
    }
    
    var dropView = dropDownView()
    
    var height = NSLayoutConstraint()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dropView.layer.cornerRadius = 10
        dropView.layer.borderWidth = 0.5
        dropView.layer.borderColor = UIColor.lightGray.cgColor
        
        dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        dropView.delegate = self
        
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)

        self.setTitleColor(UIColor.systemGray3, for: .normal)
        self.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        
//        self.setImage(UIImage(systemName: "chevron.down.square"), for: .normal)
//        self.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
//        self.imageEdgeInsets.left = 5
//        self.imageEdgeInsets.left = 30

        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
            
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    var isOpen = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.bringSubviewToFront(dropView)
        if isOpen == false {
            isOpen = true
            
            NSLayoutConstraint.deactivate([self.height])
            
            //if self.dropView.tableView.contentSize.height > 150 {
            //    self.height.constant = 150
            if self.dropView.tableView.contentSize.height > 100 {
                self.height.constant = 100
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            NSLayoutConstraint.activate([self.height])
            
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
            
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
           
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func dismissDropDown(){
        isOpen = false
         
         NSLayoutConstraint.deactivate([self.height])
         self.height.constant = 0
         NSLayoutConstraint.activate([self.height])
        
         UIView.animate(withDuration: 0.5, delay: 0, animations: {
             self.dropView.center.y -= self.dropView.frame.height / 2
             self.dropView.layoutIfNeeded()
         }, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    var dropDownOptions = [String]()
    
    var tableView = UITableView()
    
    var delegate : dropDownProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(tableView)
        self.bringSubviewToFront(tableView)
        
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
//        cell.heightAnchor.constraint(equalToConstant: 34)
        cell.textLabel?.text = dropDownOptions[indexPath.row]
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(dropDownOptions[indexPath.row])
        self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
