file = open("input.txt")
lines = readlines(file)
equations = join.(split.(lines," "));

function ComputeExpression(equation)
    count = 1
    value = 0
    while count < length(equation)
        if equation[count] == '('
            temp_value,temp_count = ComputeExpression(equation[count+1:end])
            if count >= 2 && equation[count-1] == '+'
                value += temp_value
            elseif count >= 2 && equation[count-1] == '*'
                value *= temp_value
            else
                value = temp_value
            end
            count += temp_count + 1
        elseif equation[count] == ')'
            return value,count
        elseif equation[count] == '*' && equation[count+1] != '('
            value = value * parse(Int,equation[count+1])
            count+=2
        elseif equation[count] == '+'&& equation[count+1] != '('
            value = value + parse(Int,equation[count+1])
            count+=2
        elseif isdigit(equation[count])
            value = parse(Int,equation[count])
            count+=1
        else
            count+=1
        end
    end
    return value,count
end

function ConductAddition(parsed_equation_array)
    while true
        indices = findall(x->x == '+',parsed_equation_array)
        addition_indices = indices[findall(x->(isdigit(string(parsed_equation_array[x-1])[1]) && isdigit(string(parsed_equation_array[x+1])[1])),indices)]
        if (isempty(addition_indices))
            break;
        else
            first_addition_index = addition_indices[1]
            parsed_equation_array[first_addition_index-1] = parsed_equation_array[first_addition_index-1] + parsed_equation_array[first_addition_index+1]
            deleteat!(parsed_equation_array,first_addition_index:first_addition_index+1)
        end
    end
    return parsed_equation_array
end

function ConductMultiplication(parsed_equation_array)
    while true
        indices = findall(x->x == '*',parsed_equation_array)
        mult_indices = indices[findall(x->(isdigit(string(parsed_equation_array[x-1])[1]) && isdigit(string(parsed_equation_array[x+1])[1])),indices)]
        if (isempty(mult_indices))
            break;
        else
            first_mult_index = mult_indices[1]
            parsed_equation_array[first_mult_index-1] = parsed_equation_array[first_mult_index-1] * parsed_equation_array[first_mult_index+1]
            deleteat!(parsed_equation_array,first_mult_index:first_mult_index+1)
        end
    end
    return parsed_equation_array
end

function ComputeExpression2(equation_array)
    parsed_equation_array = deepcopy(equation_array)
    while true
        open_bracket = findfirst(x->x == '(',parsed_equation_array)
        if (isnothing(open_bracket))
            parsed_equation_array = ConductAddition(parsed_equation_array)
            parsed_equation_array = ConductMultiplication(parsed_equation_array)
            break
        end

        next_open_bracket = findfirst(x->x == '(',parsed_equation_array[open_bracket+1:end])
        close_bracket = findfirst(x->x == ')',parsed_equation_array[open_bracket+1:end])

        if  isnothing(next_open_bracket) || close_bracket < next_open_bracket
            temp_array = ConductAddition(parsed_equation_array[open_bracket+1:open_bracket+close_bracket-1])
            parsed_equation_array[open_bracket] = ConductMultiplication(temp_array)[1]
            deleteat!(parsed_equation_array,open_bracket+1:open_bracket+close_bracket)
        else
            next_close_bracket = findfirst(x->x == ')',parsed_equation_array[open_bracket+next_open_bracket+1:end])
            parsed_equation_array[open_bracket+next_open_bracket] = ComputeExpression2(parsed_equation_array[open_bracket+next_open_bracket:open_bracket+next_open_bracket+next_close_bracket])
            deleteat!(parsed_equation_array,next_open_bracket+open_bracket+1:open_bracket+next_close_bracket+next_open_bracket)
        end
        
    end
    return parsed_equation_array[1]
end

function EvaluateExpressions(equations)
    answers1 = Array{Int64}(undef,length(equations))
    answers2 = Array{Int64}(undef,length(equations))
    for n in 1:length(lines)
        current_equation = equations[n]
        answers1[n],counter = ComputeExpression(current_equation)
        current_equation_array = String.(split(current_equation,""))
        parsed_equation_array = Array{Any}(undef,length(current_equation_array))
        for n in 1:length(current_equation_array)
            if (isdigit(current_equation_array[n][1]))
                parsed_equation_array[n] = parse(Int,current_equation_array[n])
            else
                parsed_equation_array[n] = current_equation_array[n][1]
            end
        end
        answers2[n] = ComputeExpression2(parsed_equation_array)
    end
    return sum(answers1),sum(answers2)
end



sum_p1,sum_p2 = EvaluateExpressions(equations)
println("Solution to Part 1 is : ",sum_p1)
println("Solution to Part 2 is : ",sum_p2)