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
        println(XIndices[n])
        println(YIndices[n])
        EmptyJigsaw[XIndices[n],YIndices[n]] = TempMatrix
    end
    return EmptyJigsaw;
end

function PlaceEdges(JigsawWithCorners,TilePatterns,TileEdges,JigsawEdges,JigsawSize)
    EdgeBits = [0;1;0;0];# Right edge should match
    XIndices = [1:10,10,(JigsawSize-9):JigsawSize,JigsawSize-9];
    YIndices = [10,1:10,10,(JigsawSize-9) : JigsawSize];
    TileCount = 1;
    for n in 1:4
        if n == 1
            XIndices = 1:10;
        elseif n == 2
            XIndices = (JigsawSize-9):JigsawSize;
        elseif n == 3;
            EdgeBits = circshift(EdgeBits,1); #Top edge should match
            YIndices = 1:10;
        else
            YIndices = (JigsawSize-9):JigsawSize;
        end
        while (TileCount <= 10)
            if (n==1 || n==2) 
                YIndices = TileCount*10;
            else
                XIndices = TileCount*10;
            end
            BitMask = map(x->x==join(JigsawWithCorners[XIndices,YIndices]),TileEdges[:,JigsawEdges]);
            println(BitMask);
            MatchingTileIndex = findall(y->y==1,BitMask)[1][2];
            MatchingTile = TileToMatrix(TilePatterns[:,JigsawEdges[MatchingTileIndex]]);
            if (sum(circshift(BitMask[1:4,MatchingTileIndex],-2).==EdgeBits) == 4 || sum(circshift(BitMask[5:8,MatchingTileIndex],-2).==EdgeBits) == 4);
                MatchingTile = rot180(MatchingTile);
            elseif (sum(circshift(BitMask[1:4,MatchingTileIndex],-1).==EdgeBits) == 4 || sum(circshift(BitMask[5:8,MatchingTileIndex],-1).==EdgeBits) == 4)
                MatchingTile = rotr90(MatchingTile);
            elseif (sum(circshift(BitMask[1:4,MatchingTileIndex],1).==EdgeBits) == 4 || sum(circshift(BitMask[5:8,MatchingTileIndex],1).==EdgeBits) == 4)
                MatchingTile = rotl90(MatchingTile);
            end
            TileCount+=1;
            if (n==1 || n==2)
                if (join(JigsawWithCorners[XIndices,YIndices]) != join(MatchingTile[:,1]))
                    MatchingTile = reverse(MatchingTile,dims = 2);
                end
                if (join(JigsawWithCorners[XIndices,YIndices]) != join(MatchingTile[:,1]))
                    MatchingTile = reverse(MatchingTile,dims = 1);
                end
                JigsawWithCorners[XIndices,YIndices+1:YIndices+10] = MatchingTile;
            else
                if (join(JigsawWithCorners[XIndices,YIndices]) != join(MatchingTile[1,:]))
                    MatchingTile = reverse(MatchingTile,dims = 1);
                end
                if (join(JigsawWithCorners[XIndices,YIndices]) != join(MatchingTile[1,:]))
                    MatchingTile = reverse(MatchingTile,dims = 2);
                end
                JigsawWithCorners[XIndices+1:XIndices+10,YIndices] = MatchingTile;
            end
        end
        TileCount = 1;
    end
    return JigsawWithCorners
end

function JoinJigsaw(TilePatterns,BitMask,JigsawCorners,JigsawEdges)
    PieceCount = convert(Int,sqrt(size(TilePatterns,2)));
    CharCount = size(TilePatterns,1);
    JigsawSize = PieceCount * CharCount;
    EmptyJigsaw = Matrix{String}(undef,JigsawSize,JigsawSize);
    JigsawWithCorners = PlaceCorners(EmptyJigsaw,TilePatterns,BitMask,JigsawCorners,JigsawSize);
    JigsawWithEdges = PlaceEdges(JigsawWithCorners,TilePatterns,TileEdges,JigsawEdges,JigsawSize);

    # Use these functions to find matching edge
    return JigsawWithEdges;
    ######################################
    for i in 2:PieceCount-1
        for j in 2:PieceCount-1
            TempMatrix = TileToMatrix(TilePatterns[:,JigsawCorners[CornerNumber]]);
            UnmatchedEdges = findall(x->x==1,BitMask[:,CornerNumber]);
            if(UnmatchedEdges[1]==2 && UnmatchedEdges[2] == 3)
                TempMatrix = rotr90(TempMatrix);
            end
            rows = ((i-1)*PieceCount +1):i*CharCount;
            cols = ((j-1)*PieceCount +1):j*CharCount;
            CompletedJigsaw[rows,cols] = TempMatrix;
            break;
        end
        break;
    end
    return CompletedJigsaw;
end


TilePatterns, TileNumbers = GetTilePatternsAndNumbers(TileData);
TileEdges = GetIndividualTileEdges(TilePatterns);
JigsawCorners,BitMask = FindJigsawCorners(TileEdges);
JigsawEdges = FindJigsawEdges(TileEdges);
CompletedJigsaw = JoinJigsaw(TilePatterns,BitMask,JigsawCorners,JigsawEdges);

println("Solution for Part 1 is : ",prod(TileNumbers[JigsawCorners]));

outfile = "Jigsaw.txt"
open(outfile,"w") do f
    for i in 1:size(CompletedJigsaw,1)
        try
            println(f,join(CompletedJigsaw[i,:]))
        catch e
            println(f,join(CompletedJigsaw[i,1:10]))
        end
    end
end
