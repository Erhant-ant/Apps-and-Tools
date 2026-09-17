# Tip Calculator

A simple Python tip calculator application.

## Usage

```bash
python main.py
```

## Features
- Enter the total meal price
- Choose a tip from presets (10%, 12%, 15%) or enter a custom percentage
- Split the bill among multiple people
- Input validation for bill, tip percentage, and split count
- Friendly and clear error messages

## Example Output

```
Welcome to the Tip Calculator!

Total meal price: 100
Choose a tip option:
  1) 10%
  2) 12%
  3) 15%
  4) Custom tip
Select 1, 2, 3, or 4: 3
How many people to split the bill?: 4

----------------------------------
Bill summary
----------------------------------
Bill amount         : $100.00
Tip percentage      : 15.00%
Tip amount          : $15.00
Total with tip      : $115.00
Split between people: 4
Each person pays    : $28.75
----------------------------------
```

## Requirements

- Python 3.x

## How It Works

1. Enter the total meal price (must be positive)
2. Select a preset tip percentage or enter a custom value
3. Enter how many people to split the bill (must be at least 1)
4. Get the amount each person needs to pay (formatted to 2 decimals)

---

**Author:** Erhant-ant
