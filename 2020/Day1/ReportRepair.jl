using DelimitedFiles

function ReportRepair(number_list)
    # Find product of 2 numbers in the list that add up to 2020
    modified_list = [number_list; 2020 .- number_list]
    sorted_number_list = sort(modified_list, dims = 1)
    number_diff = diff(sorted_number_list, dims = 1)
    candidate = findall(x -> x == 0, number_diff)

    product_of_candidates = sorted_number_list[candidate[1]] * (2020 - sorted_number_list[candidate[1]])
    print(product_of_candidates, "\n")

    # Find product of 3 numbers in the list that add up to 2020
    for i = 1:length(number_list)
        for j = (i+1):length(number_list)
            for k = (j+1):length(number_list)
                if ((number_list[i] + number_list[j] + number_list[k]) == 2020)
                    print(number_list[i] * number_list[j] * number_list[k])
                end
            end
        end
    end


end

NumberList = readdlm("PuzzleInput.txt", Int64);
ReportRepair(NumberList);