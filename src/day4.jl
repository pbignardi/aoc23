import Memoize
export day4

function day4(path::String)
    input = open(path, "r") do f
        readlines(f)
    end
    # parse input
    cards = map(input) do line
        gameid = parse(Int, first(match(r"Card\s+(\d+):", line).captures))
        separator = findfirst(':', line)
        content = chop(line, head=separator, tail=0)
        winnums, mynums = strip.(split(content, '|'))
        winnums = parse.(Int, split(winnums))
        mynums = parse.(Int, split(mynums))
        gameid => (winnums, mynums)
    end
    cards = Dict(cards)
    
    # check how many elements of winnums are in mynums
    copies = Dict([k => 0 for k in keys(cards)])
    score = 0
    for (id, (win, nums)) in cards
        intersize = length(intersect(win, nums))
        localscore = intersize > 0 ? 2^(intersize - 1) : 0
        copies[id] = intersize
        score += localscore
    end
    
    println("Solution day 4 - part 1: $score")
    
    stack = sort(collect(keys(cards)))
    count = length(stack)
    cache = Dict([k => 0 for k in keys(copies) if copies[k] == 0])
    while !isempty(stack)
        id = pop!(stack)
        # check cache 
        if id in keys(cache)
            value = cache[id]
            count += cache[id]
            continue
        end

        # generate children
        numcopies = copies[id]
        newcards = [id + i for i in 1:numcopies]
        # if all children are known, populate the cache
        if all(card in keys(cache) for card in newcards)
            internalcount = 0 
            for card in newcards
                internalcount += 1 + cache[card]
            end
            count += internalcount
            cache[id] = internalcount
        else
            append!(stack, newcards)
        end
    end

    println("Solution day 4 - part 2: $count")
end
