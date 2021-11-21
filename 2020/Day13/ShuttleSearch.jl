using DelimitedFiles

BusSchedule = readdlm("PuzzleInput.txt");
TimeStamp = BusSchedule[1];

BusDepartures = split(BusSchedule[2],',');

BusNumbers = parse.(Int,unique(BusDepartures[BusDepartures .!= "x"]));
NextDeparture = BusNumbers - mod.(TimeStamp,BusNumbers);
FirstBus = BusNumbers[findall(x->x==minimum(NextDeparture),NextDeparture)];

println("Solution to Part 1 is : ",FirstBus*minimum(NextDeparture));

function FindEarliestTimeStamp(BusDepartures,BusNumbers)
    t = 0;
    TargetTime = zeros(Int,size(BusNumbers,1),1)
    BusIndex = 1;
    for n in 1:length(BusDepartures)
        if (BusDepartures[n] != "x")
            TargetTime[BusIndex] = t;
            BusIndex+=1;
        end
        t+=1;
    end

    # Uses the Chinese Remainder Theorem 
    TargetTime = mod.(-TargetTime,BusNumbers);
    TimeStep = 1;
    Iterator = 0;
    BusNumbers = [BusNumbers TargetTime];
    SortBuses = BusNumbers[sortperm(BusNumbers[:,1], rev=true),:];
    BusNumbers = SortBuses[:,1];
    ModsTime = SortBuses[:,2];
    for n in 1:size(BusNumbers,1)
        while mod(Iterator,BusNumbers[n]) != ModsTime[n]
            Iterator+=TimeStep;
        end
        TimeStep *= BusNumbers[n];
        println(Iterator)
    end
    return Iterator;
end

EarliestTimeStamp = FindEarliestTimeStamp(BusDepartures,BusNumbers)
