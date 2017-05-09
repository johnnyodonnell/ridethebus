Deck = require("deck")

-- Create a new deck of cards
local deck = Deck:new()

-- Create Bus
Bus = {bus_size = 7}

Bus.new = function(self, bus_size)
    -- Create instance of class
    o = {matrix = {}, bus_size=bus_size}
    self.__index = self
    setmetatable(o, self)

    -- Initialize bus
    o:init()

    -- Return object
    return o
end

Bus.init = function(self)
    deck:init()
    local bus_midpoint = (self.bus_size + 1) / 2
    for i = 1, self.bus_size do
        self.matrix[i] = {}
        for j = 1,(bus_midpoint - math.abs(i - bus_midpoint)) do
            self.matrix[i][j] = deck:pop()
        end
    end
end

-- Print Bus
Bus.__tostring = function(self)
    string_builder = {}
    string_builder[#string_builder + 1] = string.format("-- Bus size: %d\n", #self.matrix)
    for i = 1,#self.matrix do
        string_builder[#string_builder + 1] = string.format("%d: ", i)
        for j = 1,#self.matrix[i] do
            string_builder[#string_builder + 1] = self.matrix[i][j].rank
            string_builder[#string_builder + 1] = " "
        end
        string_builder[#string_builder + 1] = "\n"
    end
    string_builder[#string_builder + 1] = "\n"
    return table.concat(string_builder)
end

-- attemptTrip implementation
Bus.attemptTrip = function(self, i, strategy, debug)
    -- Check if trip is complete
    if i > self.bus_size then
        return true
    end
   
    -- Run strategy and choose card 
    local j = strategy.run(#self.matrix[i])
    local card = self.matrix[i][j]

    -- Print selected card if debug is turned on
    if (debug) then
        io.write(string.format("i: %d, j: %d, card.rank: %d\n", i, j, card.rank))
    end

    -- Check current card and continue trip attempt 
    if card.rank < 10 and self:attemptTrip(i + 1, strategy, debug) then
        return true
    else
        if not deck:isEmpty() then
            self.matrix[i][j] = deck:pop()
        else
            self.matrix[i][j] = nil
        end
        return false
    end 
end

-- Ride bus implementation
Bus.ride = function(self, strategy, debug)
    bus:init()
    local shots = 0
    local tripComplete
    while not (tripComplete or deck:isEmpty()) do
        tripComplete = self:attemptTrip(1, strategy, debug)
        if not tripComplete then
            shots = shots + 1
        end
    end
    return shots, deck:size()
end

return Bus

