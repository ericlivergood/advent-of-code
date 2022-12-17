
class PacketInspector
  def compute_index_sum(input)
    i = 0
    sum = 0
    while(i < input.length)
      sum += (i/3+1) if is_in_right_order?(input[i], input[i + 1])
      i+=3
    end
    sum
  end

  def get_decoder_key(input)
    input = input.filter{|x| !x.nil?}
    input.push([[2]]) unless input.include?([[2]])
    input.push([[6]]) unless input.include?([[6]])

    input = sort_packets(input)

    decoder_start = input.index([[2]])
    decoder_end = input.index([[6]])
    (decoder_start+1) * (decoder_end+1)
  end

  def sort_packets(input)
    out_of_order = true

    while(out_of_order) do
      out_of_order = false

      (0..input.length - 2).each do|i|
        unless is_in_right_order?(input[i], input[i + 1])
          t1 = input[i]
          t2 = input[i + 1]
          input[i] = t2
          input[i+1] = t1
          out_of_order = true
        end
      end
    end
    input
  end

  def is_decoder_packet?(p)
    return true if p == [[2]]
    return true if p == [[6]]
    return false
  end

  def is_in_right_order?(left, right)
    #puts "Comparing #{left} and #{right}"
    if(left.kind_of?(Integer) && right.kind_of?(Integer))
      if(left < right)
        return true
      elsif(left > right)
        return false
      end
    elsif(left.kind_of?(Array) && right.kind_of?(Array))
      length = [left.length, right.length].max
      (0..length - 1).each do |i|
        return true if left[i].nil?
        return false if right[i].nil?

        result = is_in_right_order?(left[i], right[i])
        return result unless result.nil?
      end
      nil
    elsif(left.kind_of?(Array) && right.kind_of?(Integer))
      return is_in_right_order?(left, [ right ])
    elsif(left.kind_of?(Integer) && right.kind_of?(Array))
      return is_in_right_order?([ left ], right)
    else
      raise "wat: #{left}, #{right}"
    end
  end
end
