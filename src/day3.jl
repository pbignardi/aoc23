export day3

function day3(path::String)
    # read file and import puzzle input
    input = open(path, "r") do f
        permutedims(hcat(collect.(readlines(f))...))
    end

    symbols = filter(input) do c
        !isdigit(c) && c != '.'
    end |> unique

    cogs = Tuple.(findall(==('*'), input))

    nrows, ncols = size(input)
    n = 0
    total = 0
    symbol_found = false
    gear_found = false
    gears = Dict([cog => [] for cog in cogs])
    curr_gear_pos = (0, 0)
    for r in 1:nrows
        for c in 1:ncols
            if isdigit(input[r, c])
                n = n * 10 + parse(Int, input[r, c])
                dirshift = [-1, 0, 1]
                shifts = collect(Iterators.product(dirshift, dirshift))
                for shift in shifts
                    subr, subc = shift
                    if subr + r in 1:nrows && subc + c in 1:ncols
                        compare_char = input[subr + r, subc + c]
                        if compare_char in symbols
                            symbol_found = true
                            if compare_char == '*'
                                curr_gear_pos = (subr + r, subc + c)
                                gear_found = true
                            end
                        end
                    end
                end
            else 
                if symbol_found
                    if gear_found
                        push!(gears[curr_gear_pos], n)
                    end
                    # tally up
                    total += n
                end
                # reset everything
                n = 0
                symbol_found = false
                gear_found = false
            end
        end
    end

    println("Solution day 3 - part 1: $total")
    # part 2

    # get whole number given a position of one of its digits
    getnumber(pos) = begin
        r, c = pos
        leftdone = false
        rightdone = false
        left = c
        right = c
        while left - 1 > 0 && isdigit(input[r, left - 1]) 
            left -= 1
        end
        while right + 1 <= ncols && isdigit(input[r, right + 1]) 
            right += 1
        end
        return parse(Int, join(input[r, left:right]))
    end
    
    # find all '*' chars
    cogs = Tuple.(findall(==('*'), input))
    
    # iterate over the '*' chars and look around them 
    total = 0
    for cog in cogs
        r, c = cog
        shifts = collect(Iterators.product([-1, 0, 1], [-1, 0, 1]))
        goodshifts = filter(shifts) do (subr, subc)
            if subr + r in 1:nrows && subc + c in 1:ncols
                return isdigit(input[subr + r, subc + c])
            end
            return false
        end
        digitpos = [cog .+ s for s in goodshifts]
        numbers = map(getnumber, digitpos)
        if length(numbers) > 2
            numbers = unique(numbers)
        end
        if length(numbers) == 2
            println("cog at $cog")
            println("gear ratio is $numbers")
            total += prod(numbers)
        end
    end

    solution = 0
    for (_, value) in gears
        if length(value) == 2
            solution += prod(value)
        end
    end
    println("Solution day 3 - part 2: $solution")
    

end
