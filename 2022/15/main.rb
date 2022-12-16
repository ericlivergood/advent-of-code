require './thing'

lines = []
File.foreach("./sensorinput") { |line| lines.push(line) }

tunnels = InputParser.parse(lines)
beacon = tunnels.find_distress_beacon(4000000)
#puts beacon.x
#puts beacon.y
#expect(area.length).to eql(26)
