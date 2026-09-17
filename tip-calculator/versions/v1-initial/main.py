def main():
    print("\nWelcome to the Tip calculator\n")
    
    #input from users
    bill = float(input("Total meal price: "))
    tip_percentage = int(input("How much tip would you like to give? (10, 12, or 15): "))
    split = int(input("How many people to split the bill?:" ))
    
    #Calculation
    tip = bill*(tip_percentage/100)
    total_cost = bill + tip
    each_person = total_cost/split
    
    
    #result   
    print(f"Total cost is {total_cost}$, {tip_percentage}% you tiped and each person will pay {round(each_person,2)}")
    
    
 
    
    
main()