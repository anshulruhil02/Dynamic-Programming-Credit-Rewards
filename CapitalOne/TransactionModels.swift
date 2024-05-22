//
//  TransactionModels.swift
//  CapitalOne
//
//  Created by Anshul Ruhil on 2024-05-21.
//
/*
 •   Separate the data models to keep the code organized and modular. This way, changes to data structures do not impact other parts the application.
 •   Identifiable Protocol: Both Transaction and RewardPoints conform to Identifiable to leverage SwiftUI’s list capabilities, ensuring each item in the list has a unique identifier.
 •   Data Separation: Keeping data structures in a separate file ensures clarity and modularity, making the application easier to manage and extend.
 */

import Foundation

// Structure to represent a transaction
struct Transaction: Identifiable {
    let id: String // Unique identifier for the transaction
    let date: String // Date of the transaction
    let merchantCode: String // Code or name of the merchant
    let amountCents: Int // Amount spent in cents
}

// Structure to represent reward points for a transaction
struct RewardPoints: Identifiable {
    let id = UUID() // Unique identifier for each reward point entry
    let transactionId: String // ID of the transaction
    let points: Int // Points earned for the transaction
}

// Structure to represent the total rewards for a month
struct MonthlyRewards {
    let totalPoints: Int // Total points earned for the month
    let rewards: [RewardPoints] // List of reward points for each transaction
}
