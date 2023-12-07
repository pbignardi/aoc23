export day2

function day2(path::String)
    # read file and import puzzle input
    games = open(path, "r") do f
        lines = strip.(readlines(f))
        pairs = map(lines) do line
            game_number_match = match(r"Game (\d+):", line)
            number = parse(Int, first(game_number_match.captures))
            separator = findfirst(':', line)
            draws = split(strip(line[separator+1:end]), ";")
            draws = map(draws) do d
                red_match = match(r"(\d+) red", d)
                green_match = match(r"(\d+) green", d)
                blue_match = match(r"(\d+) blue", d)
                if isnothing(red_match)
                    red = 0
                else
                    red = parse(Int, first(red_match))
                end
                if isnothing(blue_match)
                    blue = 0
                else
                    blue = parse(Int, first(blue_match))
                end
                if isnothing(green_match)
                    green = 0
                else
                    green = parse(Int, first(green_match))
                end
                return (red, green, blue)
            end
            return number => draws
        end
        Dict(pairs)
    end

    given_cubes = (12, 13, 14)

    invaliddraw(draw; given=given_cubes) = begin
        any(d > r for (d, r) in zip(draw, given))
    end
    impossible_games = []
    for (gameid, draws) in games
        for draw in draws
            if invaliddraw(draw)
                push!(impossible_games, gameid)
                break
            end
        end
    end
    possible_games = setdiff(keys(games), impossible_games)
    solution = sum(possible_games)
    println("Solution day 2 - part 1: $solution")

    # part 2
    powers = map(values(games)) do draws
        gamematrix = transpose(hcat([collect(d) for d in draws]...))
        values, _ = findmax(gamematrix, dims=1)
        prod(values)
    end
    solution = sum(powers)
    println("Solution day 2 - part 2: $solution")
end
