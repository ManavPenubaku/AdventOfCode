file = open("input.txt")
lines = readlines(file)
slice = String.(reduce(hcat,split.(lines,"")))

function InitPocketDimension(slice)
    slice_size = size(slice,1)
    slice_xy = size(slice,1)+2*(bootcycles+1)
    slice_zw = 1+2*(bootcycles+1);
    start_zw = convert(Int,round(slice_zw/2))
    PocketDimension = Array{String}(undef,slice_xy,slice_xy,slice_zw,slice_zw)
    PocketDimension .= "."
    PocketDimension[slice_size:(2*slice_size)-1,slice_size:(2*slice_size)-1,start_zw,start_zw] .= slice
    return PocketDimension
end

function ExecuteBootCycles3D(PocketDimension)
    bootcycles = 6
    slice_xy = size(PocketDimension,1)
    slice_zw = size(PocketDimension,3)
    start_zw = convert(Int,round(slice_zw/2))
    bootcycle = 0;
    PocketDimensionCopy = deepcopy(PocketDimension)
    while bootcycle < bootcycles
        for i = 2:slice_xy-1, j = 2:slice_xy-1, k = 2:slice_zw-1
            active_cells = sum(PocketDimension[i-1:i+1,j-1:j+1,k-1:k+1,start_zw] .== "#")
            if (PocketDimension[i,j,k,start_zw] == "." && active_cells == 3)
                PocketDimensionCopy[i,j,k,start_zw] = "#"
            elseif (PocketDimension[i,j,k,start_zw] == "#" && (active_cells<3 || active_cells>4))
                PocketDimensionCopy[i,j,k,start_zw] = "."
            end
        end
        PocketDimension = deepcopy(PocketDimensionCopy)
        bootcycle+=1
    end
    active_cubes = sum(PocketDimension .== "#");
    return active_cubes
end

function ExcecuteBootCycles4D(PocketDimension)
    bootcycles = 6
    slice_xy = size(PocketDimension,1)
    slice_zw = size(PocketDimension,3)
    bootcycle = 0;
    PocketDimensionCopy = deepcopy(PocketDimension)
    while bootcycle < bootcycles
        for i = 2:slice_xy-1, j = 2:slice_xy-1, k = 2:slice_zw-1, l = 2:slice_zw-1
            active_cells = sum(PocketDimension[i-1:i+1,j-1:j+1,k-1:k+1,l-1:l+1] .== "#")
            if (PocketDimension[i,j,k,l] == "." && active_cells == 3)
                PocketDimensionCopy[i,j,k,l] = "#"
            elseif (PocketDimension[i,j,k,l] == "#" && (active_cells<3 || active_cells>4))
                PocketDimensionCopy[i,j,k,l] = "."
            end
        end
        PocketDimension = deepcopy(PocketDimensionCopy)
        bootcycle+=1
    end
    active_cubes = sum(PocketDimension .== "#");
    return active_cubes
end

StartPocketDimension = InitPocketDimension(slice)
active_cubes_3d = ExecuteBootCycles3D(StartPocketDimension)
println("Solution to Part 1 is : ",active_cubes_3d)
active_cubes_4d = ExcecuteBootCycles4D(StartPocketDimension)
println("Solution to Part 2 is : ",active_cubes_4d)