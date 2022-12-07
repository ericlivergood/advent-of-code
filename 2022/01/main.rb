max = 0
current = 0

totals = []

File.foreach("./data") { |line| 
    if line.strip.empty?
        totals.push(current)
        current = 0
    end

    current += line.to_i
}

puts totals.sort!.reverse.take(3).reduce(0) {
    |sum, num|
    sum+num
}