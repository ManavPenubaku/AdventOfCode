using DelimitedFiles

function ParseInputForBounds(StringInput)
    pieces = split(StringInput,'-');
    map(pieces) do piece
        bounds = parse(Int64,piece);
    end
end

PasswordList = readdlm("PuzzleInput.txt");
password_correct_counter = 0;

# Part 1 : Check if the number of occurrences of a letter is within a specified range
for i in 1:size(PasswordList)[1]
    letter_counter = 0;
    for j in 1:length(PasswordList[i,3])
        if(PasswordList[i,2][1] == PasswordList[i,3][j])
            letter_counter = letter_counter+1
        end
    end

    global bounds = ParseInputForBounds(PasswordList[i,1]);
    if(letter_counter >= bounds[1] && letter_counter <= bounds[2])
        global password_correct_counter = password_correct_counter + 1;
    end
end
print("Answer to Part 1 :",password_correct_counter,"\n");

# Part 2 : Check if the letter only occurs in one of two positions in the password
password_correct_counter = 0;
for i in 1:size(PasswordList)[1]
    global positions = ParseInputForBounds(PasswordList[i,1]);
    if(xor(PasswordList[i,3][positions[1]] == PasswordList[i,2][1],PasswordList[i,3][positions[2]] == PasswordList[i,2][1]))
        global password_correct_counter = password_correct_counter + 1;
    end    
end

print("Answer to Part 2 :",password_correct_counter,"\n");
