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
    for i in 1:length(unique_allergens)
        assemble_ingredients=[];
        allergen_indices = findall(x->sum(x.==unique_allergens[i])>=1,allergens);
        for j in 1:length(allergen_indices)
            append!(assemble_ingredients,ingredients[allergen_indices[j]]);
        end
        append!(possible_allergens,findall(x->values(x)==length(allergen_indices),countmap(assemble_ingredients)));
    end
    return (unique(possible_allergens))
end

function CountIngredients(ingredients,allergen_ingredients)
    ingredient_count = 0;
    for n in 1:length(ingredients)
        ingredient_count += sum(map(x->sum(x.!=allergen_ingredients),ingredients[n]).==length(allergen_ingredients));
    end
    return ingredient_count
    println(size(ingredient_count))
end

allergen_ingredients = FindAllergens(ingredients,allergens);
ingredients_zonder_allergens = CountIngredients(ingredients,allergen_ingredients);