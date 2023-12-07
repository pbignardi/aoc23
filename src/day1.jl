export day1

function day1(path::String)
    # read file and import puzzle input
    input = open(path, "r") do f
        strip.(readlines(f))
    end
    numbers = map(input) do string
        leftdigitid = findlast(isdigit, string)
        rightdigitid = findfirst(isdigit, string)
        tailstring = last(string, length(string) - leftdigitid)
        headstring = first(string, rightdigitid - 1)
        r = parse(Int, string[rightdigitid])
        l = parse(Int, string[leftdigitid])
        return 10*l + r
    end
    solution = sum(numbers)
    println("Day1 solution - part 1: $solution")
    
    # part 2
    nums = ["one", "two", "three", "four", "five", "six", "seven", 
            "eight", "nine", "zero" ]
    rightmostword(string) = begin
        sublength = 0
        substr = last(string, sublength)
        while sublength <= length(string)
            occurrence = [occursin(num, substr) for num in nums]
            if !any(occurrence)
                sublength += 1
                substr = last(string, sublength)
            else
                return findfirst(occurrence) % 10
            end
        end
    end
    leftmostword(string) = begin
        sublength = 0
        substr = first(string, sublength)
        while sublength <= length(string)
            occurrence = [occursin(num, substr) for num in nums]
            if !any(occurrence)
                sublength += 1
                substr = first(string, sublength)
            else
                return findfirst(occurrence) % 10
            end
        end
    end
    numbers = map(input) do string
        if any(isdigit, string)
            leftdigitid = findlast(isdigit, string)
            rightdigitid = findfirst(isdigit, string)
            tailstring = last(string, length(string) - leftdigitid)
            headstring = first(string, rightdigitid - 1)
        else
            tailstring = string
            headstring = string
        end
        r = rightmostword(tailstring)
        l = leftmostword(headstring)
        if isnothing(r)
            r = parse(Int, string[leftdigitid])
        end
        if isnothing(l)
            l = parse(Int, string[rightdigitid])
        end
        return 10*l + r
    end
    solution = sum(numbers)
    println("Day1 solution - part 2: $solution")
end
