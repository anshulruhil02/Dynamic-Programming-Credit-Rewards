//
//  RewardCalculatorTests.swift
//  CapitalOneTests
//
//  Created by Anshul Ruhil on 2024-05-22.
//

import XCTest
@testable import CapitalOne

class RewardCalculatorTests: XCTestCase {

    func testCalculateRewards_givenTestCase() {
        // Define the provided test case transactions
        let transactions = [
            Transaction(id: "T1", date: "2021-05-09", merchantCode: "sportcheck", amountCents: 2500),
            Transaction(id: "T2", date: "2021-05-10", merchantCode: "tim_hortons", amountCents: 1000),
            Transaction(id: "T3", date: "2021-05-10", merchantCode: "the_bay", amountCents: 500)
        ]
        
        // Calculate rewards
        let monthlyRewards = RewardCalculator.calculateRewards(transactions: transactions)
        
        // The expected points calculation:
        // Rule 6: 75 points for every $20 spend at Sport Check
        // - 2500 cents ($25) at sportcheck gives 75 points for $20 and 5 points for the remaining $5
        // Rule 7: 1 point for every $1 spend for all other purchases
        // - 1000 cents ($10) at tim_hortons gives 10 points
        // - 500 cents ($5) at the_bay gives 5 points

        let expectedTotalPoints = 95
        let expectedTransactionPoints: [String: Int] = [
            "T1": 80,  // 75 (Rule 6) + 5 (Rule 7)
            "T2": 10,  // Rule 7
            "T3": 5    // Rule 7
        ]
        
        // Check that the total points are calculated correctly
        XCTAssertEqual(monthlyRewards.totalPoints, expectedTotalPoints, "Total points should be \(expectedTotalPoints)")
        
        // Check individual transaction points (if we have logic to store these separately)
        for reward in monthlyRewards.rewards {
            XCTAssertEqual(reward.points, expectedTransactionPoints[reward.transactionId], "Points for transaction \(reward.transactionId) should be \(expectedTransactionPoints[reward.transactionId]!)")
        }
    }
    
    // Other test cases...
}
