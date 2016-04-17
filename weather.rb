weather = "rainy"

if weather == "sunny"
	puts "Go for a run!"
end

#okay expect this to throw error
# busy = "busy" + 10
# puts "Hang out with friends!" unless busy

#why does this NOT throw conversion error? because it is an overloaded operator (repeat string 10 times)
busy = "busy" * 10
puts "Hang out with friends!" unless busy

items = 2001
if items > 2000
	message = "Your inventory is full!"
else
	message = "You still have room in your inventory."
end

puts message

#is better so
message = items > 2000 ? "Your inventory is full!" : "You still have room in your inventory."

puts message