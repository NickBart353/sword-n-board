@tool
extends Node

const uuid_chars = "0123456789abcdef"

func uuid4() -> String:
	var result := ""
	for i in range(32):
		if i in [8, 12, 16, 20]: result += "-"
		if i == 12: result += "4"
		elif i == 16:
			var r := randi() % 16
			r = (r & 0x3) | 0x8 # variant bits
			result += uuid_chars[r]
		else:
			var r := randi() % 16
			result += uuid_chars[r]
	return result
