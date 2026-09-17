from typing import Dict, Optional, Tuple
import locale
import sys


# Sabitler
PRESET_TIPS: Dict[str, float] = {"1": 10.0, "2": 12.0, "3": 15.0}
CURRENCY_SYMBOLS: Dict[str, str] = {"USD": "$", "EUR": "€", "GBP": "£", "TRY": "₺"}
DEFAULT_CURRENCY = "USD"


def get_currency_symbol(currency_code: str) -> str:
    """Return the symbol for a given currency code."""
    return CURRENCY_SYMBOLS.get(currency_code.upper(), "$")


def format_currency(amount: float, currency_code: str = DEFAULT_CURRENCY) -> str:
    """Format a number as currency with proper symbol."""
    symbol = get_currency_symbol(currency_code)
    return f"{symbol}{amount:,.2f}"


def calculate_split_amount(
    bill: float, tip_percentage: float, split_count: int
) -> Tuple[float, float, float]:
    """Return tip amount, total cost, and per-person payment."""
    tip_amount = bill * (tip_percentage / 100)
    total_cost = bill + tip_amount
    each_person = total_cost / split_count
    return tip_amount, total_cost, each_person


def parse_positive_float(raw_value: str) -> Optional[float]:
    """Parse a string into a float greater than zero."""
    if raw_value.lower() in ("q", "quit", "exit"):
        print("\nGoodbye! Thanks for using Tip Calculator.")
        sys.exit(0)

    try:
        value = float(raw_value)
    except ValueError:
        return None
    if value <= 0:
        return None
    return value


def parse_positive_int(raw_value: str) -> Optional[int]:
    """Parse a string into an integer greater than zero."""
    if raw_value.lower() in ("q", "quit", "exit"):
        print("\nGoodbye! Thanks for using Tip Calculator.")
        sys.exit(0)

    try:
        value = int(raw_value)
    except ValueError:
        return None
    if value <= 0:
        return None
    return value


def get_positive_float(prompt: str) -> float:
    """Keep asking until user provides a valid positive float."""
    while True:
        user_input = input(f"{prompt} (or 'q' to quit): ").strip()
        value = parse_positive_float(user_input)
        if value is None:
            print("❌ Please enter a valid number greater than 0.")
            continue
        return value


def get_positive_int(prompt: str) -> int:
    """Keep asking until user provides a valid positive integer."""
    while True:
        user_input = input(f"{prompt} (or 'q' to quit): ").strip()
        value = parse_positive_int(user_input)
        if value is None:
            print("❌ Please enter a whole number greater than 0.")
            continue
        return value


def get_tip_percentage() -> float:
    """Present tip options and return the selected percentage."""
    print("\n💡 Choose a tip option:")
    print("  1) 10%  (Standard)")
    print("  2) 12%  (Good)")
    print("  3) 15%  (Great)")
    print("  4) Custom tip")

    while True:
        choice = input("Select 1, 2, 3, or 4: ").strip()

        if choice.lower() in ("q", "quit", "exit"):
            print("\nGoodbye! Thanks for using Tip Calculator.")
            sys.exit(0)

        if choice in PRESET_TIPS:
            return PRESET_TIPS[choice]

        if choice == "4":
            return get_positive_float("Enter custom tip percentage")

        print("❌ Please choose one of the available options (1, 2, 3, or 4).")


def get_currency_choice() -> str:
    """Let user choose their currency."""
    print("\n💱 Available currencies:")
    for code, symbol in CURRENCY_SYMBOLS.items():
        print(f"  • {code} ({symbol})")

    while True:
        choice = input(f"Enter currency code (default: {DEFAULT_CURRENCY}): ").strip().upper()

        if not choice:
            return DEFAULT_CURRENCY

        if choice.lower() in ("q", "quit", "exit"):
            print("\nGoodbye! Thanks for using Tip Calculator.")
            sys.exit(0)

        if choice in CURRENCY_SYMBOLS:
            return choice

        print(f"❌ Currency '{choice}' not available. Options: {', '.join(CURRENCY_SYMBOLS.keys())}")


def print_summary(
    bill: float,
    tip_percentage: float,
    tip_amount: float,
    total_cost: float,
    each_person: float,
    split_count: int,
    currency: str = DEFAULT_CURRENCY,
) -> None:
    """Display a formatted summary of the bill split."""
    print("\n" + "=" * 40)
    print("           🧾 BILL SUMMARY")
    print("=" * 40)
    print(f"  Bill amount         : {format_currency(bill, currency)}")
    print(f"  Tip percentage      : {tip_percentage:.1f}%")
    print(f"  Tip amount          : {format_currency(tip_amount, currency)}")
    print(f"  Total with tip      : {format_currency(total_cost, currency)}")
    print(f"  Split between       : {split_count} {'person' if split_count == 1 else 'people'}")
    print(f"  Each person pays    : {format_currency(each_person, currency)}")
    print("=" * 40)

    # Show tip amount as a monthly/yearly reminder if it's large enough
    if tip_amount >= 50:
        print(f"  💰 That's a generous tip! Monthly that would be ~{format_currency(tip_amount * 30, currency)}")
    print()


def ask_to_continue() -> bool:
    """Ask user if they want to calculate another bill."""
    while True:
        choice = input("🔄 Calculate another bill? (y/n): ").strip().lower()
        if choice in ("y", "yes"):
            return True
        elif choice in ("n", "no", "q", "quit", "exit"):
            return False
        print("❌ Please enter 'y' or 'n'.")


def main() -> None:
    """Main function to run the tip calculator."""
    print("\n" + "=" * 40)
    print("   💰 WELCOME TO TIP CALCULATOR")
    print("   Split your bill like a pro!")
    print("=" * 40)
    print("   💡 Tip: Type 'q' at any prompt to quit.\n")

    # Set locale for number formatting (fallback gracefully)
    try:
        locale.setlocale(locale.LC_ALL, "")
    except locale.Error:
        pass  # Use default formatting if locale not available

    currency = get_currency_choice()

    while True:
        print("\n" + "-" * 40)
        bill = get_positive_float("💵 Total bill amount")
        tip_percentage = get_tip_percentage()
        split_count = get_positive_int("👥 How many people are splitting")

        tip_amount, total_cost, each_person = calculate_split_amount(
            bill, tip_percentage, split_count
        )

        print_summary(
            bill, tip_percentage, tip_amount, total_cost, each_person, split_count, currency
        )

        if not ask_to_continue():
            print("\n👋 Thanks for using Tip Calculator! Have a great day!\n")
            break


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n👋 Program interrupted. Goodbye!\n")
        sys.exit(0)
