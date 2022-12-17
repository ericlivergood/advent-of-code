require './monkey'
monkeys = []
# Monkey 0:
#   Starting items: 83, 97, 95, 67
#   Operation: new = old * 19
#   Test: divisible by 17
#     If true: throw to monkey 2
#     If false: throw to monkey 7
monkey0 = Monkey.new([83, 97, 95, 67], ->(old) { old * 19}, ->(x) { x % 17 == 0 ? monkeys[2] : monkeys[7]}, 9699690)

# Monkey 1:
#   Starting items: 71, 70, 79, 88, 56, 70
#   Operation: new = old + 2
#   Test: divisible by 19
#     If true: throw to monkey 7
#     If false: throw to monkey 0
monkey1 = Monkey.new([71, 70, 79, 88, 56, 70], ->(old) { old + 2 }, ->(x) { x % 19 == 0 ? monkeys[7] : monkeys[0]}, 9699690)

# Monkey 2:
#   Starting items: 98, 51, 51, 63, 80, 85, 84, 95
#   Operation: new = old + 7
#   Test: divisible by 7
#     If true: throw to monkey 4
#     If false: throw to monkey 3
monkey2 = Monkey.new([98, 51, 51, 63, 80, 85, 84, 95], ->(old) { old + 7 }, ->(x) { x % 7 == 0 ? monkeys[4] : monkeys[3]}, 9699690)

# Monkey 3:
#   Starting items: 77, 90, 82, 80, 79
#   Operation: new = old + 1
#   Test: divisible by 11
#     If true: throw to monkey 6
#     If false: throw to monkey 4
monkey3 = Monkey.new([77, 90, 82, 80, 79], ->(old) { old + 1 }, ->(x) { x % 11 == 0 ? monkeys[6] : monkeys[4]}, 9699690)

# Monkey 4:
#   Starting items: 68
#   Operation: new = old * 5
#   Test: divisible by 13
#     If true: throw to monkey 6
#     If false: throw to monkey 5
monkey4 = Monkey.new([68], ->(old) { old * 5 }, ->(x) { x % 13 == 0 ? monkeys[6] : monkeys[5]}, 9699690)

# Monkey 5:
#   Starting items: 60, 94
#   Operation: new = old + 5
#   Test: divisible by 3
#     If true: throw to monkey 1
#     If false: throw to monkey 0
monkey5 = Monkey.new([60, 94], ->(old) { old + 5 }, ->(x) { x % 3 == 0 ? monkeys[1] : monkeys[0]}, 9699690)

# Monkey 6:
#   Starting items: 81, 51, 85
#   Operation: new = old * old
#   Test: divisible by 5
#     If true: throw to monkey 5
#     If false: throw to monkey 1
monkey6 = Monkey.new([81, 51, 85], ->(old) { old * old }, ->(x) { x % 5 == 0 ? monkeys[5] : monkeys[1]}, 9699690)

# Monkey 7:
#   Starting items: 98, 81, 63, 65, 84, 71, 84
#   Operation: new = old + 3
#   Test: divisible by 2
#     If true: throw to monkey 2
#     If false: throw to monkey 3
monkey7 = Monkey.new([98, 81, 63, 65, 84, 71, 84], ->(old) { old + 3 }, ->(x) { x % 2 == 0 ? monkeys[2] : monkeys[3]}, 9699690)

monkeys = [
  monkey0, monkey1, monkey2, monkey3, monkey4, monkey5, monkey6, monkey7
]


(1..10000).each do |i|
  monkeys.each do |m|
    m.handle_items
  end
end
counts = []
monkeys.each { |m| counts.push(m.inpection_count) }
counts = counts.sort.reverse
puts (counts[0] * counts[1])