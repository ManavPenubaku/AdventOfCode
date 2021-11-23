using DelimitedFiles

AdapterList = readdlm("PuzzleInput.txt",Int64);
AdapterList = [0; AdapterList;findmax(AdapterList)[1]+3]; # Append with device joltage

joltage_difference = diff(sort(AdapterList,dims =1),dims = 1);
sol1 = sum(joltage_difference .== 3) * sum(joltage_difference .== 1); 
println("Solution to Part 1 is : ",sol1)

contiguous = [];
series_count = 0;
for n in 1:length(joltage_difference)
    if (joltage_difference[n] == 3)
        global contiguous = [contiguous;series_count]
        global series_count = 0;
    else
        global series_count += 1;
    end
end
println(contiguous)
contiguous[contiguous.==4] .= 7;
contiguous[contiguous.==3] .= 4;
contiguous[contiguous.==2] .= 2;
contiguous[contiguous.==1] .= 1;
contiguous[contiguous.==0] .= 1;
sol2 = prod(contiguous)

println("Solution to Part 2 is : ",sol2)

