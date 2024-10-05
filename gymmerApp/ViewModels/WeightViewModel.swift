//
//  WeightViewModel.swift
//  gymmerApp
//
//  Created by Rafael Alves Vidal on 1/10/2024.
//

import Supabase
import SwiftUI

@MainActor
class WeightViewModel: ObservableObject {
    @Published var weights: [Weight] = [] // Holds the list of weights
    let client = supabase // Access the Supabase client
    
    // Fetch the latest weight from the database
    func fetchLatestWeight() async -> Weight? {
        do {
            let response = try await client
                .from("weight")
                .select()
                .order("date", ascending: false)
                .limit(1) // Fetch only the most recent weight
                .execute()
                .data
            
            let decodedWeights = try JSONDecoder().decode([Weight].self, from: response)
            
            return decodedWeights.first // Return the most recent weight
        } catch {
            print("Error fetching the latest weight: \(error)")
            return nil
        }
    }
    
    // Fetch weights from Supabase
    func fetchWeights() async {
        
        do {
            let response = try await client
                .from("weight")
                .select()
                .order("date", ascending: false)
                .execute()
                .data
            
            let decodedWeights = try JSONDecoder().decode([Weight].self, from: response)
            
            self.weights = decodedWeights
        } catch {
            print("Error fetching weights: \(error)")
        }
    }

    // Add a new weight
    
    func addWeight(weightValue: Float) async {
        // Format the date as a string to insert into Supabase
        let isoFormatter = ISO8601DateFormatter()
        let dateString = isoFormatter.string(from: Date()) // Format the current date as a string
        
        // Create the WeightInsert object
        let newWeightData = WeightInsert(weight: weightValue, date: dateString)
        
        do {
            // Insert the data using the WeightInsert struct
            _ = try await client
                .from("weight") // Your Supabase table name
                .insert(newWeightData) // Pass the newWeightData struct
                .execute()
            
            // Fetch the updated weights after insertion
            Task {
                await self.fetchWeights()
            }
        } catch {
            print("Error adding weight: \(error)")
        }
    }

    // Update an existing weight entry
//    func updateWeight(weight: Weight) async {
//        do {
//            let response = try await client
//                .from("weights") // Your Supabase table name
//                .update(["weight": weight.weight, "date": weight.date])
//                .eq("id", value: weight.id.uuidString)
//                .execute()
//            
//            DispatchQueue.main.async {
//                if let index = self.weights.firstIndex(where: { $0.id == weight.id }) {
//                    self.weights[index] = weight
//                }
//            }
//        } catch {
//            print("Error updating weight: \(error)")
//        }
//    }

//     Delete a weight entry
    
    func deleteWeight(weight: Weight) async {
        do {
            _ = try await client
                .from("weight") // Your Supabase table name
                .delete()
                .eq("id", value: weight.id) // Directly use weight.id since it's an Int
                .execute()
            
            DispatchQueue.main.async {
                self.weights.removeAll(where: { $0.id == weight.id }) // Remove locally
            }
        } catch {
            print("Error deleting weight: \(error)")
        }
    }
}
