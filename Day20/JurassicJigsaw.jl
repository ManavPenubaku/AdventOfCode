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
        
    CornerIndices = map(x->x[2],Corners)
    return CornerIndices,MatchingEdges[:,CornerIndices];
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

function TileToMatrix(Tile)
    SplitTile = split.(Tile,"");
    TileMatrix = reduce(vcat,permutedims.(SplitTile));
    return TileMatrix
end

function PlaceCorners(EmptyJigsaw,TilePatterns,BitMask,JigsawCorners,JigsawSize)
    CornerBits = [1;1;0;0];
    XIndices = [1:10,(JigsawSize-9) : JigsawSize,(JigsawSize-9) : JigsawSize,1:10];
    YIndices = [1:10,1:10,(JigsawSize-9) : JigsawSize,(JigsawSize-9) : JigsawSize];
    for n in 1:length(JigsawCorners)
        TempMatrix = TileToMatrix(TilePatterns[:,JigsawCorners[n]]);
        if (sum(circshift(BitMask[1:4,n],-2).==CornerBits) == 4);
            TempMatrix = rot180(TempMatrix);
        elseif (sum(circshift(BitMask[1:4,n],-1).==CornerBits) == 4)
            TempMatrix = rotr90(TempMatrix);
        elseif (sum(circshift(BitMask[1:4,n],1).==CornerBits) == 4)
            TempMatrix = rotl90(TempMatrix);
        end
        CornerBits = circshift(CornerBits,1);
        EmptyJigsaw[XIndices[n],YIndices[n]] = TempMatrix
    end
    return EmptyJigsaw;
end

function ReorientEdgeTile(TileFlexible,TileLeft)
    Count = 0;
    while true
        if (join(TileFlexible[1:10,1]) == TileLeft)
            break;
        end
        TileFlexible = rotr90(TileFlexible);
        Count+=1;
        if Count == 4
            TileFlexible = reverse(TileFlexible,dims=2);
        end
    end
    return TileFlexible;
end

function PlaceEdges(JigsawWithCorners,TilePatterns,TileEdges,JigsawEdges,JigsawSize)
    XIndices = [1:10,10,(JigsawSize-9):JigsawSize,JigsawSize-9];
    YIndices = [10,1:10,10,(JigsawSize-9) : JigsawSize];
    TileCount = 1;
    EdgeTemp = deepcopy(TileEdges);
    for n in 1:4
        while (TileCount <= 10)
            XIndices = 1:10;
            YIndices = TileCount*10;
            TileLeft = join(JigsawWithCorners[XIndices,YIndices]);
            BitMask = map(x->x==TileLeft,EdgeTemp[:,JigsawEdges]);
            MatchingTileIndex = findall(y->y==1,BitMask)[1][2];
            MatchingTile = TileToMatrix(TilePatterns[:,JigsawEdges[MatchingTileIndex]]);
            MatchingTile = ReorientEdgeTile(MatchingTile,TileLeft);
            JigsawWithCorners[XIndices,YIndices+1:YIndices+10] = MatchingTile;
            EdgeTemp[:,JigsawEdges[MatchingTileIndex]] .= "";
            TileCount+=1;
        end
        TileCount = 1;
        JigsawWithCorners = rotr90(JigsawWithCorners);
        if n==2
            JigsawWithCorners = reverse(JigsawWithCorners,dims=1);
            JigsawWithCorners = rotr90(JigsawWithCorners);
        end
    end
    return JigsawWithCorners
end

function ReorientInnerTile(TileFlexible,TileLeft,TileAbove)
    Count = 0;
    while true
        if (join(TileFlexible[1:10,1]) == TileLeft && join(TileFlexible[1,1:10]) == TileAbove)
            break;
        end
        TileFlexible = rotr90(TileFlexible);
        Count+=1;
        if Count == 4
            TileFlexible = reverse(TileFlexible,dims=2);
        end
    end
    return TileFlexible;
end

