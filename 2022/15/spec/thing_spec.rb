require 'benchmark'
require './thing'

describe Thing do
  it 'calculates distance' do
    thing = Thing.new(5,5)

    expect(thing.distance_to(Thing.new(5,5))).to eql(0)
    expect(thing.distance_to(Thing.new(0,0))).to eql(10)
    expect(thing.distance_to(Thing.new(10,10))).to eql(10)
    expect(thing.distance_to(Thing.new(10,0))).to eql(10)
    expect(thing.distance_to(Thing.new(0,10))).to eql(10)
    expect(thing.distance_to(Thing.new(5,10))).to eql(5)
    expect(thing.distance_to(Thing.new(10,5))).to eql(5)

  end

  it 'finds the closest thing' do
    thing1 = Thing.new(5,5)
    thing2 = Thing.new(5,6)
    thing3 = Thing.new(7,5)
    thing4 = Thing.new(3,3)

    expect(thing1.find_closest_thing([thing2,thing3,thing4])).to eql(thing2)
    expect(thing2.find_closest_thing([thing1,thing3,thing4])).to eql(thing1)
    expect(thing3.find_closest_thing([thing1,thing2,thing4])).to eql(thing1)
    expect(thing4.find_closest_thing([thing1,thing2,thing3])).to eql(thing1)
  end
end


describe Sensor do
  it 'gets beaconless area' do
    beacon = Thing.new(6,4)
    sensor = Sensor.new(5,5, [beacon])

    area = sensor.get_beaconless_area
    expect(area.length).to eql(12)

    area = sensor.get_beaconless_area(5)
    expect(area.length).to eql(5)
  end
end

describe InputParser do
  it 'parses line' do
    s1 = 'Sensor at x=251234, y=759482: closest beacon is at x=-282270, y=572396'
    s2 = 'Sensor at x=2866161, y=3374117: closest beacon is at x=2729330, y=3697325'

    sensor1,beacon1 = InputParser.parse_line(s1)
    sensor2,beacon2 = InputParser.parse_line(s2)

    expect(sensor1.x).to eql(251234)
    expect(sensor1.y).to eql(759482)
    expect(beacon1.x).to eql(-282270)
    expect(beacon1.y).to eql(572396)
    expect(sensor1.closest_beacon).to eql(beacon1)

    expect(sensor2.x).to eql(2866161)
    expect(sensor2.y).to eql(3374117)
    expect(beacon2.x).to eql(2729330)
    expect(beacon2.y).to eql(3697325)
    expect(sensor2.closest_beacon).to eql(beacon2)
  end
end

