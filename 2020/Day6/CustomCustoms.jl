using StatsBase

function GetCustomsData(TextLines)
    CustomsData = [""];
    groups_person_count = [0];
    temp_string = "";
    index = 1;
    person_count = 0;
    while index <= length(TextLines)
        temp_string = temp_string * lines[index];
        person_count = person_count + 1;
        if (index == length(TextLines) || lines[index+1] == "")
            CustomsData = [CustomsData;temp_string];
            temp_string = "";
            groups_person_count = [groups_person_count;person_count];
            person_count = 0;
            index += 2;
        else
            index+=1;
        end
    end
return CustomsData[2:end], groups_person_count[2:end]
end

function QuestionCounterPart1(CustomsData)
    # Find all unique questions answered by a group
    return sum(length.(countmap.(CustomsData)));
end

file = open("PuzzleInput.txt");
lines = readlines(file);

CustomsData,GroupPersonCount = GetCustomsData(lines);
QuestionCounter(CustomsData);

# Part 1 : Find all unique questions answered by a group
sol1 = sum(length.(countmap.(CustomsData)));
print("Answer to Part 1 : ",sol1,"\n");

#Part 2 : Find all unique questions that were answered by everyone in a group
counts = countmap.(CustomsData);
sol2 = 0;
for n in 1:length(GroupPersonCount)
    global sol2 += sum(values.(counts)[n] .== GroupPersonCount[n])
end 
print("Answer to Part 2 : ",sol2);