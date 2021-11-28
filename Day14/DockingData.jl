using DelimitedFiles

function ApplyBitMask(binary_value,bitmask)
    for n in 1:length(bitmask)
        if (bitmask[n] != 'X')
            binary_value[n] = parse(Int64,bitmask[n]);
        end
    end
    return join(binary_value);
end

function ExecuteProgramPart1(ProgramInstructions)
    address_regex = r"\[(.+)\]";
    address_values_dict = Dict();
    current_mask = [];
    for n in 1:size(ProgramInstructions,1)
        if ProgramInstructions[n,1] == "mask"
            current_mask = ProgramInstructions[n,3];
        else
            address = match.(address_regex,ProgramInstructions[n])[1];
            integer_value = ProgramInstructions[n,3];
            binary_value = digits(integer_value,base=2,pad=36)|>reverse;
            masked_binary_value = ApplyBitMask(binary_value,current_mask);
            masked_integer_value = parse(Int64,masked_binary_value,base=2);
            address_values_dict[address] = masked_integer_value;
        end
    end
    return address_values_dict;
end

function ApplyBitMask2(binary_value,bitmask)
    for n in 1:length(bitmask)
        if (bitmask[n] == 'X')
            binary_value = [binary_value binary_value];
            midpoint = convert(Int,size(binary_value,2)/2);
            binary_value[n,1:midpoint] .= 0;
            binary_value[n,(midpoint+1):end] .= 1;           
        elseif (bitmask[n] == '1')
            binary_value[n,:] .= 1;
        end
    end
    return rotl90(binary_value);
end

function ExecuteProgramPart2(ProgramInstructions)
    address_regex = r"\[(.+)\]";
    address_values_dict = Dict();
    current_mask = [];
    for n in 1:size(ProgramInstructions,1)
        if ProgramInstructions[n,1] == "mask"
            current_mask = ProgramInstructions[n,3];
        else
            address = parse(Int64,match.(address_regex,ProgramInstructions[n])[1]);
            address_binary_value = digits(address,base=2,pad=36)|>reverse;
            integer_value = ProgramInstructions[n,3];
            masked_binary_values = ApplyBitMask2(address_binary_value,current_mask);
            for values in 1:size(masked_binary_values,1)
                address_temp = parse(Int,join(masked_binary_values[values,:]),base=2);
                address_values_dict[address_temp] = integer_value;
            end
        end
    end
    return address_values_dict;
end

ProgramInstructions = readdlm("input.txt");
AddressValuesDict = ExecuteProgramPart1(ProgramInstructions);
println("Solution to Part 1 is : ",sum(values(AddressValuesDict)));

AddressValuesDict2 = ExecuteProgramPart2(ProgramInstructions);
println("Solution to Part 2 is : ",sum(values(AddressValuesDict2)));