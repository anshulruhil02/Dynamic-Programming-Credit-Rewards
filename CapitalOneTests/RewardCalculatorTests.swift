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
            Transaction(id: "T2", date: "2021-05-10", merchantCode: "tim hortons", amountCents: 1000),
            Transaction(id: "T3", date: "2021-05-10", merchantCode: "subway", amountCents: 500)
        ]
        
        // Calculate merchant totals
        let merchantTotals = RewardCalculator.combineTransactions(transactions)
        print("Merchant Totals in Test: \(merchantTotals)")
        
        // Calculate total points using merchant totals
        let totalPoints = RewardCalculator.calculatePoints(merchantTotals: merchantTotals)
        
        // The expected points calculation:
        // Rule 6: 75 points for every $20 spend at Sport Check
        // - 2500 cents ($25) at sportcheck gives 75 points for $20 and 5 points for the remaining $5
        // Rule 7: 1 point for every $1 spend for all other purchases
        // - 1000 cents ($10) at tim_hortons gives 10 points
        // - 500 cents ($5) at the_bay gives 5 points

        let expectedTotalPoints = 95
        
        // Check that the total points are calculated correctly
        XCTAssertEqual(totalPoints, expectedTotalPoints, "Total points should be \(expectedTotalPoints)")
    }
}
