//
//  RecipeViewController.swift
//  ScotlandApp
//
//  Created by Anita Li on 4/2/20.
//  Copyright © 2020 Zhixue (Mary) Wang. All rights reserved.
//

import UIKit
import HealthKit
import CoreData

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var recipeSave: UIBarButtonItem!
    
    @IBOutlet weak var ingredientsTable: UITableView!
    @IBOutlet weak var instructionsTable: UITableView!
    @IBOutlet weak var nutritionTable: UITableView!
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeServings: UILabel!
    @IBOutlet weak var recipeTotalTime: UILabel!
    @IBOutlet weak var recipeCookTime: UILabel!
    @IBOutlet weak var recipePrepTime: UILabel!
    
    @IBOutlet weak var healthyCheck: UIImageView!
    @IBOutlet weak var cheapCheck: UIImageView!
    @IBOutlet weak var sustainableCheck: UIImageView!
    @IBOutlet weak var weightWatchersPoints: UILabel!
    
    @IBOutlet weak var vegetarianCheck: UIImageView!
    @IBOutlet weak var glutenFreeCheck: UIImageView!
    @IBOutlet weak var dairyFreeCheck: UIImageView!
    @IBOutlet weak var veganCheck: UIImageView!
    
    var context: NSManagedObjectContext?
    var savedRecipes: [NSManagedObject] = []
    
    @IBAction func saveRecipe(_ sender: Any) {
        if (recipeSave.image == UIImage(systemName: "suit.heart.fill")){
            print("deleting recipe")
            var i = 0
            for item in savedRecipes{
                if (item.value(forKey: "id") as? Int == self.id){
                    context!.delete(item)

                    do{
                        try context!.save()
                        savedRecipes.remove(at: i)
                    }
                    catch{
                        print("Error - CoreData failed saving")
                    }
                }
                i = i+1
            }
            recipeSave.image = UIImage(systemName: "suit.heart")
        }
        else {
            print("saving recipe...")
            let recipe = NSEntityDescription.entity(forEntityName: "SavedRecipe", in: context!)
            let newRecipe = NSManagedObject(entity: recipe!, insertInto: context)
            
            newRecipe.setValue(recipeResults?.title, forKey: "name")
            newRecipe.setValue(recipeResults?.id, forKey: "id")
            newRecipe.setValue(recipeResults?.image, forKey: "imageurl")
            
            do{
                try context!.save()
                savedRecipes.append(newRecipe)
            }
            catch{
                print("Error - CoreData failed saving")
            }
            recipeSave.image = UIImage(systemName: "suit.heart.fill")
        }
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
            for item in savedRecipes{
                if (item.value(forKey: "id") as? Int == self.id){
                    DispatchQueue.main.async{
                        self.recipeSave.image = UIImage(systemName: "suit.heart.fill")
                    }
                }
            }
        }
        catch{
            print("Error - CoreData failed reading")
        }
    }

    @IBAction func addNutritionalInfoToHealthKit(_ sender: Any) {
        let healthKitStore = HKHealthStore()
        let today = Date()
        
        let nutritionItems: [Nutrient] = (recipeResults?.nutrition!.nutrients)!
        for nutrient in nutritionItems{
            if(nutrient.title! == "Calories"){
                print(HKQuantityTypeIdentifier.dietaryCarbohydrates.rawValue)
                guard let calorieType = HKQuantityType.quantityType(forIdentifier: .dietaryEnergyConsumed)else {
                    print("\(nutrient.title!) is no longer available in HealthKit")
                    continue
                }
                let calories = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: nutrient.amount!)
                let calorieSample = HKQuantitySample(type: calorieType , quantity: calories, start: today, end: today)
                healthKitStore.save(calorieSample) { (success, error) in
                    if let error = error {
                        print("Error Saving calorie Sample: \(error.localizedDescription)")
                    } else {
                        print("Successfully saved calorie Sample")
                    }
                }
            }
            else if (nutrient.title! == "Fat"){
                guard let fatType = HKQuantityType.quantityType(forIdentifier: .dietaryFatTotal)else {
                    print("\(nutrient.title!) is no longer available in HealthKit")
                    continue
                }
                let fat = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.amount!)
                let fatSample = HKQuantitySample(type: fatType, quantity: fat, start: today, end: today)
                healthKitStore.save(fatSample) { (success, error) in
                    if let error = error {
                        print("Error Saving Fat Sample: \(error.localizedDescription)")
                    } else {
                        print("Successfully saved Fat Sample")
                    }
                }
            }
            else if (nutrient.title! == "Saturated Fat"){
                guard let satFatType = HKQuantityType.quantityType(forIdentifier: .dietaryFatSaturated)else {
                    print("\(nutrient.title!) is no longer available in HealthKit")
                    continue
                }
                let satFat = HKQuantity(unit: HKUnit.gram(), doubleValue: nutrient.amount!)
                let satFatSample = HKQuantitySample(type: satFatType, quantity: satFat, start: today, end: today)
                healthKitStore.save(satFatSample) { (success, error) in
                    if let error = error {
                        print("Error Saving Sat Fat Sample: \(error.localizedDescription)")
                    } else {
                        print("Successfully saved Sat Fat Sample")
                    }
                }
            }
            else{
                if(nutrient.unit! == "IU"){
                    continue
                }
                let nutritionalItem = (nutrient.title!).components(separatedBy: " ").joined()
                let nutType = "HKQuantityTypeIdentifierDietary" + nutritionalItem
                
                guard let nutrientType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: nutType))
                    else {
                        print("\(nutrient.title!) is no longer available in HealthKit")
                        continue
                }
                let curNutrient = HKQuantity(unit: HKUnit.init(from: nutrient.unit!), doubleValue: nutrient.amount!)
                let curNutrientSample = HKQuantitySample(type: nutrientType, quantity: curNutrient, start: today, end: today)
                healthKitStore.save(curNutrientSample){ (success, error) in
                    if let error = error {
                        print("Error Saving \(nutrient.title!) Sample: \(error.localizedDescription)")
                    } else {
                        print("Successfully saved \(nutrient.title!) Sample")
                    }
                }
                
            }
        }
    }
    
    var id: Int!
    var image: UIImage!
    var name: String!
    
    var recipeResults: recipe?
    var allSteps: [step] = []
    
    struct recipe: Codable{
        var vegetarian: Bool?
        var vegan: Bool?
        var glutenFree: Bool?
        var dairyFree: Bool?
        var veryHealthy: Bool?
        var cheap: Bool?
        var veryPopular: Bool?
        var sustainable: Bool?
        var weightWatcherSmartPoints: Int?
        var gaps: String?
        var lowFoodmap: Bool?
        var preparationMinutes: Int?
        var cookingMinutes: Int?
        var sourceUrl: String?
        var spoonacularSourceUrl: String?
        var aggregateLikes: Int?
        var spoonacularScore: Double?
        var healthScore: Double?
        var creditsText: String?
        var sourceName: String?
        var pricePerServing: Double?
        var extendedIngredients: [extendedIngredient]?
        var id: Int?
        var title: String?
        var readyInMinutes: Int?
        var servings: Int?
        var image: String?
        var imageType: String?
        var nutrition: NutritionInfo?
        var summary: String?
        var cuisines: [String]?
        var dishTypes: [String]?
        var diets: [String]?
        var occasions: [String]?
        var winePairing: WinePairing?
        var instructions: String?
        var analyzedInstructions: [recipePart]?
        var originalID: Int?
    }
    
    struct extendedIngredient: Codable{
        var id: Int
        var aisle: String
        var image: String
        var consistency: String
        var name: String
        var original: String
        var originalString: String
        var originalName: String
        var amount: Double
        var unit: String
        var meta: [String]
        var metaInformation: [String]
        var measures: MeasurementInfo
    }
    
    struct MeasurementInfo: Codable{
        var us: Measurement
        var metric: Measurement
    }
    
    struct Measurement: Codable{
        var amount: Double?
        var unitShort: String?
        var unitLong: String?
        
    }
    
    struct NutritionInfo: Codable{
        var nutrients: [Nutrient]
        var ingredients: [Ingredient]
        var caloricBreakdown: CaloricBreakdown
        var weightPerServing: WeightInfo
    }
    
    struct Nutrient: Codable{
        var title: String?
        var amount: Double?
        var unit: String?
        var percentOfDailyNeeds: Double?
    }
    
    struct Ingredient: Codable{
        var name: String?
        var amount: Double?
        var unit: String?
        var nutrients: [Nutrient]?
    }
    
    struct CaloricBreakdown: Codable{
        var percentProtein: Double?
        var percentFat: Double?
        var percentCarbs: Double?
    }
    
    struct WeightInfo: Codable{
        var amount: Int?
        var unit: String?
    }
    
    struct WinePairing: Codable{
        var pairedWines: [String]?
        var pairingText: String?
        var productMatches: [Product]?
    }
    
    struct Product: Codable{
        var id: Int?
        var title: String?
        var description: String?
        var price: String?
        var imageUrl: String?
        var averageRating: Double?
        var ratingCount: Double?
        var score: Double?
        var link: String?
    }
    
    struct recipePart: Codable{
        var name: String
        var steps: [step]
    }
    
    struct step: Codable{
        var number: Int
        var step: String
        var ingredients: [basicIngredient]
        var equipment: [equipment]
        var length: timeLength?
    }
    
    struct basicIngredient: Codable{
        var id: Int
        var name: String
        var image: String
    }
    
    struct equipment: Codable{
        var id: Int
        var name: String
        var image: String
        var temperature: temperatureInfo?
    }
    
    struct timeLength: Codable{
        var number: Int
        var unit: String
    }
    
    struct temperatureInfo: Codable{
        var number: Double
        var unit: String
    }
    
    func getRecipeInfo(){
        let stringID = String(self.id!)
        let urlString = "https://api.spoonacular.com/recipes/\(stringID)/information?includeNutrition=true&apiKey=e2a0175d26364cac91a456a455205da2"
        print(urlString)
        //let newString = location.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: urlString) else { return }
        
        let dataTask = mySession.dataTask(with: url) { data, response, error in
            guard error == nil else {
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
                let recipeResult = try decoder.decode(recipe.self, from: jsonData)
                
                self.recipeResults = recipeResult
                
                DispatchQueue.main.async {
                    print("success")
                    
                    self.recipeCookTime.text = String((self.recipeResults?.cookingMinutes ?? 0) as Int)
                    self.recipePrepTime.text = String((self.recipeResults?.preparationMinutes ?? 0) as Int)
                    self.recipeTotalTime.text = String((self.recipeResults?.readyInMinutes ?? 0) as Int)
                    
                    // Diet
                    if (self.recipeResults?.vegan ?? false){
                        self.veganCheck.image = UIImage(systemName: "checkmark.rectangle")
                        self.veganCheck.tintColor = UIColor.init(red: 149/255, green: 239/255, blue: 99/255, alpha: 1)
                    }
                    if (self.recipeResults?.vegetarian != nil){
                        if (self.recipeResults!.vegetarian!){
                            self.vegetarianCheck.image = UIImage(systemName: "checkmark.rectangle")
                            self.vegetarianCheck.tintColor = UIColor.init(red: 149/255, green: 239/255, blue: 99/255, alpha: 1)
                        }
                    }
                    if (self.recipeResults?.glutenFree ?? false){
                        self.glutenFreeCheck.image = UIImage(systemName: "checkmark.rectangle")
                        self.glutenFreeCheck.tintColor = UIColor.init(red: 149/255, green: 239/255, blue: 99/255, alpha: 1)
                    }
                    if (self.recipeResults?.dairyFree ?? false){
                        self.dairyFreeCheck.image = UIImage(systemName: "checkmark.rectangle")
                        self.dairyFreeCheck.tintColor = UIColor.init(red: 149/255, green: 239/255, blue: 99/255, alpha: 1)
                    }
                    
                    // Other Info
                    if (self.recipeResults?.cheap ?? false){
                        self.cheapCheck.image = UIImage(systemName: "checkmark.rectangle")
                        self.cheapCheck.tintColor = UIColor.init(red: 149/255, green: 239/255, blue: 99/255, alpha: 1)
                    }
                    if (self.recipeResults?.sustainable ?? false){
                        self.sustainableCheck.image = UIImage(systemName: "checkmark.rectangle")
                        self.sustainableCheck.tintColor = UIColor.init(red: 149/255, green: 239/255, blue: 99/255, alpha: 1)
                    }
                    if (self.recipeResults?.veryHealthy ?? false){
                        self.healthyCheck.image = UIImage(systemName: "checkmark.rectangle")
                        self.healthyCheck.tintColor = UIColor.init(red: 149/255, green: 239/255, blue: 99/255, alpha: 1)
                    }
                    
                    self.weightWatchersPoints.text = String((self.recipeResults?.weightWatcherSmartPoints ?? 0) as Int)
                    
                    self.recipeServings.text = String((self.recipeResults?.servings ?? 0) as Int)
                    
                    if (!(self.recipeResults?.analyzedInstructions?.isEmpty ?? true)) {
                        for n in 0...((self.recipeResults?.analyzedInstructions?.count ?? 0) - 1) {
                            for j in 0...((self.recipeResults?.analyzedInstructions?[n].steps.count)! - 1) {
                                self.allSteps.append((self.recipeResults?.analyzedInstructions?[n].steps[j])!)
                            }
                        }
                    }
                    
                    self.instructionsTable.reloadData()
                    self.ingredientsTable.reloadData()
                    self.nutritionTable.reloadData()
                }
            }
            catch {
                print(error)
            }
        }
        dataTask.resume()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let windowWidth = UIScreen.main.bounds.width
        let contentHeight = scrollView.bounds.height*1.65
        
        scrollView.contentSize = CGSize(width: windowWidth, height: contentHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorizeHealthKit()
        
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height * 1.5
        print(contentHeight)
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        instructionsTable.delegate = self
        instructionsTable.dataSource = self
        
        ingredientsTable.delegate = self
        ingredientsTable.dataSource = self
        
        nutritionTable.delegate = self
        nutritionTable.dataSource = self
        
        getRecipeInfo()
        
        recipeImage.image = image
        //        self.navigationController!.navigationBar.topItem?.title = name
        //        self.navigationItem.title = name
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.text = name
        self.navigationItem.titleView = label
        
        instructionsTable.rowHeight = UITableView.automaticDimension
        instructionsTable.estimatedRowHeight = 150
        
        ingredientsTable.rowHeight = UITableView.automaticDimension
        ingredientsTable.estimatedRowHeight = 100
        
        //        nutritionTable.rowHeight = UITableView.automaticDimension
        //        nutritionTable.estimatedRowHeight = 300
        nutritionTable.rowHeight = 125
        
        setUpCoreData()
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
    
    // MARK: Instruction Table Setup
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows = 0
        
        if (tableView == self.ingredientsTable) {
            numRows = recipeResults?.extendedIngredients?.count ?? 0
        }
        
        if (tableView == self.instructionsTable) {
            numRows = self.allSteps.count
        }
        
        if (tableView == self.nutritionTable) {
            numRows = recipeResults?.nutrition?.nutrients.count ?? 0
        }
        
        return numRows
    }
    
    // MARK: Cell Configuration
    //may have to move into the async
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.ingredientsTable) {
            let ingredientCell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as! IngredientsTableViewCell
            
            ingredientCell.ingredient.text = recipeResults?.extendedIngredients?[indexPath.row].originalString.lowercased()
            
            return ingredientCell
        }
        
        if (tableView == self.instructionsTable) {
            let instructionCell = tableView.dequeueReusableCell(withIdentifier: "instructionCell", for: indexPath) as! RecipeInstructionsTableViewCell
            
            instructionCell.stepNumber.text = String(self.allSteps[indexPath.row].number)
            instructionCell.step.text = self.allSteps[indexPath.row].step
            
            return instructionCell
        }
        
        if (tableView == self.nutritionTable) {
            let nutritionCell = tableView.dequeueReusableCell(withIdentifier: "nutritionCell", for: indexPath) as! NutritionTableViewCell
            
            nutritionCell.nutritionLabel.text = recipeResults?.nutrition?.nutrients[indexPath.row].title
            nutritionCell.nutritionAmt.text = String((recipeResults?.nutrition?.nutrients[indexPath.row].amount ?? 0.0) as Double)
            nutritionCell.nutritionUnit.text = recipeResults?.nutrition?.nutrients[indexPath.row].unit
            nutritionCell.percentNeeds.text = String((recipeResults?.nutrition?.nutrients[indexPath.row].percentOfDailyNeeds ?? 0.0) as Double)
            
            return nutritionCell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        // Get the new view controller using segue.destination.
    //        // Pass the selected object to the new view controller.
    //
    //    }
}
