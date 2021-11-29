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
    for bound_ids in 1:number_of_fields
        temp_first = ticket_bounds[bound_ids,1]:1:ticket_bounds[bound_ids,2];
        temp_second = ticket_bounds[bound_ids,3]:1:ticket_bounds[bound_ids,4];
        all_valid_numbers = unique([all_valid_numbers;temp_first;temp_second]);
    end
    
    for tickets in 1:length(nearby_tickets)
        invalid_field = findall(y->y!=1,sum.(map(x->x.==all_valid_numbers,nearby_tickets[tickets])));
        try
            ticket_error_rate += nearby_tickets[tickets][invalid_field[1]];
            valid_tickets = valid_tickets[setdiff(1:end,tickets),:];
        catch
        end
    end
    return ticket_error_rate,valid_tickets;
end

own_ticket,nearby_tickets,ticket_bounds = ExtractTicketDetails(TicketDataInput);
ticket_error_rate,valid_tickets = FindValidTickets(nearby_tickets,ticket_bounds);

