//
//  WeightUnit.swift
//  gymmerApp
//
//  Created by Rafael Alves Vidal on 3/10/2024.
//


import SwiftUI

struct WeightUnit {
    // Read the stored unit system from UserDefaults
    @AppStorage("selectedUnitSystem") private var storedUnitSystem: String = UnitSystem.metric.rawValue
    
    // Return the weight unit as a string
    var unit: String {
        let unitSystem = UnitSystem(rawValue: storedUnitSystem) ?? .metric
        return unitSystem == .metric ? "kg" : "lbs"
    }
}
