using DelimitedFiles

NumberList = readdlm("PuzzleInput.txt",Int64)

function FindAddends(NumberList,Sum)
    for i in 1:length(NumberList)
        for j in (i+1):length(NumberList)
            if (NumberList[i]+NumberList[j] == Sum)
                return 0;
            end
        end
    end
    return 1;
end

function FindEncodingError(NumberList)
    EncodingErrorFlag = 0;
    PreambleLength = 25;
    StartIndex = 1;
    Sum = 0;
    while (EncodingErrorFlag == 0)
        NumberListSection = NumberList[StartIndex:(StartIndex+PreambleLength-1)];
        Sum = NumberList[StartIndex+PreambleLength];
        EncodingErrorFlag = FindAddends(NumberListSection,Sum);
        StartIndex +=1;
    end
    return Sum;
end

function FindContiguousSequence(NumberList,Sum)
    EncodingErrorFlag = 1;
    PreambleLength = 2;
    StartIndex = 1;
    NumberListSection = [];
    while (EncodingErrorFlag == 1)
        NumberListSection = NumberList[StartIndex:(StartIndex+PreambleLength-1)];
        if (sum(NumberListSection) == Sum)
            EncodingErrorFlag = 0;
        end
        StartIndex +=1;
        if (StartIndex == (length(NumberList)-PreambleLength))
            StartIndex = 1
            PreambleLength +=1;
        end
    end
    return sort(NumberListSection);
end

FaultyNumber = FindEncodingError(NumberList);
println("Solution to Part 1 is : ",FaultyNumber);

# Only use number list upto the faulty number
NewNumberList = NumberList[1:findall(x->x==FaultyNumber,NumberList)[1].I[1]];

CorrectSequenceSorted = FindContiguousSequence(NumberList,FaultyNumber);
EncryptionWeakness = CorrectSequenceSorted[1]+ CorrectSequenceSorted[end];
println("Solution to Part 2 is : ", EncryptionWeakness);
