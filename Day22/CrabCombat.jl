file = open("input.txt")
lines = readlines(file)

player_deck_split = findall(x->x.=="",lines)[1]
player1_deck =  parse.(Int,lines[2:player_deck_split-1])
player2_deck = parse.(Int,lines[player_deck_split+2:end])

function PlayCombat(player_deck1, player_deck2)
    player1_deck = deepcopy(player_deck1)
    player2_deck = deepcopy(player_deck2)
    while length(player1_deck)>0 && length(player2_deck)>0
        if (player1_deck[1]>player2_deck[1])
            player1_deck = append!(player1_deck,player1_deck[1],player2_deck[1])[2:end]
            player2_deck = player2_deck[2:end]
        else
            player2_deck = append!(player2_deck,player2_deck[1],player1_deck[1])[2:end]
            player1_deck = player1_deck[2:end]
        end
    end
    winning_player = length(player1_deck) > 0 ? 1 : 2
    winning_score = sum(winning_player == 1 ? player1_deck.*collect(50:-1:1) : player2_deck.*collect(50:-1:1))
    return winning_player, winning_score
end

function RecursiveCombat(player_deck1,player_deck2)
    winning_player = 0;
    winning_score = 0;
    deck_configuration_score_1 = [];
    deck_configuration_score_2 = [];
    player1_deck = deepcopy(player_deck1)
    player2_deck = deepcopy(player_deck2)
    while (length(player1_deck) > 0 && length(player2_deck) > 0)
        if (!isempty(findall(x->x==string(player1_deck),deck_configuration_score_1)) || !isempty(findall(x->x==string(player2_deck),deck_configuration_score_2)))
            winning_score = sum(player1_deck.*collect(length(player1_deck):-1:1))
            return 1,winning_score
        else
            deck_configuration_score_1 = [deck_configuration_score_1;string(player1_deck)]
            deck_configuration_score_2 = [deck_configuration_score_2;string(player2_deck)]
        end
        if (length(player1_deck)-1 >= player1_deck[1] && length(player2_deck)-1 >= player2_deck[1])
            sub_deck_player1 = deepcopy(player1_deck[2:1+player1_deck[1]])
            sub_deck_player2 = deepcopy(player2_deck[2:1+player2_deck[1]])
            winning_player,winning_score = RecursiveCombat(sub_deck_player1,sub_deck_player2)
        elseif (player1_deck[1]>player2_deck[1])
            winning_player = 1
        else
            winning_player = 2
        end
        if winning_player == 1
            player1_deck = append!(player1_deck,player1_deck[1],player2_deck[1])[2:end]
            player2_deck = player2_deck[2:end]
        elseif winning_player == 2
            player2_deck = append!(player2_deck,player2_deck[1],player1_deck[1])[2:end]
            player1_deck = player1_deck[2:end]
        end
    end
    winning_player = length(player1_deck) > length(player2_deck) ? 1 : 2
    winning_score = sum(winning_player == 1 ? player1_deck.*collect(length(player1_deck):-1:1) : player2_deck.*collect(length(player2_deck):-1:1))
    return winning_player, winning_score
end

winning_player_p1, winning_score_p1 = PlayCombat(player1_deck,player2_deck)
println("Solution to Part 1 is : ",winning_score_p1)
winning_player_p2,winning_score_p2 = RecursiveCombat(player1_deck,player2_deck)
println("Solution to Part 2 is : ",winning_score_p2)