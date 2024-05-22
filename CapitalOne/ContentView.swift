//
//  ContentView.swift
//  CapitalOne
//
//  Created by Anshul Ruhil on 2024-05-21.
//

import SwiftUI

struct ContentView: View {
    @State private var transactions: [Transaction] = [] // State variable to store transactions
    @State private var totalPoints: Int = 0 // State variable to store total points
    @State private var rewards: [RewardPoints] = [] // State variable to store rewards for each transaction
    
    @State private var selectedMerchant: String = "sportcheck" // State variable for selected merchant
    @State private var amountSpent: String = "" // State variable for amount spent input
    let merchants = ["sportcheck", "tim hortons", "subway"] // List of merchants for picker

    // Capital One Color Scheme
    let capitalOneBlue = Color(red: 0.0/255, green: 38.0/255, blue: 77.0/255)
    let capitalOneLightBlue = Color(red: 0.0/255, green: 108.0/255, blue: 182.0/255)
    let capitalOneRed = Color(red: 204.0/255, green: 0.0/255, blue: 0.0/255)
    
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading, spacing: 20) {
                    // Picker to select a merchant
                    Text("Select a Merchant")
                        .font(.headline)
                        .foregroundColor(capitalOneBlue)
                    Picker("Select a Merchant", selection: $selectedMerchant) {
                        ForEach(merchants, id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(capitalOneLightBlue.opacity(0.1))
                    .cornerRadius(10)
                    
                    // TextField to enter the amount spent
                    Text("Enter Amount Spent (in dollars)")
                        .font(.headline)
                        .foregroundColor(capitalOneBlue)
                    TextField("Amount", text: $amountSpent)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    // Button to add the transaction
                    Button(action: {
                        if let amountDouble = Double(amountSpent) {
                            let amount = Int(amountDouble * 100) // Convert to cents
                            let newTransaction = Transaction(id: UUID().uuidString, date: getCurrentDate(), merchantCode: selectedMerchant, amountCents: amount)
                            transactions.append(newTransaction)
                            amountSpent = "" // Clear the input field
                            print("Added transaction: \(newTransaction)")
                        }
                    }) {
                        Text("Add Transaction")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(capitalOneBlue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(.systemGroupedBackground))
                .cornerRadius(10)
                .padding()
                
                
                
                // Button to calculate rewards
                Button("Calculate Rewards") {
                    let result = RewardCalculator.calculateRewards(transactions: transactions)
                    self.totalPoints = result.totalPoints
                    self.rewards = result.rewards
                    print("Total Points: \(totalPoints)")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(capitalOneRed)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding()
                
                // Display total points
                Text("Total Points: \(totalPoints)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(capitalOneBlue)
                    .padding()
                
                // List to display transactions
                List {
                    Section(header: Text("Transactions")) {
                        ForEach(transactions) { transaction in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(transaction.merchantCode.capitalized)
                                        .font(.headline)
                                    Text(transaction.date)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text("\(Double(transaction.amountCents) / 100, specifier: "%.2f") $")
                                    .font(.headline)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Credit Card Rewards") // Navigation title
        }
    }
    
    // Helper function to get the current date as a string
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
