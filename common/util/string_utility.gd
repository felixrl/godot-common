class_name StringUtil

## ---
## STRING UTILITY
## Various static helpers for when dealing with strings
## ---
## Last edited: August 18th, 2025
## ---

## Choose singular or plural based on the given int value
## Returns the singular if the value is exactly 1. Uses the plural otherwise.
static func pluralise(singular_str: String, plural_str: String, value: int) -> String:
	if value == 1:
		return singular_str
	else:
		return plural_str
