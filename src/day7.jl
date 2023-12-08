export day7

function day7(path::String)
    input = open(path, "r") do f
        readlines(f)
    end
    part1cards = "AKQJT98765432"

    hands = map(input) do s
        hand, bid = split(s)
        bid = parse(Int, bid)
        String(hand) => bid
    end |> Dict
    
    occurrencies(hand) = begin
        cards = unique(hand)
        freq = map(cards) do c
            length(findall(==(c), hand))
        end
        return Dict([ c => f for (c, f) in zip(cards, freq)])
    end


    handtype(hand) = begin
        occ = occurrencies(hand)
        if any(o == 5 for o in values(occ))
            return 7
        elseif any(values(occ) .== 4)
            return 6
        elseif any(values(occ) .== 3) && any(values(occ) .== 2)
            return 5
        elseif any(values(occ) .== 3)
            return 4
        elseif any(values(occ) .== 2)
            if length(findall(values(occ) .== 2)) == 2
                return 3
            else 
                return 2
            end
        else
            return 1
        end
    end

    ltcompare(hand1, hand2) = begin
        ht1 = handtype(hand1)
        ht2 = handtype(hand2)
        if ht1 == ht2
            for (c1, c2) in zip(hand1, hand2)
                c1val = findfirst(c1, part1cards)
                c2val = findfirst(c2, part1cards)
                if c1val == c2val
                    continue
                end
                return c1val > c2val
            end
        end
        return ht1 < ht2
    end
    
    sortedcards = sort(collect(keys(hands)); lt=ltcompare)
    sortedbids = map(sortedcards) do c
        hands[c]
    end
    total = sum(map(prod, enumerate(sortedbids)))
    println("Solution day 7 - part 1: $total")

    # part 2
    part2cards = "AKQT98765432J"

    set_joker(hand) = begin
        if occursin('J', hand)
            # each time assign all Jokers to the most common other card
            occ = occurrencies(filter(!=('J'), hand))
            println("current occ is $occ")
            value, index = findmax(last, occ) 
            return String(replace(hand, 'J' => index))
        else 
            return hand
        end
    end

    p2ltcompare(hand1, hand2) = begin
        ht1 = handtype(set_joker(hand1))
        ht2 = handtype(set_joker(hand2))
        if ht1 == ht2
            for (c1, c2) in zip(hand1, hand2)
                c1val = findfirst(c1, part2cards)
                c2val = findfirst(c2, part2cards)
                if c1val == c2val
                    continue
                end
                return c1val > c2val
            end
        end
        return ht1 < ht2
    end
    sortedcards = sort(collect(keys(hands)); lt=p2ltcompare)
    sortedbids = map(sortedcards) do c
        hands[c]
    end
    total = sum(map(prod, enumerate(sortedbids)))
    println("Solution day 7 - part 2: $total")
end

