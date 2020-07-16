//
//  HealthKitSetup.swift
//  ScotlandApp
//
//  Created by Belanie Nagiel on 4/1/20.
//  Copyright © 2020 Zhixue (Mary) Wang. All rights reserved.
//

import HealthKit

class HealthKitSetup {
  
  private enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
  }
  
  class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
    //1. Check to see if HealthKit Is Available on this device
    guard HKHealthStore.isHealthDataAvailable() else {
        completion(false, HealthkitSetupError.notAvailableOnDevice)
        return
    }

    //2. Prepare the data types that will interact with HealthKit
    
    guard let allergyRecord = HKObjectType.clinicalType(forIdentifier: .allergyRecord),
        let calories = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed),
        let fat = HKObjectType.quantityType(forIdentifier: .dietaryFatTotal),
        let satFat = HKObjectType.quantityType(forIdentifier: .dietaryFatSaturated),
        let cholesterol = HKObjectType.quantityType(forIdentifier: .dietaryCholesterol),
        let fiber = HKObjectType.quantityType(forIdentifier: .dietaryFiber),
        let sugar = HKObjectType.quantityType(forIdentifier: .dietarySugar),
        let protein = HKObjectType.quantityType(forIdentifier: .dietaryProtein),
        let calcium = HKObjectType.quantityType(forIdentifier: .dietaryCalcium),
        let iron = HKObjectType.quantityType(forIdentifier: .dietaryIron),
        let potassium = HKObjectType.quantityType(forIdentifier: .dietaryPotassium),
        let sodium = HKObjectType.quantityType(forIdentifier: .dietarySodium),
        let vitaminA = HKObjectType.quantityType(forIdentifier: .dietaryVitaminA),
        let vitaminC = HKObjectType.quantityType(forIdentifier: .dietaryVitaminC),
        let vitaminD = HKObjectType.quantityType(forIdentifier: .dietaryVitaminD),
        let carbohydrates = HKObjectType.quantityType(forIdentifier: .dietaryCarbohydrates),
        let manganese = HKObjectType.quantityType(forIdentifier: .dietaryManganese),
        let copper = HKObjectType.quantityType(forIdentifier: .dietaryCopper),
        let vitaminK = HKObjectType.quantityType(forIdentifier: .dietaryVitaminK),
        let magnesium = HKObjectType.quantityType(forIdentifier: .dietaryMagnesium),
        let phosphorous = HKObjectType.quantityType(forIdentifier: .dietaryPhosphorus),
        let vitaminB6 = HKObjectType.quantityType(forIdentifier: .dietaryVitaminB6),
        let folate = HKObjectType.quantityType(forIdentifier: .dietaryFolate),
        let zinc = HKObjectType.quantityType(forIdentifier: .dietaryZinc),
        let selenium = HKObjectType.quantityType(forIdentifier: .dietarySelenium),
        let vitaminE = HKObjectType.quantityType(forIdentifier: .dietaryVitaminE),
        let vitaminB12 = HKObjectType.quantityType(forIdentifier: .dietaryVitaminB12)
        

        
    else {

            completion(false, HealthkitSetupError.dataTypeNotAvailable)
            return
    }
    

    //3. Prepare a list of types you want HealthKit to read and write
    let healthKitTypesToWrite: Set<HKSampleType> = [calories, fat, satFat, cholesterol, fiber, sugar, protein, calcium, iron, potassium, sodium, vitaminA, vitaminC, vitaminD, carbohydrates, manganese, copper,vitaminK,magnesium,phosphorous,vitaminB6,folate,zinc, selenium, vitaminE, vitaminB12]

    let healthKitTypesToRead: Set<HKObjectType> = [allergyRecord]


    //4. Request Authorization
    HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite,
                                         read: healthKitTypesToRead) { (success, error) in
                                            completion(success, error)
    }

  }
    
}
