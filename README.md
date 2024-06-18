

## Project Overview
This project is a SwiftUI application that calculates credit card rewards based on user transactions. The application allows users to input transactions, view total reward points, and see a list of all transactions.



https://github.com/anshulruhil02/Dynamic-Programming-Credit-Rewards/assets/92406374/fc61b6e5-4f23-4340-8548-687c6f009d94


## Business Logic
### Dynamic Programming Approach to Calculating Reward Points

The application uses a dynamic programming approach to maximize the total number of points earned based on the transactions entered by the user. Here’s a detailed explanation of the business logic:

1. **Transaction Aggregation**:
    - Transactions are aggregated by merchant to calculate the total amount spent at each merchant.

2. **Reward Rules**:
    - The application uses predefined reward rules to calculate points. Each rule specifies a set of merchants and the minimum spending required at each merchant to earn a certain number of points.

3. **Points Calculation**:
    - The points calculation process involves the following steps:
        1. **Define Rules**: The rules are defined as a list of tuples where each tuple contains the number of points and a dictionary of spending requirements for each merchant.
        2. **Sort Rules**: The rules are sorted by the points per dollar ratio in descending order. This ensures that the rules which provide the highest points per dollar spent are applied first.
        3. **Apply Rules**: The sorted rules are applied iteratively. For each rule, the algorithm checks if the spending requirements are met. If the requirements are met, the points are added to the total, and the spending amounts are decremented accordingly.
        4. **Remaining Spend**: After applying all rules, any remaining spend is converted to points at a rate of 1 point per dollar spent.

4. **Dynamic Programming Optimization**:
    - The algorithm uses dynamic programming to ensure that at each step, the optimal decision (maximizing points per dollar spent) is made. This involves maintaining a running total of points and updating the remaining spend after each rule is applied.

### Rule Application
- **Rule 1**: 500 points for every $75 spend at Sport Check, $25 spend at Tim Hortons and $25 spend at Subway
- **Rule 2**: 300 points for every $75 spend at Sport Check and $25 spend at Tim Hortons
- **Rule 3**: 200 points for every $75 spend at Sport Check
- **Rule 4**: 150 points for every $25 spend at Sport Check, $10 spend at Tim Hortons
and $10 spend at Subway
- **Rule 5**: 75 points for every $25 spend at Sport Check and $10 spend at Tim
Hortons
- **Rule 6**: 75 point for every $20 spend at Sport Check
- **Rule 7**: 1 points for every $1 spend for all other purchases (including leover
amount)

The algorithm first checks if Rule 1 can be applied. If the spending requirements are met, 500 points are awarded, and the spending amounts are decremented. The process is repeated for all rules in descending order of points per dollar until no more rules can be applied.

By following this approach, the application ensures that the total points earned are maximized based on the user’s transactions.
