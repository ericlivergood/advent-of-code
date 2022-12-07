# Advent of code Day 4
class Day4
  def self.expand_assignments(assignment_string)
    split_assignment = assignment_string.split(',')
    first = split_assignment[0].split('-')
    second = split_assignment[1].split('-')

    [
      (first[0].to_i..first[1].to_i).to_a,
      (second[0].to_i..second[1].to_i).to_a
    ]
  end

  def self.find_overlapping_assignments(assignments)
    overlap = []
    assignments[0].each do |i|
      assignments[1].each do |j|
        overlap.push(i) if i == j
      end
    end

    overlap
  end

  def self.overlap?(assignments)
    find_overlapping_assignments(assignments).length.positive?
  end

  def self.contains_encapsulated_assignment?(assignments)
    overlap = find_overlapping_assignments(assignments)
    (overlap.length == assignments[0].length || overlap.length == assignments[1].length)
  end

  def self.count_encapsulated_assignments(assignments)
    count = 0
    assignments.each do |a|
      expanded = expand_assignments(a)
      count += 1 if contains_encapsulated_assignment?(expanded)
    end
    count
  end

  def self.count_overlapping_assignments(assignments)
    count = 0
    assignments.each do |a|
      expanded = expand_assignments(a)
      count += 1 if overlap?(expanded)
    end
    count
  end

  def self.run
    lines = []
    File.foreach('./data') { |line| lines.push(line) }
    puts count_overlapping_assignments(lines)
  end
end

Day4.run
