using DelimitedFiles

InstructionList = readdlm("PuzzleInput.txt")

function CalculateAccumulator(InstructionList)
    instruction_execution_counter = zeros(Int8,(size(InstructionList)[1],1));
    accumulator = 0;
    index = 1;
    infinite_loop_flag = 0;
    while true
        instruction_execution_counter[index] += 1;
        if (instruction_execution_counter[index] == 2)
            infinite_loop_flag = 1;
            break;
        elseif (index == size(InstructionList)[1])
            infinite_loop_flag = 0;
            break;
        end

        if (InstructionList[index,1] == "jmp")
            index += InstructionList[index,2];
        elseif (InstructionList[index,1] == "acc")
            accumulator += InstructionList[index,2];
            index +=1;
        elseif (InstructionList[index,1] == "nop")
            index +=1;
        end
    end
    return infinite_loop_flag, accumulator;
end

function FixInstructionList(InstructionList)
    infinite_loop_flag = 1;
    accumulator_value = 0;
    valid_indices = findall(x->x==1, (InstructionList[:,1] .== "jmp") .| (InstructionList[:,1] .== "nop"))
    index_counter = 1;
    TempInstructionList = [];
    while (infinite_loop_flag == 1)
        TempInstructionList = deepcopy(InstructionList);
        current_index = valid_indices[index_counter];
        if (InstructionList[current_index,1] == "nop" && InstructionList[current_index,2] != 0)
            TempInstructionList[current_index,1] = "jmp";
        elseif (InstructionList[current_index,1] == "jmp")
            TempInstructionList[current_index,1] = "nop";
        end
        infinite_loop_flag,accumulator_value = CalculateAccumulator(TempInstructionList);
        index_counter += 1;
    end
    return infinite_loop_flag,accumulator_value;
end

println("Answer to Part 1 : ",CalculateAccumulator(InstructionList)[2])

println("Answer to Part 2 : ",FixInstructionList(InstructionList)[2])