function JoinJigsaw(TilePatterns,BitMask,JigsawCorners,JigsawEdges)
    PieceCount = convert(Int,sqrt(size(TilePatterns,2)));
    CharCount = size(TilePatterns,1);
    JigsawSize = PieceCount * CharCount;
    EmptyJigsaw = Matrix{String}(undef,JigsawSize,JigsawSize);
    EmptyJigsaw .= "";
    JigsawWithCorners = PlaceCorners(EmptyJigsaw,TilePatterns,BitMask,JigsawCorners,JigsawSize);
    JigsawWithEdges = PlaceEdges(JigsawWithCorners,TilePatterns,TileEdges,JigsawEdges,JigsawSize);

    MatchingTileIndex = 1;
    for i in 2:PieceCount-1
        for j in 2:PieceCount-1
            XIndicesLeft = (i-1)*CharCount+1 : CharCount*i;
            YIndicesLeft = (j-1)*CharCount;
            XIndicesAbove = (i-1)*CharCount;
            YIndicesAbove = (j-1)*CharCount+1 : CharCount*j;
            TileLeft = join(JigsawWithEdges[XIndicesLeft,YIndicesLeft]);
            TileAbove = join(JigsawWithEdges[XIndicesAbove,YIndicesAbove]);
            BitMask = map(x->x==TileLeft,TileEdges) .| map(x->x==TileAbove,TileEdges);
            MatchingTileIndex = (findall(y->y==2,sum(BitMask,dims=1))[1][2]);
            MatchingTile = TileToMatrix(TilePatterns[:,MatchingTileIndex]);
            MatchingTile = ReorientInnerTile(MatchingTile,TileLeft,TileAbove);
            JigsawWithEdges[XIndicesLeft,YIndicesAbove] = MatchingTile;
            TileEdges[:,MatchingTileIndex] .= "";
        end
    end
    return JigsawWithEdges;
end

function FindSeaMonsters(CompletedJigsaw)
    file = open("seamonster.txt");
    lines = readlines(file);
    splitline = split.(lines,"");
    SeaMonsterPattern = Matrix{String}(undef,length(lines),length(lines[1]));
    for n in 1:length(lines)
        SeaMonsterPattern[n,:] = splitline[n];
    end
    HashCount = sum(SeaMonsterPattern .== "#");
    SeaMonsterCount = 0;
    TileOrientationCount = 0;
    while SeaMonsterCount == 0
        for i in 1:94
            for j in 1:77
                Pattern = CompletedJigsaw[i:i+2,j:j+19]
                HashMatch =  Pattern .== SeaMonsterPattern;
                
                if (sum(HashMatch) == HashCount)
                    println(i);
                    println(j);
                    return Pattern,SeaMonsterPattern
                    println(TileOrientationCount)
                    SeaMonsterCount+=1;
                end
            end
        end
        CompletedJigsaw = rotr90(CompletedJigsaw);
        TileOrientationCount+=1;
        if (TileOrientationCount==4)
            CompletedJigsaw = reverse(CompletedJigsaw,dims=2);
        end
    end

    return SeaMonsterCount,CompletedJigsaw;
end

function RemoveBorders(CompletedJigsaw)
    NewJigsaw = CompletedJigsaw[setdiff(1:end, (1,10,11,20,21,30,31,40,41,50,51,60,61,70,71,80,81,90,91,100,101,110,111,120)), :];
    JigsawWithoutBorders = NewJigsaw[:,setdiff(1:end, (1,10,11,20,21,30,31,40,41,50,51,60,61,70,71,80,81,90,91,100,101,110,111,120))];
    return JigsawWithoutBorders;
end

TilePatterns, TileNumbers = GetTilePatternsAndNumbers(TileData);
TileEdges = GetIndividualTileEdges(TilePatterns);
JigsawCorners,BitMask = FindJigsawCorners(TileEdges);
JigsawEdges = FindJigsawEdges(TileEdges);
CompletedJigsaw = JoinJigsaw(TilePatterns,BitMask,JigsawCorners,JigsawEdges);
CompletedJigsawWithoutBorders = RemoveBorders(CompletedJigsaw);

SeaMonsterCount,RotJig = FindSeaMonsters(CompletedJigsawWithoutBorders)