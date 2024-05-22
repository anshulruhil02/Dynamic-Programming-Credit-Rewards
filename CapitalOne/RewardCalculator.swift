//
//  RewardCalculator.swift
//  CapitalOne
//
//  Created by Anshul Ruhil on 2024-05-21.
//

import Foundation

// Enum for different merchants
enum Merchant: String {
    case sportcheck = "sportcheck"
    case timHortons = "tim hortons"
    case subway = "subway"
}

// Struct for reward rules
struct RewardRule {
    let points: Int
    let spends: [Merchant: Int]
}

class RewardCalculator {
    
    // Function to calculate rewards for a list of transactions
    static func calculateRewards(transactions: [Transaction]) -> MonthlyRewards {
        // Dictionary to store total amounts spent per merchant
        let merchantTotals = combineTransactions(transactions)
        
        // Calculate total points using reward rules
        let totalPoints = calculatePoints(merchantTotals: merchantTotals)
        
        // Create an empty rewards list (can be filled with actual reward objects if needed)
        let rewards: [RewardPoints] = []
        
        return MonthlyRewards(totalPoints: totalPoints, rewards: rewards)
    }
    
    // Combine transactions by merchant and calculate total amount spent for each merchant
    private static func combineTransactions(_ transactions: [Transaction]) -> [Merchant: Int] {
        var merchantTotals: [Merchant: Int] = [:]
        
        for transaction in transactions {
            if let merchant = Merchant(rawValue: transaction.merchantCode) {
                merchantTotals[merchant, default: 0] += transaction.amountCents
            }
        }
        
        return merchantTotals
    }
    
    // Using Dynamic programming to maximize the total number of points (maximize points earned per dollar spent at every step of optimization)
    private static func calculatePoints(merchantTotals: [Merchant: Int]) -> Int {
        // Define reward rules
        let rules = [
            RewardRule(points: 500, spends: [.sportcheck: 75, .timHortons: 25, .subway: 25]),  // Rule 1
            RewardRule(points: 300, spends: [.sportcheck: 75, .timHortons: 25]),                // Rule 2
            RewardRule(points: 200, spends: [.sportcheck: 75]),                                  // Rule 3
            RewardRule(points: 150, spends: [.sportcheck: 25, .timHortons: 10, .subway: 10]),  // Rule 4
            RewardRule(points: 75, spends: [.sportcheck: 25, .timHortons: 10]),                 // Rule 5
            RewardRule(points: 75, spends: [.sportcheck: 20])                                   // Rule 6
        ]
        
        // Sort rules by points per dollar in descending order
        let sortedRules = rules.sorted { pointsPerDollar(for: $0) > pointsPerDollar(for: $1) }
        
        // Convert amounts to dollars
        var merchantAmounts = merchantTotals.mapValues { $0 / 100 }
        
        // Apply reward rules to calculate total points
        var totalPoints = 0
        for rule in sortedRules {
            totalPoints += applyRule(rule, to: &merchantAmounts)
        }
        
        // Rule 7: 1 point for every $1 spent for all other purchases
        totalPoints += merchantAmounts.values.reduce(0, +)
        
        return totalPoints
    }
    
    // Calculate points per dollar for a given rule
    private static func pointsPerDollar(for rule: RewardRule) -> Double {
        let totalSpend = rule.spends.values.reduce(0, +)
        return Double(rule.points) / Double(totalSpend)
    }
    
    // Apply a reward rule to the merchant amounts
    private static func applyRule(_ rule: RewardRule, to merchantAmounts: inout [Merchant: Int]) -> Int {
        var pointsEarned = 0
        
        while canApplyRule(rule, to: merchantAmounts) {
            pointsEarned += rule.points
            for (merchant, amount) in rule.spends {
                merchantAmounts[merchant]? -= amount
            }
        }
        
        return pointsEarned
    }
    
    // Check if a rule can be applied to the current merchant amounts
    private static func canApplyRule(_ rule: RewardRule, to merchantAmounts: [Merchant: Int]) -> Bool {
        for (merchant, requiredAmount) in rule.spends {
            if merchantAmounts[merchant] ?? 0 < requiredAmount {
                return false
            }
        }
        return true
    }
}
