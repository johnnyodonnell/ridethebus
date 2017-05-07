print("Ride The Bus Simulation")

-- Set seed to now
math.randomseed(os.time())

-- Fisher-Yates shuffle algorithm
shuffle = function(table_input)
    for i = #table_input, 1, -1 do
        local j = math.random(i);
        table_input[i], table_input[j] = table_input[j], table_input[i]
    end
end

-- Create Deck
deck = {}
deck.stack = {}
for suit_i, suit in pairs({"Hearts", "Diamonds", "Clubs", "Spades"}) do
    for rank = 2,14 do
        stack_i = (((suit_i - 1) * 13) + (rank - 1));
        deck.stack[stack_i] = {rank=rank, suit=suit}
    end
end

-- Deck init function
deck.init = function()
    shuffle(deck.stack)
    deck.stack_index = 52
end

-- Stack pop operation
deck.pop = function()
    local card = deck.stack[deck.stack_index]
    deck.stack_index = deck.stack_index - 1
    return card
end

-- Stack isEmpty operation
deck.isEmpty = function()
    return deck.stack_index <= 0
end

-- Stack size operation
deck.size = function()
    return deck.stack_index
end

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

-- Johnny's strategy
johnny_strategy = {name="Johnny's strategy"}
johnny_strategy.run = function(n)
    return 1
end

-- Random strategy
random_strategy = {name="Random strategy"}
random_strategy.run = function(n)
    return math.random(n)
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

-- Sample busses
--[[
for bus_size = 4,8 do
    bus.init(bus_size)
    bus.print()
end
--]]

-- Test strategies and bus size
for bus_size = 4,8 do
    io.write(string.format("-- Bus size: %d\n", bus_size))
    for _, strategy in pairs({johnny_strategy, random_strategy}) do
        shots_sum = 0;
        deck_size_sum = 0;
        iterations = 1000
        for i = 1,iterations do
            shots, deck_size = bus.ride(strategy, bus_size)
            shots_sum = shots_sum + shots
            deck_size_sum = deck_size_sum + deck_size
        end
        io.write(string.format("\t%s, average shots: %f, average deck size: %f\n",
                    strategy.name, shots_sum / iterations, deck_size_sum / iterations))
    end
    io.write("\n")
end

