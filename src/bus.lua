deck = require("deck")

-- Create Bus
bus = {}
bus.matrix = {}
bus.init = function(matrix_length)
    deck.init()
    bus.matrix_length = matrix_length
    local matrix_midpoint = (matrix_length + 1) / 2
    for i = 1, matrix_length do
        bus.matrix[i] = {}
        for j = 1,(matrix_midpoint - math.abs(i-matrix_midpoint)) do
            bus.matrix[i][j] = deck.pop()
        end
    end
end

-- Print Bus
bus.print = function()
    io.write(string.format("-- Bus size: %d\n", #bus.matrix))
    for i = 1,#bus.matrix do
        io.write(string.format("%d: ", i))
        for j = 1,#bus.matrix[i] do
            io.write(bus.matrix[i][j].rank, " ")
        end
        io.write("\n")
    end
    io.write("\n")
end

-- attemptTrip implementation
bus.attemptTrip = function(i, strategy, bus_size, debug)
    -- Check if trip is complete
    if i > bus_size then
        return true
    end
   
    -- Run strategy and choose card 
    local j = strategy.run(#bus.matrix[i])
    local card = bus.matrix[i][j]

    -- Print selected card if debug is turned on
    if (debug) then
        io.write(string.format("i: %d, j: %d, card.rank: %d\n", i, j, card.rank))
    end

    -- Check current card and continue trip attempt 
    if card.rank < 10 and bus.attemptTrip(i + 1, strategy, bus_size, debug) then
        return true
    else
        if not deck.isEmpty() then
            bus.matrix[i][j] = deck.pop()
        else
            bus.matrix[i][j] = nil
        end
        return false
    end 
end

-- Ride bus implementation
bus.ride = function(strategy, bus_size, debug)
    bus.init(bus_size)
    local shots = 0
    local tripComplete
    while not (tripComplete or deck.isEmpty()) do
        tripComplete = bus.attemptTrip(1, strategy, bus_size, debug)
        if not tripComplete then
            shots = shots + 1
        end
    end
    return shots, deck.size()
end

return bus

