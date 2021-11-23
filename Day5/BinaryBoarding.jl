using DelimitedFiles

function ConvertToBitPattern(UnitPattern)
    xdims = length(UnitPattern);
    ydims = length(UnitPattern[1]);
    BitPattern = zeros(Int8,xdims,ydims);

    for i in 1:length(UnitPattern)
        for j in 1:length(UnitPattern[1])
            if (UnitPattern[i][j] == 'B'|| UnitPattern[i][j] == 'R')
                BitPattern[i,j] = 1;
            else
                BitPattern[i,j] = 0;
            end
        end
    end
    return BitPattern;
end

function CalculateSeatIDs(UnitPattern)
    BitPattern = ConvertToBitPattern(UnitPattern);
    BitRowNumbers = BitPattern[:,1:7];
    BitColNumbers = BitPattern[:,8:10];

    DecRowNumbers = BitRowNumbers[:,1]*2^6 + BitRowNumbers[:,2]*2^5 + BitRowNumbers[:,3]*2^4 + BitRowNumbers[:,4]*2^3 + BitRowNumbers[:,5]*2^2 + BitRowNumbers[:,6]*2^1 + BitRowNumbers[:,7]*2^0;
    DecColNumbers = BitColNumbers[:,1]*2^2 + BitColNumbers[:,2]*2^1 + BitColNumbers[:,3]*2^0;

    SeatIDs = DecRowNumbers * 8 + DecColNumbers;
    return SeatIDs;

end

BoardingPassNumbers = readdlm("PuzzleInput.txt");

SeatIDs = CalculateSeatIDs(BoardingPassNumbers);

HighestSeatID = findmax(SeatIDs)[1];
print("The higest seat ID is : ", HighestSeatID , "\n");

SortedSeatIDs = sort(SeatIDs);
NeighborSeatID = SortedSeatIDs[findall(x -> x == 2, diff(SortedSeatIDs))[1]];
MySeatID = NeighborSeatID + 1;
print("My seat number is : " , MySeatID);