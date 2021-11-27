using DelimitedFiles

function ApplyBitMask(binary_value,bitmask)
    for n in 1:length(bitmask)
        if (bitmask[n] != 'X')
            binary_value[n] = parse(Int64,bitmask[n]);
        end
    end
    return join(binary_value);
end

function ExecuteProgram(ProgramInstructions)
    address_regex = r"\[(.+)\]";
    address_values_dict = Dict();
    current_mask = [];
    for n in 1:size(ProgramInstructions,1)
        if ProgramInstructions[n,1] == "mask"
            current_mask = ProgramInstructions[n,3];
            println("Mask Found")
        else
            address = match.(address_regex,ProgramInstructions[n])[1];
            integer_value = ProgramInstructions[n,3];
            println(integer_value)
            binary_value = digits(integer_value,base=2,pad=36)|>reverse;
            masked_binary_value = ApplyBitMask(binary_value,current_mask);
            masked_integer_value = parse(Int64,masked_binary_value,base=2);
            address_values_dict[address] = masked_integer_value;
        end
    end
    return address_values_dict;
end

ProgramInstructions = readdlm("input.txt");
AddressValuesDict = ExecuteProgram(ProgramInstructions);