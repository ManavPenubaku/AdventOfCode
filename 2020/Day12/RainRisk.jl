using DelimitedFiles

NavigationInstructions = readdlm("PuzzleInput.txt");

Instructions =  Array{Any,2}(undef,size(NavigationInstructions,1),2);
Instructions[:,1] = map(x-> x[1],NavigationInstructions);
Instructions[:,2] = map(x-> parse(Int,x[2:end]),NavigationInstructions);

function RotateVector(Vector,Angle)
    return [cosd(Angle) -sind(Angle);sind(Angle) cosd(Angle)] * Vector;
end

function MoveShip(Instructions)
    Position = [0;0];
    Direction = [1;0];
    for n in 1:size(Instructions,1)
        if (Instructions[n,1] == 'N')
            Position += [0;Instructions[n,2]];
        elseif (Instructions[n,1] == 'S')
            Position += [0;-Instructions[n,2]];
        elseif (Instructions[n,1] == 'E')
            Position += [Instructions[n,2];0];
        elseif (Instructions[n,1] == 'W')
            Position += [-Instructions[n,2];0];
        elseif (Instructions[n,1] == 'L')
            Direction = RotateVector(Direction,Instructions[n,2]);
        elseif (Instructions[n,1] == 'R')
            Direction = RotateVector(Direction,-Instructions[n,2]);
        elseif (Instructions[n,1] == 'F')
            Position += Direction.*Instructions[n,2];
        end
    end
    return Position;
end

function MoveShipByWaypoint(Instructions)
    Position = [0;0];
    Waypoint = [10;1];
    for n in 1:size(Instructions,1)
        if (Instructions[n,1] == 'N')
            Waypoint += [0;Instructions[n,2]];
        elseif (Instructions[n,1] == 'S')
            Waypoint += [0;-Instructions[n,2]];
        elseif (Instructions[n,1] == 'E')
            Waypoint += [Instructions[n,2];0];
        elseif (Instructions[n,1] == 'W')
            Waypoint += [-Instructions[n,2];0];
        elseif (Instructions[n,1] == 'L')
            Waypoint = RotateVector(Waypoint,Instructions[n,2]);
        elseif (Instructions[n,1] == 'R')
            Waypoint = RotateVector(Waypoint,-Instructions[n,2]);
        elseif (Instructions[n,1] == 'F')
            Position += Waypoint.*Instructions[n,2];
        end
    end
    return Position;
end

ManhattanDistance1 = sum(abs.(MoveShip(Instructions)));
println("Solution to Part 1 is : ",ManhattanDistance);

ManhattanDistance2 = sum(abs.(MoveShipByWaypoint(Instructions)));
println("Solution to Part 1 is : ",ManhattanDistance2);