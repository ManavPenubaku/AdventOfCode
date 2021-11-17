using DataFrames

function ExtractPassportData()
    file = open("PuzzleInput.txt");
    lines = readlines(file);
    
    PassportData = DataFrame(byr = Int[], iyr = Int[], eyr = Int[], hgt = String[], hcl = String[], ecl = String[], pid = String[]);

    temp_byr = 0;
    temp_iyr = 0;
    temp_eyr = 0;
    temp_hgt = "";
    temp_hcl = "";
    temp_ecl = "";
    temp_pid = "";

    for i in 1:length(lines)
        if split(lines[i]," ")[1] == "" 
            push!(PassportData,Dict(:byr => temp_byr, :iyr => temp_iyr, :eyr => temp_eyr, :hgt => temp_hgt, :hcl => temp_hcl, :ecl => temp_ecl, :pid => temp_pid ))
            temp_byr = 0;
            temp_iyr = 0;
            temp_eyr = 0;
            temp_hgt = "";
            temp_hcl = "";
            temp_ecl = "";
            temp_pid = "";
        else
            split_line = split(lines[i]," ");
            for j in 1:length(split_line)
                temp_key = split_line[j][1:3];
                if temp_key == "byr"
                    temp_byr = parse(Int, split_line[j][5:end]);
                elseif temp_key == "iyr"
                    temp_iyr = parse(Int, split_line[j][5:end]);
                elseif temp_key == "eyr"
                    temp_eyr = parse(Int, split_line[j][5:end]);
                elseif temp_key == "hgt"
                    temp_hgt = split_line[j][5:end];
                elseif temp_key == "hcl"
                    temp_hcl = split_line[j][5:end];
                elseif temp_key == "ecl"
                    temp_ecl = split_line[j][5:end];
                elseif temp_key == "pid"
                    temp_pid = split_line[j][5:end];
                end
            end
        end
    end
    push!(PassportData,Dict(:byr => temp_byr, :iyr => temp_iyr, :eyr => temp_eyr, :hgt => temp_hgt, :hcl => temp_hcl, :ecl => temp_ecl, :pid => temp_pid ))
    return PassportData;
end

function FindValidPassportsPart1(PassportData)
    valid_passports = (PassportData.byr .!= 0) .& (PassportData.iyr .!= 0) .& (PassportData.eyr .!= 0) .& (PassportData.hgt .!= "") .& (PassportData.hcl .!= "") .& (PassportData.ecl .!= "") .& (PassportData.pid .!= "");
    # ValidPassportData = filter(row -> valid_passports, PassportData);
    return valid_passports
end

function FindValidHeights(PassportHeights)
    valid_heights = BitArray(undef,(length(PassportHeights),1));
    for i in 1:length(PassportHeights)
        if PassportHeights[i][end-1:end] == "cm" && parse(Int, PassportHeights[i][1:end-2]) >= 150 && parse(Int, PassportHeights[i][1:end-2]) <=193
            valid_heights[i] = true;
        elseif PassportHeights[i][end-1:end] == "in" && parse(Int, PassportHeights[i][1:end-2]) >= 59 && parse(Int, PassportHeights[i][1:end-2]) <= 76
            valid_heights[i] = true;
        else
            valid_heights[i] = false;
        end
    end
    return valid_heights;
end

function FindValidHairColors(PassportHairColors)
    valid_haircolors = BitArray(undef,(length(PassportHairColors),1));
    for i in 1:length(PassportHairColors)
        if PassportHairColors[i][1] == '#' && length(PassportHairColors[i][2:end]) == 6
            for j in 2:7
                if isxdigit(PassportHairColors[i][j])
                    valid_haircolors[i] = true;
                else
                    valid_haircolors[i] = false;
                    break;
                end
            end
        else
            valid_haircolors[i] = false;
        end
    end
    return valid_haircolors;
end

function FindValidEyeColors(PassportEyeColors)
    valid_eyecolors = (PassportEyeColors .== "amb") .| (PassportEyeColors .== "blu") .| (PassportEyeColors .== "brn") .| (PassportEyeColors .== "gry") .| 
    (PassportEyeColors .== "grn") .| (PassportEyeColors .== "hzl") .| (PassportEyeColors .== "oth");
    
    return valid_eyecolors;
end

function FindValidPassportIds(PassportIDs)
    valid_pids = BitArray(undef,(length(PassportIDs),1));
    for i in 1:length(PassportIDs)
        if length(PassportIDs[i]) == 9
            for j in 1:9
                if occursin(PassportIDs[i][j], "0123456789")
                    valid_pids[i] = true;
                else
                    valid_pids[i] = false;
                    break;
                end
            end
        else
            valid_pids[i] = false;
        end
    end
    return valid_pids;
end

function FindValidPassportsPart2(PassportData, ValidPassports)
    valid_birthyears = 1920 .<= PassportData.byr[ValidPassports] .<= 2002;
    valid_issueyears = 2010 .<= PassportData.iyr[ValidPassports] .<= 2020;
    valid_expirationyears = 2020 .<= PassportData.eyr[ValidPassports] .<= 2030;
    valid_heights = FindValidHeights(PassportData.hgt[ValidPassports]);
    valid_haircolors = FindValidHairColors(PassportData.hcl[ValidPassports]);
    valid_eyecolors = FindValidEyeColors(PassportData.ecl[ValidPassports]);
    valid_passport_ids = FindValidPassportIds(PassportData.pid[ValidPassports]);

    valid_passports_2 = valid_birthyears .& valid_issueyears .& valid_expirationyears .& valid_heights .& valid_haircolors .& valid_eyecolors .& valid_passport_ids;
    return valid_passports_2;
end

PassportData = ExtractPassportData();
valid_passports = FindValidPassportsPart1(PassportData);
print("Answer to part 1 is : " , sum(valid_passports),"\n");

valid_passports_2 = FindValidPassportsPart2(PassportData,valid_passports);
print("Answer to part 2 is : ", sum(valid_passports_2))