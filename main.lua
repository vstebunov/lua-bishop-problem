require "utils"
require "graphics"
local gblack = {{0,3}, {1,2}, {2,1}, {3,0}};
local gwhite = {{4,7}, {5,6}, {6,5}, {7,4}};
local gall = {{1,4}, {2,3}, {2,5}, {3,2}, {3,4}, {3,6}, {4,1}, {4,3}, {4,5}, {5,2}, {5,4}, {6,3}};
local closed = {}
local start_time = os.clock()
--[[				all    black   white   state turn level(h(x)) g(x)]]--
local new_states = {{gall, gblack, gwhite, nil,  nil, 0,         0}}
local win_state = {}
repeat
	local state = table.remove(new_states, 1)
	io.write("\rlevel:", state[6], "\t\tg(x)=", state[7])
	table.insert(closed, state)
	local in_b, in_w = is_win(state[2], state[3])
	if in_b == 4 and in_w == 4 then
		print('win')
		win_state = state
		break
	end
	local new_turns = get_new_turns(state[2], state[3], state[1])
	for _, turn in pairs(new_turns) do 
		local state_all, state_black, state_white = set_new_turn(turn, state[1], state[2], state[3])	
		if (not is_closed_state(closed,{state_all, state_black, state_white}) and state[6] + 1 < 64) then 
			local new_b, new_w = is_win(state_black, state_white)
			table.insert(new_states, {state_all, state_black, state_white, state, turn, state[6] + 1, new_b + new_w})
		end
	end
	table.sort(new_states, function(as, bs) return (as[7]) > (bs[7]) end)
until (#new_states <= 0)
print(string.format("elapsed time: %.2f\n", os.clock() - start_time))
local turns = {}
local i = 0
repeat
	draw_all(win_state[2],win_state[3], i) 
	i = i + 1
	table.insert(turns, win_state[5])
	win_state = win_state[4]
until (win_state == nil)
print('turns:', #turns)
for _, p in pairs(turns) do
	if (p ~= nil) then
		print_turn(p)
	end
end
io.read();
