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

return deck

