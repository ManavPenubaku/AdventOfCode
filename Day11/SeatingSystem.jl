using DelimitedFiles

SeatLayout = readdlm("PuzzleInput.txt");
SeatMatrix = reduce(vcat,permutedims.(collect.(SeatLayout)));

# Pad Seat Matrix with '.'
PaddingString1 = repeat('.',size(SeatMatrix)[1]);
PaddingVector1 = reduce(vcat, permutedims.(collect.(PaddingString1)));
SeatMatrix = [PaddingVector1 SeatMatrix PaddingVector1];
PaddingString2 = repeat('.',size(SeatMatrix)[2]);
PaddingVector2 = reduce(hcat, permutedims.(collect.(PaddingString2)));
SeatMatrix = [PaddingVector2;SeatMatrix;PaddingVector2];

global Rows = size(SeatMatrix,1);
global Cols = size(SeatMatrix,2);

function FillSeats(SeatMatrix,Rows,Cols)
    NewSeatMatrix = deepcopy.(SeatMatrix);
    SeatChangeCounter = 0;
    # Exclude padding while running the for loop
    for i in 2:(Rows-1)
        for j in 2:(Cols-1)
            Window = SeatMatrix[i-1 : i+1,j-1 : j+1];
            CurrentSeat = SeatMatrix[i,j];
            if sum((Window.=='.') .| (Window .== 'L')) == 9 && CurrentSeat == 'L'
                NewSeatMatrix[i,j] = '#';
                SeatChangeCounter+=1;
            end
        end
    end
    return NewSeatMatrix,SeatChangeCounter;
end

function EmptySeats(SeatMatrix,Rows,Cols)
    NewSeatMatrix = deepcopy.(SeatMatrix);
    SeatChangeCounter = 0;
    # Exclude padding while running the for loop
    for i in 2:(Rows-1)
        for j in 2:(Cols-1)
            Window = SeatMatrix[i-1 : i+1,j-1 : j+1];
            CurrentSeat = SeatMatrix[i,j];
            if sum(Window .== '#')>=5 && CurrentSeat == '#'
                NewSeatMatrix[i,j] = 'L';
                SeatChangeCounter+=1;
            end
        end
    end
    return NewSeatMatrix,SeatChangeCounter;
end

function FindStability1(SeatMatrix)
    SeatChangeCounter = 1;
    SeatMatrixPart1 = deepcopy(SeatMatrix);
    while SeatChangeCounter > 0
        SeatMatrixPart1,SeatChangeCounter = FillSeats(SeatMatrixPart1,Rows,Cols);
        SeatMatrixPart1,SeatChangeCounter = EmptySeats(SeatMatrixPart1,Rows,Cols); 
    end
    return SeatMatrixPart1;
end

function FindSeatsHorizontal(SeatMatrix, Row,Col)
    OccupiedSeatCounter = 0;
    for right in (Col+1):Cols
        if (SeatMatrix[Row,right] == '#')
            OccupiedSeatCounter+=1;
            break;
        elseif (SeatMatrix[Row,right] == 'L')
            break;
        end
    end

    for left in (Col-1):-1:1
        if (SeatMatrix[Row,left] == '#')
            OccupiedSeatCounter+=1;
            break;
        elseif (SeatMatrix[Row,left] == 'L')
            break;
        end
    end
    return OccupiedSeatCounter;
end

function FindSeatsVertical(SeatMatrix, Row,Col)
    OccupiedSeatCounter = 0;
    for down in Row+1:Rows
        if (SeatMatrix[down,Col] == '#')
            OccupiedSeatCounter+=1;
            break;
        elseif (SeatMatrix[down,Col] == 'L')
            break;
        end
    end

    for up in (Row-1):-1:1
        if (SeatMatrix[up,Col] == '#')
            OccupiedSeatCounter+=1;
            break;
        elseif (SeatMatrix[up,Col] == 'L')
            break;
        end
    end
    return OccupiedSeatCounter;
end

function FindSeatsDiagonals(SeatMatrix,Row,Col);
    down = reshape(collect(Row+1:Rows),1,Rows-Row);
    up = reverse(reshape(collect(1:Row-1),1,Row-1));
    right = reshape(collect(Col+1:Cols),1,Cols-Col);
    left = reverse(reshape(collect(1:Col-1),1,Col-1));
    OccupiedSeatCounter = 0;
    for (i,j) in zip(down,right)
        if (SeatMatrix[i,j] == '#')
            OccupiedSeatCounter+=1;
            break;
        elseif (SeatMatrix[i,j] == 'L')
            break;
        end
    end

    for (i,j) in zip(down,left)
        if (SeatMatrix[i,j] == '#')
            OccupiedSeatCounter+=1;
            break;
        elseif (SeatMatrix[i,j] == 'L')
            break;
        end
    end

    for (i,j) in zip(up,right)
        if (SeatMatrix[i,j] == '#')
            OccupiedSeatCounter+=1;
            break;
        elseif (SeatMatrix[i,j] == 'L')
            break;
        end
    end

    for (i,j) in zip(up,left)
        if (SeatMatrix[i,j] == '#')
            OccupiedSeatCounter+=1;
            break;
        elseif (SeatMatrix[i,j] == 'L')
            break;
        end
    end

    return OccupiedSeatCounter;
end

function FillSeatsVisible(SeatMatrix)
    NewSeatMatrix = deepcopy.(SeatMatrix);
    SeatChangeCounter = 0;
    OccupiedSeats = 0;
    # Exclude padding while running the for loop
    for i in 2:(Rows-1)
        for j in 2:(Cols-1)
            OccupiedSeats = FindSeatsHorizontal(SeatMatrix,i,j)+FindSeatsVertical(SeatMatrix,i,j)+FindSeatsDiagonals(SeatMatrix,i,j);
            CurrentSeat = SeatMatrix[i,j];
            if OccupiedSeats == 0 && CurrentSeat == 'L'
                NewSeatMatrix[i,j] = '#';
                SeatChangeCounter+=1;
            end
        end
    end
    return NewSeatMatrix,SeatChangeCounter;
end

function EmptySeatsVisible(SeatMatrix)
    NewSeatMatrix = deepcopy.(SeatMatrix);
    SeatChangeCounter = 0;
    OccupiedSeats = 0;
    # Exclude padding while running the for loop
    for i in 2:(Rows-1)
        for j in 2:(Cols-1)
            OccupiedSeats = FindSeatsHorizontal(SeatMatrix,i,j)+FindSeatsVertical(SeatMatrix,i,j)+FindSeatsDiagonals(SeatMatrix,i,j);
            CurrentSeat = SeatMatrix[i,j];
            if OccupiedSeats >= 5 && CurrentSeat == '#'
                NewSeatMatrix[i,j] = 'L';
                SeatChangeCounter+=1;
            end
        end
    end
    return NewSeatMatrix,SeatChangeCounter;
end


function FindStability2(SeatMatrix)
    SeatChangeCounter = 1;
    while SeatChangeCounter > 0
        SeatMatrix,SeatChangeCounter = FillSeatsVisible(SeatMatrix);
        SeatMatrix,SeatChangeCounter = EmptySeatsVisible(SeatMatrix);
    end
    return SeatMatrix;
end

StableSeatMatrix = FindStability1(SeatMatrix);
println("Solution to Part 1 is : ",sum(StableSeatMatrix .== '#'));

StableSeatMatrix2 = FindStability2(SeatMatrix);
println("Solution to Part 2 is : ",sum(StableSeatMatrix2 .== '#'));