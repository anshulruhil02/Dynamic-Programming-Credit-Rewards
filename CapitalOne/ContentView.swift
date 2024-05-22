//
//  ContentView.swift
//  CapitalOne
//
//  Created by Anshul Ruhil on 2024-05-21.
//

import SwiftUI

// Constants used throughout the app for merchants and Capital One color scheme
struct Constants {
    static let merchants = ["sportcheck", "tim hortons", "subway"]
    static let capitalOneBlue = Color(red: 0.0/255, green: 38.0/255, blue: 77.0/255)
    static let capitalOneLightBlue = Color(red: 0.0/255, green: 108.0/255, blue: 182.0/255)
    static let capitalOneRed = Color(red: 204.0/255, green: 0.0/255, blue: 0.0/255)
}

struct ContentView: View {
    @State private var transactions: [Transaction] = [] // State variable to store transactions
    @State private var totalPoints: Int = 0 // State variable to store total points
    @State private var rewards: [RewardPoints] = [] // State variable to store rewards for each transaction
    @State private var selectedMerchant: String = Constants.merchants.first ?? "" // State variable for selected merchant
    @State private var amountSpent: String = "" // State variable for amount spent input
    @State private var isSheetPresented: Bool = false // State variable to control sheet presentation

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    // View for selecting a merchant
                    MerchantPickerView(selectedMerchant: $selectedMerchant, merchants: Constants.merchants, colorScheme: (Constants.capitalOneBlue, Constants.capitalOneLightBlue))
                    // View for entering the amount spent
                    AmountInputView(amountSpent: $amountSpent, colorScheme: Constants.capitalOneBlue)
                    // Button to add a transaction
                    AddTransactionButton(selectedMerchant: $selectedMerchant, amountSpent: $amountSpent, transactions: $transactions, colorScheme: Constants.capitalOneBlue)
                    // Button to calculate rewards based on transactions
                    CalculateRewardsButton(transactions: transactions, totalPoints: $totalPoints, rewards: $rewards, colorScheme: Constants.capitalOneRed)
                    // View to display total points
                    TotalPointsView(totalPoints: totalPoints, colorScheme: Constants.capitalOneBlue)
                    Divider() // Divider for visual separation
                    // Button to view list of transactions
                    ViewTransactionsButton(isSheetPresented: $isSheetPresented, colorScheme: Constants.capitalOneBlue)
                }
                .padding()
            }
            .background(Color(.systemBackground))
            .navigationTitle("Credit Card Rewards") // Navigation title
            .sheet(isPresented: $isSheetPresented) {
                TransactionsListView(transactions: transactions) // Sheet to display transactions list
            }
        }
    }
}

// View for selecting a merchant from a picker
struct MerchantPickerView: View {
    @Binding var selectedMerchant: String
    let merchants: [String]
    let colorScheme: (blue: Color, lightBlue: Color)

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Select a Merchant")
                .font(.headline)
                .foregroundColor(colorScheme.blue)
            Picker("Select a Merchant", selection: $selectedMerchant) {
                ForEach(merchants, id: \.self) {
                    Text($0.capitalized)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .background(colorScheme.lightBlue.opacity(0.1))
            .cornerRadius(10)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(10)
        .padding()
    }
}

// View for entering the amount spent
struct AmountInputView: View {
    @Binding var amountSpent: String
    let colorScheme: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Enter Amount Spent (in dollars)")
                .font(.headline)
                .foregroundColor(colorScheme)
            TextField("Amount", text: $amountSpent)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .cornerRadius(10)
        .padding()
    }
}

// Button to add a transaction
struct AddTransactionButton: View {
    @Binding var selectedMerchant: String
    @Binding var amountSpent: String
    @Binding var transactions: [Transaction]
    let colorScheme: Color

    var body: some View {
        Button(action: addTransaction) {
            Text("Add Transaction")
                .padding()
                .frame(maxWidth: .infinity)
                .background(colorScheme)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }

    private func addTransaction() {
        if let amountDouble = Double(amountSpent) {
            let amount = Int(amountDouble * 100) // Convert to cents
            let newTransaction = Transaction(id: UUID().uuidString, date: getCurrentDate(), merchantCode: selectedMerchant, amountCents: amount)
            transactions.append(newTransaction)
            amountSpent = "" // Clear the input field
            print("Added transaction: \(newTransaction)")
        }
    }

    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

// Button to calculate rewards based on transactions
struct CalculateRewardsButton: View {
    let transactions: [Transaction]
    @Binding var totalPoints: Int
    @Binding var rewards: [RewardPoints]
    let colorScheme: Color

    var body: some View {
        Button("Calculate Rewards") {
            let result = RewardCalculator.calculateRewards(transactions: transactions)
            self.totalPoints = result.totalPoints
            self.rewards = result.rewards
            print("Total Points: \(totalPoints)")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(colorScheme)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding()
    }
}

// View to display total points
struct TotalPointsView: View {
    let totalPoints: Int
    let colorScheme: Color

    var body: some View {
        Text("Total Points: \(totalPoints)")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(colorScheme)
            .padding()
    }
}

// Button to view list of transactions
struct ViewTransactionsButton: View {
    @Binding var isSheetPresented: Bool
    let colorScheme: Color

    var body: some View {
        Button(action: {
            isSheetPresented = true
        }) {
            Text("View Transactions")
                .padding()
                .frame(maxWidth: .infinity)
                .background(colorScheme)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

// View to display list of transactions
struct TransactionsListView: View {
    let transactions: [Transaction]

    var body: some View {
        GeometryReader { geometry in
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
            .frame(height: geometry.size.height) // Make the list take up the remaining space
        }
    }
}

// Preview provider for ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
