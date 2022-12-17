class Monkey
  attr_reader :items
  attr_reader :inpection_count
  
  def initialize(items, worry_operation, next_target, reduce_worry = nil)
    @items = items
    @worry_operation = worry_operation
    @next_target = next_target
    @inpection_count = 0
    @reduce_worry = reduce_worry
  end

  def handle_items
    while(items.length > 0)
      item = @items.shift
      handle_item(item)
    end
  end

  def handle_item(item)
    item = inspect_item(item)
    throw_item(item)
  end

  def inspect_item(item)
      @inpection_count += 1
      worry = @worry_operation.(item)
      worry = worry / 3 if @reduce_worry.nil?
      worry = worry % @reduce_worry if !@reduce_worry.nil? && worry > @reduce_worry
      worry.floor
  end

  def throw_item(item)
    monkey = @next_target.(item)
    monkey.items.push(item)
  end
end
