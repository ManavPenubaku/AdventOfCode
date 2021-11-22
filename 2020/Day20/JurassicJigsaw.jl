using DelimitedFiles
using StatsBase

TileData = readdlm("input.txt");

function GetTilePatternsAndNumbers(TileData)
    TilePatternIndices = findall(x->x==1,TileData[:,1].!="Tile");
    TileNumberIndices = findall(x->x==1,TileData[:,1].=="Tile");
    TileSize = diff(TileNumberIndices)[1]-1;
    TotalTiles = convert(Int,length(TilePatternIndices)/TileSize);
    TilePatterns = TileData[reshape(TilePatternIndices,TileSize,TotalTiles)];
    TileNumbers = map(x -> parse(Int,x[1:end-1]),TileData[TileNumberIndices,2]);
    return TilePatterns,TileNumbers
end

function GetIndividualTileEdges(TilePatterns)
    TileEdges = Matrix{Any}(undef,8,144)
    for n in 1:size(TilePatterns,2)
        TileEdges[1,n] = TilePatterns[:,n][1];
        TileEdges[2,n] = join(map(x->x[1],TilePatterns[:,n]))
        TileEdges[3,n] = TilePatterns[:,n][end];
        TileEdges[4,n] = join(map(x->x[end],TilePatterns[:,n]))
        TileEdges[5,n] = reverse(TileEdges[1,n])
        TileEdges[6,n] = reverse(TileEdges[2,n])
        TileEdges[7,n] = reverse(TileEdges[3,n])
        TileEdges[8,n] = reverse(TileEdges[4,n])
    end
    return TileEdges;
end

function FindJigsawCorners(TileEdges)
    EdgeDict = countmap(TileEdges);
    Edges = collect(keys(EdgeDict));
    UniqueEdgeIndices = findall(x->x==1,values(EdgeDict).==1);
    UniqueEdges = Edges[UniqueEdgeIndices];

    #Find tile edges that match the unique edges
    MatchingEdges = map(x->sum(x.==UniqueEdges),TileEdges);
    Corners = findall(x->x==4,sum(MatchingEdges,dims=1));
    return map(x->x[2],Corners);
end

function FindJigsawEdges(TileEdges)
    EdgeDict = countmap(TileEdges);
    Edges = collect(keys(EdgeDict));
    UniqueEdgeIndices = findall(x->x==1,values(EdgeDict).==1);
    UniqueEdges = Edges[UniqueEdgeIndices];

    #Find tile edges that match the unique edges
    MatchingEdges = map(x->sum(x.==UniqueEdges),TileEdges);
    JigsawEdges = findall(x->x==2,sum(MatchingEdges,dims=1));
    return map(x->x[2],JigsawEdges);
end

TilePatterns, TileNumbers = GetTilePatternsAndNumbers(TileData);
TileEdges = GetIndividualTileEdges(TilePatterns);
JigsawCorners = FindJigsawCorners(TileEdges);

JigsawEdges = FindJigsawEdges(TileEdges);

println("Solution for Part 1 is : ",prod(TileNumbers[JigsawCorners]));