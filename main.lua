require "utils"
require "gd"
local gblack = {{0,3}, {1,2}, {2,1}, {3,0}};
local gwhite = {{4,7}, {5,6}, {6,5}, {7,4}};
local gall = {{1,4}, {2,3}, {2,5}, {3,2}, {3,4}, {3,6}, {4,1}, {4,3}, {4,5}, {5,2}, {5,4}, {6,3}};

function draw_all()
	local img = gd.createTrueColor(10 * 2 + 5 * 20, 10 * 2 + 4 * 20)
	local black_color = img:colorAllocate(0,0,0)
	local white_color = img:colorAllocate(255,255,255)
	img:fill(0,0,white_color)
	img:rectangle(10,10,10 + 5 * 20,10 + 4 * 20, black_color)
	local offset = 0
	for j = 0,3 do
		for i = 0,5 - offset * 2,2 do 
			img:filledRectangle(10 + (20 * i) + (20 * offset),10 + (20 * j),10 +(20 * i) + (20 * offset) + 20,10 + 20 + (20 *j),black_color)
		end
		if offset == 0 then offset = 1 else offset = 0 end
	end
	img:png("output.png")
end

draw_all() 
exit(0)

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
			table.insert(new_states, {state_all, state_black, state_white, state, turn, state[6] + 1, in_b + in_w})
		end
	end
	table.sort(new_states, function(as, bs) return (as[7]) > (bs[7]) end)
until (#new_states <= 0)
print(string.format("elapsed time: %.2f\n", os.clock() - start_time))
local turns = {}
repeat
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
