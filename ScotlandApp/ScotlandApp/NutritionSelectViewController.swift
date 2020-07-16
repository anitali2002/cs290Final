//
//  NutritionSelectViewController.swift
//  ScotlandApp
//
//  Created by Anita Li on 4/12/20.
//  Copyright © 2020 Zhixue (Mary) Wang. All rights reserved.
//

import UIKit

class NutritionSelectViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var servingCounter: UIStepper!
    @IBAction func countServings(_ sender: UIStepper) {
        servingsLabel.text = Int(sender.value).description
    }
    
    @IBOutlet weak var selectCalories: UISwitch!
    @IBOutlet weak var selectCholesterol: UISwitch!
    @IBOutlet weak var selectTotalFat: UISwitch!
    @IBOutlet weak var selectProtein: UISwitch!
    @IBOutlet weak var selectSatFat: UISwitch!
    @IBOutlet weak var selectCarbs: UISwitch!
    @IBOutlet weak var selectFiber: UISwitch!
    @IBOutlet weak var selectSugar: UISwitch!
    @IBOutlet weak var allMacro: UISwitch!
    @IBAction func selectAllMacro(_ sender: Any) {
        selectCalories.isOn = allMacro.isOn
        selectCholesterol.isOn = allMacro.isOn
        selectTotalFat.isOn = allMacro.isOn
        selectProtein.isOn = allMacro.isOn
        selectSatFat.isOn = allMacro.isOn
        selectCarbs.isOn = allMacro.isOn
        selectFiber.isOn = allMacro.isOn
        selectSugar.isOn = allMacro.isOn
    }
    
    @IBOutlet weak var selectVitA: UISwitch!
    @IBOutlet weak var selectVitB12: UISwitch!
    @IBOutlet weak var selectVitD: UISwitch!
    @IBOutlet weak var selectVitK: UISwitch!
    @IBOutlet weak var selectVitB6: UISwitch!
    @IBOutlet weak var selectVitC: UISwitch!
    @IBOutlet weak var selectVitE: UISwitch!
    @IBOutlet weak var selectFolate: UISwitch!
    @IBOutlet weak var allVitamins: UISwitch!
    @IBAction func selectAllVitamins(_ sender: Any) {
        selectVitA.isOn = allVitamins.isOn
        selectVitB12.isOn = allVitamins.isOn
        selectVitD.isOn = allVitamins.isOn
        selectVitK.isOn = allVitamins.isOn
        selectVitB6.isOn = allVitamins.isOn
        selectVitC.isOn = allVitamins.isOn
        selectVitE.isOn = allVitamins.isOn
        selectFolate.isOn = allVitamins.isOn
    }
    
    @IBOutlet weak var selectCalcium: UISwitch!
    @IBOutlet weak var selectIron: UISwitch!
    @IBOutlet weak var selectManganese: UISwitch!
    @IBOutlet weak var selectPotassium: UISwitch!
    @IBOutlet weak var selectSodium: UISwitch!
    @IBOutlet weak var selectCopper: UISwitch!
    @IBOutlet weak var selectMagnesium: UISwitch!
    @IBOutlet weak var selectPhosphorus: UISwitch!
    @IBOutlet weak var selectSelenium: UISwitch!
    @IBOutlet weak var selectZinc: UISwitch!
    @IBOutlet weak var allMinerals: UISwitch!
    @IBAction func selectAllMinerals(_ sender: Any) {
        selectCalcium.isOn = allMinerals.isOn
        selectIron.isOn = allMinerals.isOn
        selectManganese.isOn = allMinerals.isOn
        selectPotassium.isOn = allMinerals.isOn
        selectSodium.isOn = allMinerals.isOn
        selectCopper.isOn = allMinerals.isOn
        selectMagnesium.isOn = allMinerals.isOn
        selectPhosphorus.isOn = allMinerals.isOn
        selectSelenium.isOn = allMinerals.isOn
        selectZinc.isOn = allMinerals.isOn
    }
    
    @IBAction func addInfo(_ sender: Any) {
        print("adding nutritional info to profile...")
        // need to add the val * servingCounter.value
        // maybe have an alert at end that is like added successfully. please press back to return
        // (i don't really know how to segue/transition back to recipe page otherwise)
        if (selectCalories.isOn){
            print("calories selected...")
        }
        if (selectCholesterol.isOn){
            print("cholesterol selected...")
        }
        if (selectTotalFat.isOn){
            print("total fat selected...")
        }
//        if (selectProtein.isOn){
//
//        }
//        if (selectSatFat.isOn){
//
//        }
//        if (selectCarbs.isOn){
//
//        }
//        if (selectFiber.isOn){
//
//        }
//        if (selectSugar.isOn){
//
//        }
//        if (selectVitA.isOn){
//
//        }
//        if (selectVitB12.isOn){
//
//        }
//        if (selectVitD.isOn){
//
//        }
//        if (selectVitK.isOn){
//
//        }
//        if (selectVitB6.isOn){
//
//        }
//        if (selectVitC.isOn){
//
//        }
//        if (selectVitE.isOn){
//
//        }
//        if (selectFolate.isOn){
//
//        }
//        if (selectCalcium.isOn){
//
//        }
//        if (selectIron.isOn){
//
//        }
//        if (selectManganese.isOn){
//
//        }
//        if (selectPotassium.isOn){
//
//        }
//        if (selectSodium.isOn){
//
//        }
//        if (selectCopper.isOn){
//
//        }
//        if (selectMagnesium.isOn){
//
//        }
//        if (selectPhosphorus.isOn){
//
//        }
//        if (selectSelenium.isOn){
//
//        }
//        if (selectZinc.isOn){
//
//        }
        
        // close current view controller and return to recipe
        self.dismiss(animated: true, completion: nil)
    }
    
    var calories: Double!
    var cholesterol: Double!
    var totalFat: Double!
    var protein: Double!
    var carbs: Double!
    var satFat: Double!
    var fiber: Double!
    var sugar: Double!
    var vitA: Double!
    var vitB12: Double!
    var vitD: Double!
    var vitK: Double!
    var vitB6: Double!
    var vitC: Double!
    var vitE: Double!
    var folate: Double!
    var calcium: Double!
    var iron: Double!
    var manganese: Double!
    var potassium: Double!
    var sodium: Double!
    var copper: Double!
    var magnesium: Double!
    var phosphorus: Double!
    var selenium: Double!
    var zinc: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.width * 2.5
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        
        servingCounter.value = 0
        servingCounter.wraps = false
        servingCounter.autorepeat = true
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
