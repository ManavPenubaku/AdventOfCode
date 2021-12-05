file = open("input.txt")
lines = readlines(file)

player_deck_split = findall(x->x.=="",lines)[1]
player1_deck =  parse.(Int,lines[2:player_deck_split-1])
player2_deck = parse.(Int,lines[player_deck_split+2:end])

function PlayCombat(player1_deck, player2_deck)
    while length(player1_deck)>0 && length(player2_deck)>0
        if (player1_deck[1]>player2_deck[1])
            player1_deck = append!(player1_deck,player1_deck[1],player2_deck[1])[2:end]
            player2_deck = player2_deck[2:end]
        else
            player2_deck = append!(player2_deck,player2_deck[1],player1_deck[1])[2:end]
            player1_deck = player1_deck[2:end]
        end
    end
    return player1_deck,player2_deck
end

player1_deck,player2_deck = PlayCombat(player1_deck,player2_deck)
println("Solution to Part 1 is : ",sum(player1_deck.*collect(50:-1:1)))