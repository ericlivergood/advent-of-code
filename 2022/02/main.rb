#
# Rock: A, X, 1 point
# Paper: B, Y, 2 points
# Scissor: C, Z, 3 points

translation = {
    "A" => :Rock,
    "B" => :Paper,
    "C" => :Scissor,
    "X" => :Rock,
    "Y" => :Paper,
    "Z" => :Scissor
}

translation_2 = {
    "A" => :Rock,
    "B" => :Paper,
    "C" => :Scissor,
    "X" => :Lose,
    "Y" => :Draw,
    "Z" => :Win  
}


def calculate_my_play(they_played, i_need_to)
    results = {
        :Rock => {
            :Win => :Paper,
            :Draw => :Rock,
            :Lose => :Scissor
        },
        :Paper => {
            :Win => :Scissor,
            :Draw => :Paper,
            :Lose => :Rock
        },
        :Scissor => {
            :Win => :Rock,
            :Draw => :Scissor,
            :Lose => :Paper
        },
    }

    results[they_played][i_need_to]
end


def calculate_outcome(they_played, i_played)
    play_values = {
        :Rock => 1,
        :Paper => 2,
        :Scissor => 3
    }
    
    result = play_values[i_played]

    if(they_played == i_played)
        result += 3
    elsif(they_played == :Rock && i_played == :Scissor)
        result += 0
    elsif(they_played == :Rock && i_played == :Paper)
        result += 6
    elsif(they_played == :Paper && i_played == :Scissor)
        result += 6
    elsif(they_played == :Paper && i_played == :Rock)
        result += 0  
    elsif(they_played == :Scissor && i_played == :Paper)
        result += 0
    elsif(they_played == :Scissor && i_played == :Rock)
        result += 6
    end

    result
end

total = 0
File.foreach("./data") { |line| 
    they_played = translation[line[0]]
    #i_played = translation[line[2]]
    i_need_to = translation_2[line[2]]
    #puts i_need_to
    i_played = calculate_my_play(they_played, i_need_to)
    #puts i_played
    total += calculate_outcome(they_played, i_played)
}

puts total
