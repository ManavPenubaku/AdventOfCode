using StatsBase

file = open("input.txt");
lines = readlines(file);
contain_regex = r"(.+)\(contains (.+)\)";
foods = match.(contain_regex,lines);

ingredients = map(y->y[1:end-1],split.(map(x->x.captures[1],foods)," "));
allergens = split.(map(x->x.captures[2],foods),", ");

function FindAllergens(ingredients,allergens)
    unique_allergens = [];
    for n in 1:length(allergens)
        append!(unique_allergens,allergens[n]);
    end
    possible_allergens =[];
    AllergenDict = Dict();
    for i in 1:length(unique_allergens)
        keycount = 0;
        new_allergen_index = 0;
        assemble_ingredients=[];
        allergen_indices = findall(x->sum(x.==unique_allergens[i])>=1,allergens);
        for j in 1:length(allergen_indices)
            append!(assemble_ingredients,ingredients[allergen_indices[j]]);
        end
        possible_allergen_temp = findall(x->values(x)==length(allergen_indices),countmap(assemble_ingredients));
        if (length(possible_allergen_temp) == 1)
            AllergenDict[possible_allergen_temp[1]] = unique_allergens[i];
        else
            for n in 1:length(possible_allergen_temp)
                if (haskey(AllergenDict,possible_allergen_temp[n]))
                    keycount+=1;
                else
                    new_allergen_index = n;
                end
            end
            if (keycount == length(possible_allergen_temp)-1)
                AllergenDict[possible_allergen_temp[new_allergen_index]] = unique_allergens[i];
            end
        end
        append!(possible_allergens,possible_allergen_temp);
    end
    
    return unique(possible_allergens),sort(collect(AllergenDict),by=x->x[2])
end

function CountIngredients(ingredients,allergen_ingredients)
    ingredient_count = 0;
    for n in 1:length(ingredients)
        ingredient_count += sum(map(x->sum(x.!=allergen_ingredients),ingredients[n]).==length(allergen_ingredients));
    end
    return ingredient_count
end

allergen_ingredients,allergendict = FindAllergens(ingredients,allergens);
ingredients_zonder_allergens = CountIngredients(ingredients,allergen_ingredients);
println("Solution to Part 1 is : ",ingredients_zonder_allergens);
println("Solution to Part 2 is : ",join(map(x->values(x)[1],allergendict),","))