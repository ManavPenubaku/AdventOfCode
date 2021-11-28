function FindNthNumber(SpokenNumbers,N)
counter = length(SpokenNumbers);
prev_spoken_number = 0;
sol1 = 0;
while counter < N-1
    counter +=1;
    if haskey(SpokenNumbers,prev_spoken_number)
        temp_number = SpokenNumbers[prev_spoken_number];
        SpokenNumbers[prev_spoken_number] = counter;
        prev_spoken_number = counter - temp_number;
    else
        SpokenNumbers[prev_spoken_number]=counter;
        prev_spoken_number = 0;
    end
    if (counter == 2019)
        sol1 = prev_spoken_number;
    end
end
return sol1,prev_spoken_number;
end

SpokenNumbers = Dict(9=>1,3=>2,1=>3,0=>4,8=>5,4=>6);

sol1,sol2 = FindNthNumber(SpokenNumbers,30000000);
println("Solution for Part 1 is : ",sol1)
println("Solution for Part 2 is : ",sol2)
