function MakeBagsList(lines)
    contain_regex = r"(.+) contain (.+)";
    findbags = match.(contain_regex,lines);

    ParentBagArray = [];
    ChildrenBagDict = [];
    temp_BagDict = Dict("Placeholder" => 10);
    for i in 1:length(findbags)
        comma_regex = r"(.+), (.+)";
        regex_bagcount = r"([0-9]) (.+) (bags||bag)(.+)"
        temp_parent_bag = match.(r"(.+) (bags||bag)",findbags[i].captures[1]);
        ParentBagArray = [ParentBagArray;temp_parent_bag.captures[1]]
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
            extract_bag_details = match.(regex_bagcount,bag_details);
            if extract_bag_details !== nothing
                bag_id = extract_bag_details.captures[2];
                bag_count = parse(Int,extract_bag_details.captures[1]);
                temp_BagDict = merge(temp_BagDict , Dict(bag_id => bag_count));
            else
                temp_BagDict = merge(temp_BagDict, Dict(bag_details => 0));
            end
        end
        ChildrenBagDict = [ChildrenBagDict;temp_BagDict];
        temp_BagDict = Dict("Placeholder" => 10);
    end
    ChildrenBagDict = delete!.(ChildrenBagDict,"Placeholder");
    return ParentBagArray, ChildrenBagDict;
end

function CountRelevantBags(ParentBagArray,ChildrenBagDict)
    ContainsShinyGold = [];
    for n in 1:length(ParentBagArray)
        if (sum(contains.(keys.(ChildrenBagDict)[n],"shiny gold")) == 1)
            ContainsShinyGold = [ContainsShinyGold; ParentBagArray[n]];
        end
    end
    
    index = 1;
    while index <= length(ContainsShinyGold)
        for n in 1:length(ParentBagArray)
            if (sum(contains.(keys.(ChildrenBagDict)[n],ContainsShinyGold[index])) == 1)
                ContainsShinyGold = [ContainsShinyGold; ParentBagArray[n]];
            end
        end
        index+=1;
        print(index,"\n")
    end
    return ContainsShinyGold;
end

file = open("PuzzleInput.txt");
lines = readlines(file);

ParentBagArray, ChildrenBagDict = MakeBagsList(lines);

CountRelevantBags(ParentBagArray,ChildrenBagDict);