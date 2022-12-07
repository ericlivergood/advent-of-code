
class Day3
    def self.find_duplicate_item(item_string)
        mid = item_string.length / 2
        last = item_string.length - 1
        group1 = item_string[0, mid]
        group2 = item_string[mid, last]

        group1.split('').each { |s1| 
            group2.split('').each { |s2|
                return s1 if s1 == s2
            }
        }
    end

    def self.get_item_priority(item)
        char_code = item.ord

        if(char_code >= 97)
            char_code - 96
        else
            char_code - 38
        end
    end

    def self.get_badge_for_group(grouplines) 
        item_counts = {}
        line_count = grouplines.length

        grouplines.each{ |l|
            chars = l.split('').uniq.each{ |c|
                if(item_counts.key?(c))
                    item_counts[c] += 1
                else 
                    item_counts[c] = 1
                end
            }
        }

        item_counts.keys.each{ |k| 
            return k if item_counts[k] == line_count
        }
    end

    def self.get_priority_sum(items) 
        sum = 0
        items.each { |i|
            dupe = find_duplicate_item(i)
            sum += get_item_priority(dupe)
        }
        sum
    end

    def self.get_badge_sum(items)
        sum = 0

        group = []
        items.each{ |i|
            group.push(i)

            if(group.length == 3) 
                badge = get_badge_for_group(group)
                sum += get_item_priority(badge)
                group = []
            end
        }

        sum
    end
end

lines = []

File.foreach("./data") { |line| 
    lines.push(line)
}
puts Day3.get_badge_sum(lines)