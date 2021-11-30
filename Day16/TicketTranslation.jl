files = open("input.txt");
lines = readlines(files);
TicketDataInput = split.(lines,": ")

function ExtractTicketDetails(TicketDataInput)
    own_ticket_index = findall(x->x[1]=="your ticket:",TicketDataInput);
    own_ticket = parse.(Int,split(TicketDataInput[own_ticket_index[1]+1][1],","));

    nearby_ticket_start = findall(x->x[1]=="nearby tickets:",TicketDataInput);
    nearby_tickets = map(x->parse.(Int,split(x[1],",")),TicketDataInput[(nearby_ticket_start[1]+1):end,1])

    reg = r"(.+)-(.+) or (.+)-(.+)";
    ticket_field_ranges = map(x->match.(reg,x[2]),TicketDataInput[1:own_ticket_index[1]-2]);
    ticket_bounds = Array{Int}(undef,length(ticket_field_ranges),4);
    for n in 1:4
        ticket_bounds[:,n] = parse.(Int,map(x->x.captures[n],ticket_field_ranges));
    end
    return own_ticket,nearby_tickets,ticket_bounds
end

function FindValidTickets(nearby_tickets,ticket_bounds)
    all_valid_numbers = [];
    number_of_fields = size(ticket_bounds,1);
    ticket_error_rate = 0;
    valid_tickets = deepcopy(nearby_tickets);
    invalid_ticket_ids = [];
    for bound_ids in 1:number_of_fields
        temp_first = ticket_bounds[bound_ids,1]:1:ticket_bounds[bound_ids,2];
        temp_second = ticket_bounds[bound_ids,3]:1:ticket_bounds[bound_ids,4];
        all_valid_numbers = unique([all_valid_numbers;temp_first;temp_second]);
    end
    
    for tickets in 1:length(nearby_tickets)
        invalid_field = findall(y->y!=1,sum.(map(x->x.==all_valid_numbers,nearby_tickets[tickets])));
        try
            ticket_error_rate += nearby_tickets[tickets][invalid_field[1]];
            append!(invalid_ticket_ids,tickets);
        catch
        end
    end
    println(size(invalid_ticket_ids))
    valid_tickets = valid_tickets[setdiff(1:end,invalid_ticket_ids),:];
    return ticket_error_rate,valid_tickets;
end

function FindTicketFields(valid_tickets,ticket_bounds)
    matching_fields = Dict();
    for n in 1:size(ticket_bounds,1)
        check_in_bounds = map(x->(((x.>=ticket_bounds[n,1]).&(x.<=ticket_bounds[n,2])).|((x.>=ticket_bounds[n,3]).&(x.<=ticket_bounds[n,4]))),valid_tickets);
        try
            matching_fields[n] = findall(sum(check_in_bounds).==length(valid_tickets));
        catch
        end
    end
    ticket_bound_ids = collect(keys(matching_fields));
    ticket_field_ids = collect(values(matching_fields));
    field_to_bounds = Dict();
    count = 1;
    while count<=20
        to_be_deleted = findall(length.(ticket_field_ids).==count);
        field_list = ticket_field_ids[to_be_deleted[1]];
       
        for i in 1:length(field_list)
            if (!(haskey(field_to_bounds,field_list[i])))
                field_to_bounds[field_list[i]] = ticket_bound_ids[to_be_deleted[1]];
            end
        end
        count+=1;
    end
    bounds_to_fields = Dict(value => key for (key,value) in field_to_bounds);
    return bounds_to_fields;
end

own_ticket,nearby_tickets,ticket_bounds = ExtractTicketDetails(TicketDataInput);
ticket_error_rate,valid_tickets = FindValidTickets(nearby_tickets,ticket_bounds);
println("Solution for Part 1 is : ",ticket_error_rate);

ticket_field_ids = FindTicketFields(valid_tickets,ticket_bounds);
sol2 = own_ticket[ticket_field_ids[1]]* own_ticket[ticket_field_ids[2]] * own_ticket[ticket_field_ids[3]] *own_ticket[ticket_field_ids[4]] * own_ticket[ticket_field_ids[5]] * own_ticket[ticket_field_ids[6]];
println("Solution for Part 2 is : ",sol2);


