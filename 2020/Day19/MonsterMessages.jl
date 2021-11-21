using DelimitedFiles

SatelliteMessages = readdlm("input.txt");

FirstMessageIndex = findall(x->x==1,all.(isletter,SatelliteMessages[:,1]))[1];

RuleList = SatelliteMessages[1:FirstMessageIndex-1,:];
MessageList = SatelliteMessages[FirstMessageIndex:end,1];

RuleList[:,1] = parse.(Int,String.(reduce(vcat,split.(RuleList[:,1],":",keepempty = false))));

RuleList = RuleList[sortperm(RuleList[:,1]),:];