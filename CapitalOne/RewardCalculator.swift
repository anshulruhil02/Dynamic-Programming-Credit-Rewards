//
//  RewardCalculator.swift
//  CapitalOne
//
//  Created by Anshul Ruhil on 2024-05-21.
//
import Foundation

class RewardCalculator {
    
    // Function to calculate rewards for a list of transactions
    static func calculateRewards(transactions: [Transaction]) -> MonthlyRewards {
        // Dictionary to store merchant and amount spent (sum of all transactions for each merchant)
        var merchantTotals: [String: Int] = [:]

        // Combine transactions by merchant
        for transaction in transactions {
            merchantTotals[transaction.merchantCode, default: 0] += transaction.amountCents
        }
        
        let totalPoints = calculatePoints(merchantTotals: merchantTotals)
        
        let rewards: [RewardPoints] = []
        
        return MonthlyRewards(totalPoints: totalPoints, rewards: rewards)
    }
    
    // Using Dynamic programming to maximize the total number of points (maximize points earned per dollar spent at every step of optimization)
    private static func calculatePoints(merchantTotals: [String: Int]) -> Int {
        
        // Define the rules with their respective points and spending requirements
        let rules = [
            (500, ["sportcheck": 75, "timhortons": 25, "subway": 25]),  // Rule 1
            (300, ["sportcheck": 75, "timhortons": 25]),                // Rule 2
            (200, ["sportcheck": 75]),                                  // Rule 3
            (150, ["sportcheck": 25, "timhortons": 10, "subway": 10]),  // Rule 4
            (75, ["sportcheck": 25, "timhortons": 10]),                 // Rule 5
            (75, ["sportcheck": 20])                                    // Rule 6
        ]
        
        // Calculate points per dollar for each rule
        func pointsPerDollar(rule: (Int, [String: Int])) -> Double {
            let (points, spends) = rule
            let totalSpend = spends.values.reduce(0, +)
            return Double(points) / Double(totalSpend)
        }
            
        // Sort rules by points per dollar in descending order
        let sortedRules = rules.sorted { pointsPerDollar(rule: $0) > pointsPerDollar(rule: $1) }
        
        var sc_amount = 0
        var th_amount = 0
        var bay_amount = 0
        var points = 0
        
        // Separate amounts by merchant
        for (merchant, total) in merchantTotals {
            if merchant == "sportcheck" {
                sc_amount = total
            } else if merchant == "tim hortons" {
                th_amount = total
            } else if merchant == "subway" {
                bay_amount = total
            }
        }
        
        print("Initial amounts in cents - Sport Check: \(sc_amount), Tim Hortons: \(th_amount), Subway: \(bay_amount)")
        
        var sc_dollars = sc_amount / 100  // Convert cents to dollars for Sport Check
        var th_dollars = th_amount / 100  // Convert cents to dollars for Tim Hortons
        var bay_dollars = bay_amount / 100  // Convert cents to dollars for Subway
        
        print("Initial amounts in dollars - Sport Check: \(sc_dollars), Tim Hortons: \(th_dollars), Subway: \(bay_dollars)")
        
        // Apply the rules in order
            for (pointsPerRule, spends) in sortedRules {
                while true {
                    var canApplyRule = true
                    for (place, amount) in spends {
                        if (place == "sportcheck" && sc_dollars < amount) ||
                           (place == "timhortons" && th_dollars < amount) ||
                           (place == "subway" && bay_dollars < amount) {
                            canApplyRule = false
                            break
                        }
                    }
                    if canApplyRule {
                        points += pointsPerRule
                        for (place, amount) in spends {
                            if place == "sportcheck" {
                                sc_dollars -= amount
                            } else if place == "timhortons" {
                                th_dollars -= amount
                            } else if place == "subway" {
                                bay_dollars -= amount
                            }
                        }
                    } else {
                        break
                    }
                }
            }
            
            // Rule 7: 1 point for every $1 spent for all other purchases
            points += sc_dollars + th_dollars + bay_dollars
            
            return points
        

    }
}



// Brute force attempt :(

//        // Apply rules in order of priority to maximize points
//        while sc_dollars >= 20 || th_dollars > 0 || bay_dollars > 0 {
//            print("Current amounts - Sport Check: \(sc_dollars), Tim Hortons: \(th_dollars), Subway: \(bay_dollars)")
//
//            // Rule 1
//            if sc_dollars >= 75 && th_dollars >= 25 && bay_dollars >= 25 {
//                points += 500
//                sc_dollars -= 75
//                th_dollars -= 25
//                bay_dollars -= 25
//            }
//            // Rule 6
//            else if sc_dollars >= 25 && th_dollars >= 10 {
//                points += 75
//                sc_dollars -= 25
//                th_dollars -= 10
//            }
//            // Rule 4
//            else if sc_dollars >= 25 && th_dollars >= 10 && bay_dollars >= 10 {
//                points += 150
//                sc_dollars -= 25
//                th_dollars -= 10
//                bay_dollars -= 10
//            }
//            // Rule 2
//            else if sc_dollars >= 75 && th_dollars >= 25 {
//                points += 300
//                sc_dollars -= 75
//                th_dollars -= 25
//            }
//            // Rule 3
//            else if sc_dollars >= 75 {
//                points += 200
//                sc_dollars -= 75
//            }
//
//            // Rule 5
//            else if sc_dollars >= 20 {
//                points += 75
//                sc_dollars -= 20
//            }
//
//            // Rule 7
//            else {
//                // Apply remaining amounts as 1 point per dollar
//                points += sc_dollars + th_dollars + bay_dollars
//                sc_dollars = 0
//                th_dollars = 0
//                bay_dollars = 0
//            }
//            print("Points so far: \(points)")
//        }
//
//        return points