describe Tunnels do
  it 'gets beaconless points for test input' do
    test_input = [
      'Sensor at x=2, y=18: closest beacon is at x=-2, y=15',
      'Sensor at x=9, y=16: closest beacon is at x=10, y=16',
      'Sensor at x=13, y=2: closest beacon is at x=15, y=3',
      'Sensor at x=12, y=14: closest beacon is at x=10, y=16',
      'Sensor at x=10, y=20: closest beacon is at x=10, y=16',
      'Sensor at x=14, y=17: closest beacon is at x=10, y=16',
      'Sensor at x=8, y=7: closest beacon is at x=2, y=10',
      'Sensor at x=2, y=0: closest beacon is at x=2, y=10',
      'Sensor at x=0, y=11: closest beacon is at x=2, y=10',
      'Sensor at x=20, y=14: closest beacon is at x=25, y=17',
      'Sensor at x=17, y=20: closest beacon is at x=21, y=22',
      'Sensor at x=16, y=7: closest beacon is at x=15, y=3',
      'Sensor at x=14, y=3: closest beacon is at x=15, y=3',
      'Sensor at x=20, y=1: closest beacon is at x=15, y=3'
    ]

    tunnels = InputParser.parse(test_input)
    area = tunnels.get_beaconless_points(10)
    expect(area).to eql(26)
  end

  it 'finds distress beacon' do
    test_input = [
      'Sensor at x=2, y=18: closest beacon is at x=-2, y=15',
      'Sensor at x=9, y=16: closest beacon is at x=10, y=16',
      'Sensor at x=13, y=2: closest beacon is at x=15, y=3',
      'Sensor at x=12, y=14: closest beacon is at x=10, y=16',
      'Sensor at x=10, y=20: closest beacon is at x=10, y=16',
      'Sensor at x=14, y=17: closest beacon is at x=10, y=16',
      'Sensor at x=8, y=7: closest beacon is at x=2, y=10',
      'Sensor at x=2, y=0: closest beacon is at x=2, y=10',
      'Sensor at x=0, y=11: closest beacon is at x=2, y=10',
      'Sensor at x=20, y=14: closest beacon is at x=25, y=17',
      'Sensor at x=17, y=20: closest beacon is at x=21, y=22',
      'Sensor at x=16, y=7: closest beacon is at x=15, y=3',
      'Sensor at x=14, y=3: closest beacon is at x=15, y=3',
      'Sensor at x=20, y=1: closest beacon is at x=15, y=3'
    ]

    tunnels = InputParser.parse(test_input)
    beacon = tunnels.find_distress_beacon(20)
    #expect(beacon.x*4000000 + beacon.y).to eql(56000011)
  end

  it 'detects overlapping ranges' do
    expect(Tunnels.ranges_overlap?((0..10), (5..20))).to eql(true)
    expect(Tunnels.ranges_overlap?((0..10), (10..20))).to eql(true)
    expect(Tunnels.ranges_overlap?((0..10), (11..20))).to eql(true)
    expect(Tunnels.ranges_overlap?((0..10), (12..20))).to eql(false)

    expect(Tunnels.ranges_overlap?((5..20), (0..10))).to eql(true)
    expect(Tunnels.ranges_overlap?((10..20), (0..10))).to eql(true)
    expect(Tunnels.ranges_overlap?((11..20), (0..10))).to eql(true)
    expect(Tunnels.ranges_overlap?((12..20), (0..10))).to eql(false)

    expect(Tunnels.ranges_overlap?((0..0), (0..10))).to eql(true)

    expect(Tunnels.ranges_overlap?((15..20), (15..17))).to eql(true)
  end

  it 'combines 2 ranges' do
    expect(Tunnels.combine_ranges((0..10), (5..20))).to eql((0..20))
    expect(Tunnels.combine_ranges((0..10), (10..20))).to eql((0..20))
    expect(Tunnels.combine_ranges((0..10), (11..20))).to eql((0..20))
    expect(Tunnels.combine_ranges((0..10), (12..20))).to eql((0..20))

    expect(Tunnels.combine_ranges((5..20), (0..10))).to eql((0..20))
    expect(Tunnels.combine_ranges((10..20), (0..10))).to eql((0..20))
    expect(Tunnels.combine_ranges((11..20), (0..10))).to eql((0..20))
    expect(Tunnels.combine_ranges((12..20), (0..10))).to eql((0..20))

    expect(Tunnels.combine_ranges((0..0), (0..10))).to eql((0..10))
  end

  it 'combines range sets' do
    r1 = (0..10)
    r2 = (12..20)
    r3 = (11..20)
    r4 = (15..40)

    expect(Tunnels.combine_range_set([r1, r3]).length).to eql(1)
    expect(Tunnels.combine_range_set([r1, r2, r3]).length).to eql(1)
    expect(Tunnels.combine_range_set([r1, r2]).length).to eql(2)
    expect(Tunnels.combine_range_set([r1, r2, r3, r4]).length).to eql(1)

    expect(Tunnels.combine_range_set([12..14, 6..10, 0..12, 2..2, 14..20]).length).to eql(1)
    expect(Tunnels.combine_range_set([0..16, 0..4, 0..0, 18..20, 12..20, 20..20]).length).to eql(1)
    expect(Tunnels.combine_range_set([2..2, 11..13, 3..13, 0..3, 0..0, 15..20, 15..17]).length).to eql(2) #[(0..13, 15..20)]
  end

  it 'combines range sets performantly' do
    time = Benchmark.measure {
      (0..100).each do |x|
        Tunnels.combine_range_set([2982546..3028626, 216236..2008622, 3058329..3677909, 1719768..2982546, 3107766..3544626, 3544626..4000000, 257245..2028473, 2486548..3618350, 3871282..4000000, 0..1802030])
      end
     }
     puts "TIME #{time.real}"
  end
end
