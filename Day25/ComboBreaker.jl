file = open("input.txt")
lines = readlines(file)

input = parse.(Int,lines)

function FindEncryptionKey(input)
    loop_size = 0
    value = 1
    while value != input[1]
        value = mod(value * 7,20201227)
        loop_size +=1
    end
    return powermod(input[2],loop_size,20201227)
end

sol1 = FindEncryptionKey(input)
println("Solution to Part 1 is : ", sol1)