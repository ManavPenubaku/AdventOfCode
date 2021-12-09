file = open("input.txt")
lines = readlines(file)

function MoveInGrid(loc,dir,prev_dir)
    if (dir == 's')
        loc[2] -=1
    elseif (dir == 'n')
        loc[2] +=1
    elseif (dir == 'e')
        if (prev_dir == 's' || prev_dir == 'n')
            loc[1] +=1
        else
            loc[1] +=2
        end
    else
        if (prev_dir == 's' || prev_dir == 'n')
            loc[1] -=1
        else
            loc[1] -=2
        end
    end
    return loc
end

function FlipTiles(input)
    TileDict = Dict{Vector,Bool}()
    for i in 1:length(input)
        Loc = [0,0]
        Loc = MoveInGrid(Loc,input[i][1],'0')
        for j in 2:length(input[i])
            Loc = MoveInGrid(Loc,input[i][j],input[i][j-1])
        end
        if (haskey(TileDict,Loc))
            TileDict[Loc] = !(TileDict[Loc])
        else
            TileDict[Loc] = 1
        end
    end
    return sum(collect(values(TileDict))),TileDict
end

black_tiles,TileDict = FlipTiles(lines)
println("Solution to Part 1 is : ",black_tiles)
