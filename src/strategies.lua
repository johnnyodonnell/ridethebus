strategies = {}

-- Johnny's strategy
local johnny_strategy = {name="Johnny's strategy"}
johnny_strategy.run = function(n)
    return 1
end
strategies[#strategies + 1] = johnny_strategy

-- Random strategy
local random_strategy = {name="Random strategy"}
random_strategy.run = function(n)
    return math.random(n)
end
strategies[#strategies + 1] = random_strategy

return strategies

