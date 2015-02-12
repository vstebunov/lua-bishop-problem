require "gd"
local transit = { [{3,0}] = {1,1}, [{3,2}] = {2,2}, [{3,4}] = {3,3}, [{3,6}] = {4,4}, [{2,1}] = {1,2}, [{2,3}] = {2,3}, [{2,5}] = {3,4},
				  [{1,2}] = {1,3}, [{1,4}] = {2,4}, [{0,3}] = {1,4}, [{4,1}] = {2,1}, [{4,3}] = {3,2}, [{4,5}] = {4,3}, [{4,7}] = {5,4},
				  [{5,2}] = {3,1}, [{5,4}] = {4,2}, [{5,6}] = {5,3}, [{6,3}] = {4,1}, [{6,5}] = {5,2}, [{7,4}] = {5,1} }
function draw_all(black, white, i)
	local img = gd.createTrueColor(10 * 2 + 5 * 20, 10 * 2 + 4 * 20)
	local black_color = img:colorAllocate(0,0,0)
	local gray_color = img:colorAllocate(128,128,128)
	local light_color = img:colorAllocate(192,192,192)
	local white_color = img:colorAllocate(255,255,255)
	img:fill(0,0,white_color)
	img:filledRectangle(10,10,10 + 5 * 20,10 + 4 * 20, light_color)
	img:rectangle(10,10,10 + 5 * 20,10 + 4 * 20, black_color)
	local offset = 0
	for j = 0,3 do
		for i = 0,5 - offset * 2,2 do 
			img:filledRectangle(10 + (20 * i) + (20 * offset),10 + (20 * j),10 +(20 * i) + (20 * offset) + 20,10 + 20 + (20 *j),gray_color)
		end
		if offset == 0 then offset = 1 else offset = 0 end
	end
	local x,y = -1, -1
	for _,b in ipairs(black) do
		for i,t in pairs(transit) do
			if b[1] == i[1] and b[2] == i[2] then x = t[1]; y = t[2] end
		end
		img:filledEllipse( 10 + (20 * x) - 10, 10 + (20 * y) - 10, 20, 20, black_color)
	end
	for _,w in ipairs(white) do
		for i,t in pairs(transit) do
			if w[1] == i[1] and w[2] == i[2] then x = t[1]; y = t[2] end
		end
		img:filledEllipse( 10 + (20 * x) - 10, 10 + (20 * y) - 10, 20, 20, white_color)
	end
	img:png("output" .. i .. ".png")
end
