using DelimitedFiles
using Combinatorics

SatelliteMessages = readdlm("input.txt");

FirstMessageIndex = findall(x->x==1,all.(isletter,SatelliteMessages[:,1]))[1];
RuleList = SatelliteMessages[1:FirstMessageIndex-1,:];
MessageList = SatelliteMessages[FirstMessageIndex:end,1];

RuleList[:,1] = parse.(Int,String.(reduce(vcat,split.(RuleList[:,1],":",keepempty = false))));
RuleList = RuleList[sortperm(RuleList[:,1]),:];

function FindStringCombinations(A,B)
    AB = Array{String}(undef,(length(A)*length(B)),1);
    Index = 1;
    for i in 1:length(A)
        for j in 1:length(B)
            AB[Index] = A[i] * B[j];
            Index +=1;
        end
    end
    return AB;
end

function GenerateValidMessages(RuleList,RuleNumber)
    Rule = RuleList[RuleNumber+1,2:end];
    MessagePiece = [""];
    OrLocation = findall(x->x==1,Rule .== "|");
    Temp = [""];
    if (!isempty(OrLocation))
        if OrLocation[1] == 3
            A = string.(GenerateValidMessages(RuleList,Rule[1]));
            B = string.(GenerateValidMessages(RuleList,Rule[2]));
            C = string.(GenerateValidMessages(RuleList,Rule[4]));
            D = string.(GenerateValidMessages(RuleList,Rule[5]));
            AB = FindStringCombinations(A,B);
            CD = FindStringCombinations(C,D);
        else
            AB = GenerateValidMessages(RuleList,Rule[1]);
            CD = GenerateValidMessages(RuleList,Rule[3]);
        end
        MessagePiece[1] = string(AB[1]);
        if length(AB)>1
            for i in 2:length(AB)
                MessagePiece = [MessagePiece;string(AB[i])];
            end
        end
        for j in 1:length(CD)
            MessagePiece = [MessagePiece;string(CD[j])];
        end
    else
        for n in 1:length(Rule)
            if (Rule[n] == "a" || Rule[n] == "b");
                MessagePiece = Rule[n];
            elseif (Rule[n] != "")
                Temp = (GenerateValidMessages(RuleList,Rule[n]));
                MessagePiece =  FindStringCombinations(MessagePiece,Temp);
            else
                break;
            end
        end
    end
    return MessagePiece;
end

function MatchingRules(MessageList,VML)
    ValidMessageLengths = unique(length.(VML));
    SelectedMessages = string.(MessageList[findall(x->x==ValidMessageLengths[1],length.(MessageList))]);
    ValidMessageCount = 0;
    for i in 1:length(SelectedMessages)
        for j in 1:length(VML)
            if SelectedMessages[i] == VML[j]
                ValidMessageCount+=1;
                break;
            end
        end
    end
    return ValidMessageCount;
end

ValidMessageList = GenerateValidMessages(RuleList,0);

Output = MatchingRules(MessageList,ValidMessageList);

