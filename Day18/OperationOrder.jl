file = open("input.txt")
lines = readlines(file)
equations = join.(split.(lines," "));

function EvaluateExpressions(equations)
    answers = Array{Int64}(undef,length(lines))
    temp_eval = 0;
    bracket_indices = 0;
    for expression in 1:length(lines)
        open_bracket_indices = findall(x->x.=='(',lines[expression])
        closed_bracket_indices = findall(x->x.==')',lines[expression])
        
        
        # current_line = lines[expression]
        # position = 1;
        # while position < length(current_line)
        #     if current_line[position] == '('
        #         answers[position] = temp_eval
        #         temp_eval = 0
        #         position += 1;
        #     elseif current_line[position] == ')'

        #     elseif current_line[position] == '+'
        #         temp_eval = temp_eval + current_line[position+1]
        #         position+=2;
        #     elseif current_line[position] == '*'
        #         temp_eval = temp_eval * current_line[position+1]
        #     elseif temp_eval == 0
        #         temp_eval = parse(Int,current_line[position])
        #     end
        # end
    end
    return bracket_indices
end

answers = EvaluateExpressions(lines)