//
//  RewardCalculatorTests.m
//  CapitalOneTests
//
//  Created by Anshul Ruhil on 2024-05-22.
//

import XCTest;
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
        // - 2500 cents ($25) at sportcheck does not match any rule fully
        // - 1000 cents ($10) at tim_hortons does not match any rule fully
        // - 500 cents ($5) at the_bay does not match any rule
        // Remaining cents should be calculated as 1 point per dollar
        let expectedPoints = 25 + 10 + 5 // 1 point per dollar
        
        // Check that the total points are calculated correctly
        XCTAssertEqual(monthlyRewards.totalPoints, expectedPoints, "Total points should be \(expectedPoints)")
    }
    
    // Other test cases...
}
