using DelimitedFiles

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
        if (sum(SelectedMessages[i] .== VML)>0)
            ValidMessageCount+=1;
        end
    end
    return ValidMessageCount;
end

function MatchingRules2(MessageList)
    Rule42 = GenerateValidMessages(RuleList,42);
    Rule31 = GenerateValidMessages(RuleList,31);

    section_length = length(Rule31[1]);
    ValidMessageCount = 0;
    MessageList = MessageList[findall(x->x==0,mod.(length.(MessageList),section_length))];
    
    for n in 1:length(MessageList)
        match_counter = 0;
        Rule42Flag = 0;
        match_31 = 0;
        match_42 = 0;
        sections = convert(Int,length(MessageList[n])/section_length);
        index = sections - 1;
        rangeinspect = (section_length*index+1):length(MessageList[n]);
        if (sum(MessageList[n][rangeinspect] .== Rule31) > 0)
            match_counter+=1;
            match_31+=1;
        end
        while index >=4
            rangeinspect = (section_length*(index-1)+1):section_length*index;
            if (sum(MessageList[n][rangeinspect] .== Rule31) > 0 && Rule42Flag == 0)
                match_counter+=1;         
                match_31+=1;     
            end
            if (sum(MessageList[n][rangeinspect] .== Rule42) > 0)
                match_counter+=1;
                Rule42Flag = 1;
                match_42+=1;
            end
            index -= 1;
        end
        while index >=1
            rangeinspect = (section_length*(index-1)+1):section_length*index;
            if (sum(MessageList[n][rangeinspect] .== Rule42) > 0)
                match_counter+=1;
            end
            index -= 1;
            match_42+=1;
        end
        if (match_counter == sections && match_42 > match_31)
            ValidMessageCount+=1;
        end
    end
    return ValidMessageCount
end

ValidMessageList = GenerateValidMessages(RuleList,0);

Output = MatchingRules(MessageList,ValidMessageList);
println("Solution for Part 1 is :",Output);
Output2 = MatchingRules2(MessageList);
println("Solution for Part 2 is :",Output2);
