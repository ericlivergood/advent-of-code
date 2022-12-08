require './main'

test_data = [
    ['bvwbjplbgvbhsrlpgdmjqwftvncz', 5],
    ['nppdvjthqldpwncqszvftbrmjlhg', 6],
    ['nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg', 10],
    ['zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw', 11]
]
start_of_message_data = [
    ['mjqjpqmgbljsphdztnvjfqwrcgsmlb', 19],
    ['bvwbjplbgvbhsrlpgdmjqwftvncz', 23],
    ['nppdvjthqldpwncqszvftbrmjlhg', 23],
    ['nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg', 29],
    ['zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw', 26],

]

describe SignalProcessor do
    it 'identifies signal marker' do
        expect(SignalProcessor.is_signal_marker?('abcd', 4)).to eql(true)
        expect(SignalProcessor.is_signal_marker?('aabc', 4)).to eql(false)
        expect(SignalProcessor.is_signal_marker?('abca', 4)).to eql(false)
        expect(SignalProcessor.is_signal_marker?('abcda', 4)).to eql(false)
        expect(SignalProcessor.is_signal_marker?('abcde', 5)).to eql(true)
        expect(SignalProcessor.is_signal_marker?('abcda', 5)).to eql(false)
        expect(SignalProcessor.is_signal_marker?('abcdef', 5)).to eql(false)
        expect(SignalProcessor.is_signal_marker?('qmgbljsphdztnv', 14)).to eql(true)
        expect(SignalProcessor.is_signal_marker?('jpqmgbljsphdzt', 14)).to eql(false)
    end

    it 'finds signal marker' do
        expect(SignalProcessor.find_signal_marker('abcdabcdabcd')).to eql(4)
        expect(SignalProcessor.find_signal_marker('abadbca')).to eql(6)
    end

    it 'finds test signal markers' do
        test_data.each do |d|
            expect(SignalProcessor.find_signal_marker(d[0])).to eql(d[1])
        end
    end
    it 'finds test start of message markers' do
        start_of_message_data.each do |d|
            expect(SignalProcessor.find_start_of_message(d[0])).to eql(d[1])
        end
    end
     
end