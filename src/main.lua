Bus = require("bus")
strategies = require("strategies")

print("Ride The Bus Simulation")

-- Sample busses
--[[
for bus_size = 4,8 do
    bus = Bus:new(bus_size)
    io.write(tostring(bus))
end
--]]

-- Test strategies and bus size
for bus_size = 4,8 do
    bus = Bus:new(bus_size)
    io.write(string.format("-- Bus size: %d\n", bus_size))
    for _, strategy in pairs(strategies) do
        shots_sum = 0;
        deck_size_sum = 0;
        iterations = 1000
        for i = 1,iterations do
            shots, deck_size = bus:ride(strategy)
            shots_sum = shots_sum + shots
            deck_size_sum = deck_size_sum + deck_size
        end
        io.write(string.format("\t%s, average shots: %f, average deck size: %f\n",
                    strategy.name, shots_sum / iterations, deck_size_sum / iterations))
    end
    io.write("\n")
end

