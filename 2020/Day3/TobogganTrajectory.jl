using DelimitedFiles

function ConvertToBitPattern(UnitPattern)
    xdims = length(UnitPattern);
    ydims = length(UnitPattern[1]);
    BitPattern = zeros(Int8,xdims,ydims);

    for i in 1:length(UnitPattern)
        for j in 1:length(UnitPattern[1])
            if (UnitPattern[i][j] == '#')
                BitPattern[i,j] = 1;
            else
                BitPattern[i,j] = 0;
            end
        end
    end
    return BitPattern;
end

function CountTrees(UnitPattern,dx,dy)
    PatternHeight = length(UnitPattern);
    PatternWidth = length(UnitPattern[1]);
    BitPattern = ConvertToBitPattern(UnitPattern);
    repetitions = ceil(Int, (PatternHeight*dx)/(dy*PatternWidth));
    RepeatedPattern = repeat(BitPattern,1,repetitions);
    
    x_index = 1;
    y_index =1;
    tree_count = 0;
    while(x_index < PatternHeight)
        y_index = y_index + dx;
        x_index = x_index + dy;
        if (RepeatedPattern[x_index,y_index] == 1)
            tree_count = tree_count + 1;
        end
    end
    return tree_count;
end

GeologyPattern = readdlm("PuzzleInput.txt");

treecount1 =  CountTrees(GeologyPattern,3,1);
print("Answer to Part 1 : ", treecount1,"\n");

treecount2 = CountTrees(GeologyPattern,1,1);
treecount3 = CountTrees(GeologyPattern,5,1);
treecount4 = CountTrees(GeologyPattern,7,1);
treecount5 = CountTrees(GeologyPattern,1,2);

print("Answer to Part 2 : ", treecount1*treecount2*treecount3*treecount4*treecount5)