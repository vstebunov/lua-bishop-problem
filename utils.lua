function inTable(v, t)
	for _, x in ipairs(t) do
		if v == x then return true end;
	end
	return false;
end

function is_table_equal(tab1, tab2) 
	local counter = 0
	for _, t1 in ipairs(tab1) do
		for _, t2 in ipairs(tab2) do
			if t1[1] == t2[1] and t1[2] == t2[2] then
				counter = counter + 1
			end
		end
	end
	if counter ~= 4 then
		return false
	end
	return true
end

function is_closed_state(closed, c_s) 
	for _, c in pairs(closed) do
		if is_table_equal(c[2], c_s[2]) and is_table_equal(c[3], c_s[3]) then
			return true
		end
	end
	return false;
end

function print_state(state) 
	local str = 'black:{'
	for _,b in pairs(state[2]) do str = str .. '{' .. b[1] .. ',' .. b[2] .. '}, ' end
	str = str .. '}, white:{'
	for _,b in pairs(state[3]) do str = str .. '{' .. b[1] .. ',' .. b[2] .. '}, ' end
	str = str .. '}'
	print(str)
end

local win_white = {{0,3}, {1,2}, {2,1}, {3,0}};
local win_black = {{4,7}, {5,6}, {6,5}, {7,4}};

function is_win(black, white) 
	local is_in_black = 0;
	local is_in_white = 0;
	for _,b in ipairs(black) do
		for _,wb in ipairs(win_black) do
			if (b[1] == wb[1] and b[2] == wb[2]) then
				is_in_black=is_in_black+1;
				break;
			end
		end
	end
	for _,b in ipairs(white) do
		for _,wb in ipairs(win_white) do
			if (b[1] == wb[1] and b[2] == wb[2]) then
				is_in_white=is_in_white+1;
				break;
			end
		end
	end
	return is_in_black, is_in_white;
end

function set_new_turn(t, gall, gblack, gwhite)
	local all = deepcopy(gall);
	local black = deepcopy(gblack);
	local white = deepcopy(gwhite);
	for bp, b in ipairs(black) do
		if t[1][1] == b[1] and t[1][2] == b[2] then
			table.remove(black, bp);
			for ap, a in ipairs(all) do
				if t[2][1] == a[1] and t[2][2] == a[2] then
					table.remove(all, ap);
					break;
				end
			end
			table.insert(black, t[2]);
			table.insert(all, t[1]);
			return all, black, white;
		end
	end
	for wp, w in ipairs(white) do
		if t[1][1] == w[1] and t[1][2] == w[2] then
			table.remove(white, wp);
			for ap, a in ipairs(all) do
				if t[2][1] == a[1] and t[2][2] == a[2] then
					table.remove(all, ap);
					break;
				end
			end
			table.insert(white, t[2]);
			table.insert(all, t[1]);
			return all, black, white;
		end
	end
	print('error!');
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function get_new_turns(black, white, all)
	local new_turn = {};
	local availible_cell = {};
	local black_x_diag = {};
	local black_y_diag = {};
	local white_x_diag = {};
	local white_y_diag = {};
	for _, b in ipairs(black) do
		table.insert(black_x_diag, b[1]);
		table.insert(black_y_diag, b[2]);
	end
	for _, w in ipairs(white) do
		table.insert(white_x_diag, w[1]);
		table.insert(white_y_diag, w[2]);
	end
	for _, cell in ipairs(all) do
		if ((inTable(cell[1], black_x_diag) and inTable(cell[2], white_y_diag)) or
			(inTable(cell[1], white_x_diag) and inTable(cell[2], black_y_diag))) then
		else
			table.insert(availible_cell, cell);
		end
	end
	for _, a in ipairs(availible_cell) do
		for _, b in ipairs(black) do
			if (b[1] == a[1] and b[2] ~= a[2]) or (b[1] ~= a[1] and b[2] == a[2]) then
				table.insert(new_turn, {b,a});
			end
		end
		for _, w in ipairs(white) do
			if (w[1] == a[1] and w[2] ~= a[2]) or (w[1] ~= a[1] and w[2] == a[2]) then
				table.insert(new_turn, {w,a});
			end
		end
	end
	--[[
	print('new turns')
	for _, p in ipairs(new_turn) do print_turn(p) end
	io.read();
	]]--
	--i find bug in forming turns its silly fix
	for ii, i in ipairs(new_turn) do
		for ij, j in ipairs(new_turn) do
			if (ii ~= ij and i[2][1] == j[2][1] and i[2][2] == j[2][2] and i[1][1] == j[1][1] ) then
				if i[1][2] < j[1][2] then
					table.remove(new_turn,ii)
				else 
					table.remove(new_turn,ij)
				end
			end
		end
	end

	return new_turn;
end

function print_turn(c)
	if (c == nil) then
		print 'empty turn'
		return
	end
	print('[' .. c[1][1] .. ',' .. c[1][2] .. ']->[' .. c[2][1] .. ',' .. c[2][2] .. ']') 
end
