export day6

function day6(path::String)
    times, distances = open(path, "r") do f 
        times = filter(!=("Time:"), split(readline(f)))
        distances = filter(!=("Distance:"), split(readline(f)))
        parse.(Int, times), parse.(Int, distances)
    end
    # solve quadratic inequality
    # k * (time - k) > distance
    # where k is the number of seconds we press the button
    #
    # k \in (a, b) <= k \in (ceil(a), floor(b))

    min_times = map(zip(times, distances)) do (t, d)
        result = ( t - sqrt(t^2 - 4*d) )/ 2
        if isinteger(result)
            result += 1
        end
        return ceil(Int, result)
    end 
    max_times = map(zip(times, distances)) do (t, d)
        result = ( t + sqrt(t^2 - 4*d) )/ 2
        if isinteger(result)
            result -= 1
        end
        return floor(Int, result)
    end
    ways = max_times .- min_times .+ 1
    solution = prod(ways)
    println("Solution of Day 6 - part 1: $solution")

    # part 2
    time = parse(Int, join(times))
    distance = parse(Int, join(distances))
    # compute min_time
    min_time = ( time - sqrt(time^2 - 4*distance) )/ 2
    if isinteger(min_time)
        min_time += 1
    end
    min_time = ceil(Int, min_time)
    # compute max_time
    max_time = ( time + sqrt(time^2 - 4*distance) )/ 2
    if isinteger(max_time)
        max_time -= 1
    end
    max_time = floor(Int, max_time)
    solution = max_time - min_time + 1
    println("Solution of Day 6 - part 2: $solution")
end
