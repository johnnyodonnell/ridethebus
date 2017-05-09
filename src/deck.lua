-- Set seed to now
math.randomseed(os.time())

-- Fisher-Yates shuffle algorithm
local shuffle = function(table_input)
    for i = #table_input, 1, -1 do
        local j = math.random(i);
        table_input[i], table_input[j] = table_input[j], table_input[i]
    end
end

-- Create Deck
Deck = {}

Deck.new = function(self)
    -- Create instance of Deck
    o = {stack = {}}
    self.__index = self
    setmetatable(o, self)
    
    -- Add cards to stack
    for suit_i, suit in pairs({"Hearts", "Diamonds", "Clubs", "Spades"}) do
        for rank = 2,14 do
            local stack_i = (((suit_i - 1) * 13) + (rank - 1));
            o.stack[stack_i] = {rank=rank, suit=suit}
        end
    end

    -- initialize deck
    o:init()
   
    -- Return object 
    return o 
end

-- Init stack
Deck.init = function(self)
    shuffle(self.stack)
    self.stack_index = 52
end

-- Stack pop operation
Deck.pop = function(self)
    local card = self.stack[self.stack_index]
    self.stack_index = self.stack_index - 1
    return card
end

-- Stack isEmpty operation
Deck.isEmpty = function(self)
    return self.stack_index <= 0
end

-- Stack size operation
Deck.size = function(self)
    return self.stack_index
end

return Deck

