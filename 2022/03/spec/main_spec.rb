require './main'

describe Day3 do
    describe 'get_item_priority' do
        it 'calculates lowercase priority' do
            expect(Day3.get_item_priority('a')).to eql(1)
            expect(Day3.get_item_priority('b')).to eql(2)
            expect(Day3.get_item_priority('c')).to eql(3)
            expect(Day3.get_item_priority('z')).to eql(26)
        end

        it 'calculates uppercase priority' do
            expect(Day3.get_item_priority('A')).to eql(27)
            expect(Day3.get_item_priority('B')).to eql(28)
            expect(Day3.get_item_priority('C')).to eql(29)
            expect(Day3.get_item_priority('Z')).to eql(52)
        end
    end

    describe 'find_duplicate_item' do
        it 'finds duplicate in 4 items' do
            expect(Day3.find_duplicate_item('abac')).to eql('a')
            expect(Day3.find_duplicate_item('AbcA')).to eql('A')
        end
        it 'finds duplicate in 8 items' do
            expect(Day3.find_duplicate_item('abcdefga')).to eql('a')
            expect(Day3.find_duplicate_item('ABCDAfga')).to eql('A')
        end
    end

    describe 'get_priority_sum' do 
        it 'calculates test sum' do
           items = [
            'vJrwpWtwJgWrhcsFMMfFFhFp',
            'jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL',
            'PmmdzqPrVvPwwTWBwg',
            'wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn',
            'ttgJtRGJQctTZtZT',
            'CrZsJsPPZsGzwwsLwLmpwMDw',
           ] 

           expect(Day3.get_priority_sum(items)).to eql(157)
        end
    end

    describe 'get_badge_for_group' do
        it 'finds badge for group 1' do
            group = [
                'vJrwpWtwJgWrhcsFMMfFFhFp',
                'jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL',
                'PmmdzqPrVvPwwTWBwg',
               ] 

            expect(Day3.get_badge_for_group(group)).to eql('r')
        end

        it 'finds badge for group 2' do
            group = [
                'wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn',
                'ttgJtRGJQctTZtZT',
                'CrZsJsPPZsGzwwsLwLmpwMDw',
               ] 
               
            expect(Day3.get_badge_for_group(group)).to eql('Z')
        end
    end

    describe 'get_badge_sum' do 
        it 'calculates test sum' do
           items = [
            'vJrwpWtwJgWrhcsFMMfFFhFp',
            'jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL',
            'PmmdzqPrVvPwwTWBwg',
            'wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn',
            'ttgJtRGJQctTZtZT',
            'CrZsJsPPZsGzwwsLwLmpwMDw',
           ] 

           expect(Day3.get_badge_sum(items)).to eql(70)
        end
    end
end