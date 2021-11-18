function MakeBagsList(lines)
    contain_regex = r"(.+) contain (.+)";
    findbags = match.(contain_regex,lines);

    ParentBagArray = [];
    ChildrenBagDict = [];
    temp_BagDict = Dict("Placeholder" => 10);
    for i in 1:length(findbags)
        comma_regex = r"(.+), (.+)";
        ParentBagArray = [ParentBagArray;findbags[i].captures[1]]
        findbags[i].captures[1] = findbags[i].captures[2]
        line_end = findbags[i];
        while line_end !== nothing
            first_part = line_end.captures[1];
            line_end = match.(comma_regex,line_end.captures[1]);
            if (line_end !== nothing)
                bag_details = line_end.captures[2];
            else
                bag_details = first_part;
            end
            temp_BagDict = merge(temp_BagDict , Dict(bag_details => 1))
        end
        ChildrenBagDict = [ChildrenBagDict;temp_BagDict];
        temp_BagDict = Dict("Placeholder" => 10);
    end
    ChildrenBagDict = delete!.(ChildrenBagDict,"Placeholder");
    return ParentBagArray, ChildrenBagDict;
end

file = open("PuzzleInput.txt");
lines = readlines(file);

ParentBagArray, ChildrenBagDict = MakeBagsList(lines);
