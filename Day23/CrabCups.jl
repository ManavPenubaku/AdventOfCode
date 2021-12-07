cups = [6,5,3,4,2,7,9,1,8]
neighbor_cups = circshift(deepcopy(cups),-1)
cup_dictionary = Dict(cups[i] => neighbor_cups[i] for i in 1:size(cups,1))

function FindDestinationCup(cup_label,picked_cups,cup_count)
    cup_label = cup_label == 0 ? cup_count : cup_label
    while sum(cup_label .== picked_cups) == 1 
        cup_label = mod(cup_label-=1,cup_count)
        cup_label = cup_label == 0 ? cup_count : cup_label
    end
    return cup_label
end

function PlayCrabCups(cups_dict,moves,cup_count)
    move_number = 0
    current_cup = 6
    picked_cups = [];
    while move_number < moves
        pickup_key = deepcopy(current_cup)
        for n in 1:3
            append!(picked_cups,cups_dict[pickup_key])
            pickup_key = cups_dict[pickup_key] 
        end
        destination_cup = FindDestinationCup(current_cup-1,picked_cups,cup_count)
        cups_dict[current_cup] = cups_dict[picked_cups[3]]
        cups_dict[picked_cups[3]] = cups_dict[destination_cup]
        cups_dict[destination_cup] = picked_cups[1]
        picked_cups = []
        current_cup = cups_dict[current_cup]
        move_number+=1
    end
    return cups_dict
end

function GetSequencePart1(input)
    output = ""
    start_cup = 1
    while input[start_cup] != 1
        output = output * string(input[start_cup])
        start_cup = input[start_cup]
    end
    return output
end

cup_dict_part_1 = PlayCrabCups(cup_dictionary,100,9)
sol1 = GetSequencePart1(cup_dict_part_1)
println("Solution to Part 1 is : ",sol1)

append!(cups,collect(10:1:1000000))
neighbor_cups = circshift(deepcopy(cups),-1)
cup_dictionary = Dict(cups[i] => neighbor_cups[i] for i in 1:size(cups,1))
cup_dict_part_2 = PlayCrabCups(cup_dictionary,10000000,1000000)
sol2 = cup_dict_part_2[1] * cup_dict_part_2[cup_dict_part_2[1]]
println("Solution to Part 1 is : ",sol2)