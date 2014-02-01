grid_size = 40
indent_x = 100
-- playertext = love.graphics.newImage("ddd.png")
stay = {love.graphics.newImage("rr.png"), love.graphics.newImage("ll.png"), love.graphics.newImage("dd.png"), love.graphics.newImage("uu.png")}
move = {love.graphics.newImage("rd.png"),love.graphics.newImage("ru.png"),love.graphics.newImage("ld.png"),love.graphics.newImage("lu.png"),love.graphics.newImage("dr.png"),love.graphics.newImage("dl.png"),love.graphics.newImage("ur.png"),love.graphics.newImage("ul.png")}
bomb = love.graphics.newImage('bomb.png')
life = love.graphics.newImage('life.png')
function love.load()
	bgm = love.audio.newSource( 'bgm.mp3', 'stream' )
	bgm:play()
	expl_map1 = {}

	player = {
	name = "maybelinot", 
	x = 160,
	y = 60,
	max_bombs = 1,
	remaining_bombs = 1,
	range = 1,
	health = 3,
	speed = 150,
	speedx = 0,
	speedy = 0,
	invulnerability = 2
	}
	comp = {
	name = "Vally",
	x = 635,
	y = 535,
	max_bombs = 1,
	remaining_bombs = 1,
	range = 1,
	health = 3,
	speed = 150,
	speedx = 0,
	speedy = 0,
	invulnerability = 2
	}
	direction = 3
	direction2 = 1
	clock = 0
	clock1 = 0
	ways = {}
	Bombs = {}
	rem = {}
	map = {
			{8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8},
			{8, 0, 0, 7, 7, 7, 7, 7, 7, 7, 7, 7, 0, 0, 8},
			{8, 0, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 0, 8},
			{8, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8},
			{8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8},
			{8, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8},
			{8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8},
			{8, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8},
			{8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8},
			{8, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8},
			{8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8},
			{8, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8},
			{8, 0, 8, 7, 8, 7, 8, 7, 8, 7, 8, 7, 8, 0, 8},
			{8, 0, 0, 7, 7, 7, 7, 7, 7, 7, 7, 7, 0, 0, 8},
			{8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8}
	}
	for i = 1, #map do
		expl_map1[i] = table.copy(map[i])
	end
	game = true
	curb = 0
	curx = 13
	cury = 14
	u = 0
end

function love.update(dt)
	-- love.audio.rewind( )
	if not (love.keyboard.isDown("right") and love.keyboard.isDown("left")) then
		if love.keyboard.isDown("right") then
			player.speedx = player.speed
		end
		if love.keyboard.isDown("left") then
			player.speedx = -player.speed
		end
	end
	if not love.keyboard.isDown("right","left") or (love.keyboard.isDown("right") and love.keyboard.isDown("left")) then
		if player.speedx > 0 then
			player.speedx = math.floor(player.speedx/1.05)
		else
			player.speedx = math.ceil(player.speedx/1.05)
		end
	end

	if not (love.keyboard.isDown("up") and love.keyboard.isDown("down")) then
		if love.keyboard.isDown("up") then
			player.speedy = -player.speed
		end
		if love.keyboard.isDown("down") then
			player.speedy = player.speed
		end
	end
	if not love.keyboard.isDown("up","down") or (love.keyboard.isDown("up") and love.keyboard.isDown("down")) then
		if player.speedy > 0 then
			player.speedy = math.floor(player.speedy/1.1)
		else
			player.speedy = math.ceil(player.speedy/1.1)
		end
	end
	clock = clock + dt
	-- clock1 = clock1 + dt
	if player.invulnerability>0 then
		player.invulnerability = player.invulnerability - dt
	end
	if comp.invulnerability>0 then
		comp.invulnerability = comp.invulnerability - dt
	end
	local x = player.x + player.speedx * dt
	local y = player.y + player.speedy * dt
	grid_x = math.ceil((x - 100) / grid_size)
	grid_y = math.ceil(y / grid_size)

	local grid_old_r_x = math.ceil((player.x - 85) / grid_size)
	local grid_old_l_x = math.ceil((player.x - 115) / grid_size)
	local grid_old_u_y = math.ceil((player.y - 5) / grid_size)
	local grid_old_d_y = math.ceil((player.y + 25) / grid_size)

	local grid_new_r_x = math.ceil((x - 85) / grid_size)
	local grid_new_l_x = math.ceil((x - 115) / grid_size)
	local grid_new_u_y = math.ceil((y - 5) / grid_size)
	local grid_new_d_y = math.ceil((y + 25) / grid_size)

	getPills(grid_x, grid_y, player)

	if map[grid_old_r_x][grid_new_u_y] < 7 and map[grid_old_r_x][grid_new_d_y] < 7 and map[grid_old_l_x][grid_new_u_y] < 7 and map[grid_old_l_x][grid_new_d_y] < 7 then
		player.y = y
	end
	if map[grid_new_r_x][grid_old_u_y] < 7 and map[grid_new_l_x][grid_old_u_y] < 7 and map[grid_new_r_x][grid_old_d_y] < 7 and map[grid_new_l_x][grid_old_d_y] < 7 then
		player.x = x
	end
	wayGenerationOfComp(dt)

	for i = 1, #map do
		expl_map1[i] = table.copy(map[i])
	end
	for i = 1, table.getn(Bombs) do
		if Bombs[i].timer<0 then
			if Bombs[i].status == 'unexploded' then 
				Bombs[i].status = 'exploded'
				if Bombs[i].own == player.name then
					player.remaining_bombs = player.remaining_bombs + 1
					else comp.remaining_bombs = comp.remaining_bombs + 1
				end
			end
			expl_map1 = expl_cells(Bombs[i], expl_map1)
		end
		if Bombs[i].timer<-0.5 then
			table.insert(rem, i)
		end
		Bombs[i].timer = Bombs[i].timer - dt
	end
	for i = 1, #expl_map1 do
		for j = 1, #expl_map1[i] do
			if expl_map1[i][j]==-2 then
				local rand = math.random(100)
				map[i][j] = 0
				if rand<5 then
					map[i][j] = 1
				elseif rand<10 then
					map[i][j] = 2
				elseif rand<15 then
					map[i][j] = 3
				elseif rand<20 then
					map[i][j] = 4
				end
			elseif expl_map1[i][j]==-3 then
				map[i][j] = 0
			end
		end
	end
	for i = 1 , table.getn(rem) do
		table.remove(Bombs, rem[i])
	end
	rem = {}
end

function love.keypressed(key, unicode)
	if key == 'b' then
		AddBomb(player)
	end
	if f == false and key == 'escape' then
		love.load()
	end 
end

function AddBomb(whos)
	if whos.remaining_bombs > 0 then
		local f2 = true
		for i = 1, table.getn(Bombs) do 
			if Bombs[i].x == grid_x and Bombs[i].y == grid_y then 
				f2 = false
			end
		end
		if f2 then
			Bomb = {
			x = math.ceil((whos.x - 100)/grid_size),
			y = math.ceil(whos.y/grid_size),
			timer = 2,
			range = whos.range,
			own = whos.name,
			status = 'unexploded'
			}
			whos.remaining_bombs = whos.remaining_bombs - 1
			table.insert(Bombs, 1, Bomb)
		end
	end
end

function getPills(x, y, person)
	if map[x][y] == 1 then
		person.max_bombs = person.max_bombs + 1
		person.remaining_bombs = person.remaining_bombs + 1
	elseif map[x][y] == 2 then
		person.range = person.range + 1
	elseif map[x][y] == 3 then
		person.health = person.health + 1
	elseif map[x][y] == 4 then
		person.speed = person.speed + 25
	end
	map[x][y] = 0
end
--#############################################################################################--
-- Взрыв бомбы
function expl_cells(bomb, expl_map)
	local expl_grid_x = bomb.x
	local expl_grid_y = bomb.y
	local f_left = true
	local f_up = true
	local f_down = true
	local f_right = true
	local i 
	local k 
	for i = 0, bomb.range do

		f_right, expl_map = isBang(bomb, f_right, expl_grid_x + i, expl_grid_y, expl_map)

		f_left, expl_map = isBang(bomb, f_left, expl_grid_x - i, expl_grid_y, expl_map)

		f_down, expl_map = isBang(bomb, f_down, expl_grid_x, expl_grid_y + i, expl_map)

		f_up, expl_map = isBang(bomb, f_up, expl_grid_x, expl_grid_y - i, expl_map)			
	end
	-- expl_map[2][2] = -1
	return expl_map
end
-- Взрыв ячейки, генерация пилюль
function isBang (bomb, f, x, y, expl_map)
	if f == true and map[x][y] ~= 8 then 
		if map[x][y] == 7 then
			if bomb.timer<-0.5 then
				expl_map[x][y] = -2
			end
			f = false
		elseif map[x][y] >0 then
			expl_map[x][y] = -3
		else
			expl_map[x][y] = -1
			for i = 1, table.getn(Bombs) do 
				if Bombs[i].timer>0.1 and Bombs[i].x ==x and Bombs[i].y == y then 
					Bombs[i].timer = 0.1
				end
			end
		end
	else 
		f = false
	end
	return f, expl_map
end
-- Урон игрокам. Проверка конца игры
function isDownHealth(x,y)
	if grid_x==x and grid_y==y and player.invulnerability<0 then
		player.health = player.health - 1
		player.invulnerability = 2
	end
	if grid_comp_x==x and grid_comp_y==y and comp.invulnerability<0 then
		comp.health = comp.health - 1
		comp.invulnerability = 2
	end
	if player.health<1 or comp.health<1 then
		game = false
	end
end
--============================================================================================--
-- Создание карты ячеек находящихся под ударом
function unreal_expl_cells(expl_map, bomb)
	local expl_grid_x = bomb.x
	local expl_grid_y = bomb.y
	local f_left = true
	local f_up = true
	local f_down = true
	local f_right = true
	local i 
	local count = 0
	for i = 0, bomb.range do

		f_right, expl_map = unreal_isBang(f_right, expl_grid_x + i, expl_grid_y, expl_map)

		f_left, expl_map = unreal_isBang(f_left, expl_grid_x - i, expl_grid_y, expl_map)

		f_down, expl_map = unreal_isBang(f_down, expl_grid_x, expl_grid_y + i, expl_map)

		f_up, expl_map = unreal_isBang(f_up, expl_grid_x, expl_grid_y - i, expl_map)			
	end
	return expl_map
end
-- Находится ли ячейка под ударом
function unreal_isBang (f, x, y, expl_map)
	if f == true and map[x][y] ~= 8 then 
		if map[x][y] ~= 7 then
			expl_map[x][y] = -1
		else f = false
		end
	else f = false
	end
	return f, expl_map
end
--============================================================================================--
-- кол-во взорваных блоков
function count_expl_cells(expl_grid_x, expl_grid_y, range)
	local f_left = true
	local f_up = true
	local f_down = true
	local f_right = true
	local i 
	count = 0
	for i = 0, range do

		f_right, count = count_isBang(f_right, expl_grid_x + i, expl_grid_y, count)

		f_left, count = count_isBang(f_left, expl_grid_x - i, expl_grid_y, count)

		f_down, count = count_isBang(f_down, expl_grid_x, expl_grid_y + i, count)

		f_up, count = count_isBang(f_up, expl_grid_x, expl_grid_y - i, count)			
	end
	return count
end
-- взорван ли блок
function count_isBang (f, x, y, count)
	if f == true and map[x][y] ~= 8 then
		if map[x][y] == 7 then
			count = count + 1
			f = false
		end
	else f = false
	end
	return f, count
end
--============================================================================================--
-- кол-во взорваных блоков
function dmg_expl_cells(expl_grid_x, expl_grid_y, range)
	local f_left = true
	local f_up = true
	local f_down = true
	local f_right = true
	local i 
	f1 = false
	for i = 0, range do

		f_right, f1 = dmg_isBang(f_right, expl_grid_x + i, expl_grid_y, f1)

		f_left, f1 = dmg_isBang(f_left, expl_grid_x - i, expl_grid_y, f1)

		f_down, f1 = dmg_isBang(f_down, expl_grid_x, expl_grid_y + i, f1)

		f_up, f1 = dmg_isBang(f_up, expl_grid_x, expl_grid_y - i, f1)			
	end
	return f1
end
-- взорван ли блок
function dmg_isBang (f, x, y, f1)
	if f == true and map[x][y] ~= 8 then
		if map[x][y] ~= 7 and x == grid_x and y == grid_y then
			f1 = true
		end
	else f = false
	end
	return f, f1
end
--#############################################################################################--

-- Ф-ция определения текущего пути('спросить у Марка нужна ли отдельная')
function testMap(ways)
	local i
	local expl_map = {}
	for i = 1, #map do
		expl_map[i] = table.copy(map[i])
	end
	for i = 1, #Bombs do
		expl_map = unreal_expl_cells(expl_map, Bombs[i])
	end

	current_way={{},{},{},{},{},{}} -- изменить на локальную, вывести в return
	local cond = false
	if expl_map[ways[1][1][1]][ways[1][1][2]]==-1 then    -- проверка стоит ли комп в точке взрыва
		for i = 1, #ways-1 do
			if expl_map[ways[i][#ways[i]][1]][ways[i][#ways[i]][2]]~=-1 and expl_map1[ways[i][2][1]][ways[i][2][2]]~=-1 and #ways[i]<=#current_way then
				current_way = table.copy(ways[i])
				goal = false
				cond = true
			end
		end
	else 												  -- проверка есть ли рядом пилюли 
		for i = 1, #ways do
			if i==#ways or (expl_map[ways[i][2][1]][ways[i][2][2]]~=-1 and expl_map1[ways[i][2][1]][ways[i][2][2]]~=-1) then
				if map[ways[i][#ways[i]][1]][ways[i][#ways[i]][2]]~=0 and #ways[i]<=#current_way then 
					current_way = table.copy(ways[i])
					goal = false
					cond = true
				end
			end
		end
		if cond == false then
			for i = 1, #ways do
				if i==#ways or (expl_map[ways[i][2][1]][ways[i][2][2]]~=-1 and expl_map1[ways[i][2][1]][ways[i][2][2]]~=-1) then
					if dmg_expl_cells(ways[i][#ways[i]][1], ways[i][#ways[i]][2], comp.range)==true and #ways[i]<=#current_way then -- изменить!!!!
						current_way = table.copy(ways[i])
						goal = true
						cond = true
					end
				end
			end
		end
	end
	if cond==false then			-- проверка на кол-во взорванных блоков
		local cur_count = 0
		local cond = true
		for i = 1, #ways do
			if i==#ways or (expl_map[ways[i][2][1]][ways[i][2][2]]~=-1 and expl_map1[ways[i][2][1]][ways[i][2][2]]~=-1) then
				count = count_expl_cells(ways[i][#ways[i]][1], ways[i][#ways[i]][2], comp.range) -- изменить!!!!
				if count>cur_count then
					cond = false
					current_way = table.copy(ways[i])
					goal = true
					cur_count = count
				elseif count==cur_count then
					if #current_way > #ways[i] then
						cond = false
						current_way = table.copy(ways[i])
						goal = true
					end
				end
			end
		end
		if cond == true then 
			current_way = table.copy(ways[#ways])
		end
	end
	return current_way
end

-- Главная ф-ция генерации пути компьютера
function wayGenerationOfComp(dt)
	grid_comp_x = math.ceil((comp.x-100)/grid_size) -- изменить на координаты компа
	grid_comp_y = math.ceil(comp.y/grid_size)
	if curx ~= grid_comp_x or cury ~= grid_comp_y or table.getn(Bombs)~= curb then
		ways = {{{grid_comp_x, grid_comp_y}}}
		possibilityCompWay({{grid_comp_x,grid_comp_y}})
		-- cur_comp_status = table.copy(comp)
		curx = grid_comp_x
		cury = grid_comp_y
		curb = table.getn(Bombs)
		getPills(grid_comp_x, grid_comp_y, comp)
		cur_way = testMap(ways)
		if  goal==true and current_way[#current_way][1] == grid_comp_x and current_way[#current_way][2] == grid_comp_y then
			AddBomb(comp) --- изменить на компа
		end
	end
	CompMovement(cur_way,grid_comp_x,grid_comp_y,dt)
end

-- Поиск всех возможных, неповторяющихся и (наиболее коротких'доработать wayCreation') путей в пределах n клеток
function possibilityCompWay(way)
	local xc = way[#way][1]
	local yc = way[#way][2]
	local m1 = true
	local coords = {{xc+1, yc}, {xc, yc+1}, {xc, yc-1}, {xc-1, yc}}
	way, m1 = RandomizeCompWay(way, coords, m1)

	if m1==true or #way>4 then 
		table.remove(way)
	end


	if #way >=1 then 
		possibilityCompWay(way)
	end
end

-- Эффект случайного выбора направления с помощью псевдорандома для создания пути
function RandomizeCompWay(way, coords, m1)
	local rand = math.ceil(math.random(1, #coords))
	if m1 == true and map[coords[rand][1]][coords[rand][2]]~=8 and map[coords[rand][1]][coords[rand][2]]~= 7 then
		table.insert(way, table.copy(coords[rand]))
		m1, way = wayCreation(m1, way)
	end
	table.remove(coords, rand)
	if #coords>0 then 
		way, m1 = RandomizeCompWay(way, coords, m1)
	end
	return way, m1
end

-- Вспомогательная ф-ция копирования таблиц
function table.copy(t)
	local t2 = {}
	for k,v in pairs(t) do
		t2[k] = v
	end
	return t2
end

-- Создание след ячейки пути
function wayCreation(m1, way)
	local m = true
	local i
	local h
	if #way>2 then
		if way[#way-2][1]==way[#way][1] and way[#way-2][2]==way[#way][2] then
			m=false
		end
	end
	if m==true then 
		for i = 1, #ways do
			local m2 = true
			if #way==#ways[i] then
				for h = 2, #way do
					if m2==true and (way[h][1]~=ways[i][h][1] or way[h][2]~=ways[i][h][2]) then
						m2 = false
					end
					-- if way[h][1]==ways[i][h][1] and way[h][2]==ways[i][h][2] and (way[h-1][1]~=ways[i][h-1][1] or way[h-1][2]~=ways[i][h-1][2]) then
					-- 	m=false
					-- end     -- запустить если #way>5
				end
			else m2=false 
			end
			if m2==true then m=false end
		end
	end
	if m == true then
		w = table.copy(way)
		table.insert(ways, 1, w)
		m1 = false
	else
		table.remove(way)
	end
	return m1, way
end

function CompMovement(way,grid_comp_x,grid_comp_y,dt)
	local grid_old_r_x = math.ceil((comp.x - 85) / grid_size)
	local grid_old_l_x = math.ceil((comp.x - 115) / grid_size)
	local grid_old_u_y = math.ceil((comp.y - 5) / grid_size)
	local grid_old_d_y = math.ceil((comp.y + 25) / grid_size)

	if #way==1 then
		if comp.speedx > 0 then
			comp.speedx = math.floor(comp.speedx/1.1)
		else
			comp.speedx = math.ceil(comp.speedx/1.1)
		end
		if comp.speedy > 0 then
			comp.speedy = math.floor(comp.speedy/1.1)
		else
			comp.speedy = math.ceil(comp.speedy/1.1)
		end
	else
		if grid_comp_x > way[2][1] then
			comp.speedx = -comp.speed
		elseif grid_comp_x < way[2][1] then
			comp.speedx = comp.speed
		else
			if grid_old_l_x<grid_comp_x then
				comp.speedx = comp.speed
			end
			if grid_old_r_x>grid_comp_x then
				comp.speedx = -comp.speed
			end
			if comp.speedx > 0 then
				comp.speedx = math.floor(comp.speedx/1.05)
			else
				comp.speedx = math.ceil(comp.speedx/1.05)
			end
		end
		if grid_comp_y > way[2][2] then
			comp.speedy = -comp.speed
		elseif grid_comp_y < way[2][2] then
			comp.speedy = comp.speed
		else
			if grid_old_u_y<grid_comp_y then
				comp.speedy = comp.speed
			end
			if grid_old_d_y>grid_comp_y then
				comp.speedy = -comp.speed
			end
			if comp.speedy > 0 then
				comp.speedy = math.floor(comp.speedy/1.05)
			else
				comp.speedy = math.ceil(comp.speedy/1.05)
			end
		end
	end
	coordx = comp.x + comp.speedx * dt
	coordy = comp.y + comp.speedy * dt

	local grid_new_r_x = math.ceil((coordx - 85) / grid_size)
	local grid_new_l_x = math.ceil((coordx - 115) / grid_size)
	local grid_new_u_y = math.ceil((coordy - 5) / grid_size)
	local grid_new_d_y = math.ceil((coordy + 25) / grid_size)
	if map[grid_old_r_x][grid_new_u_y] < 7 and map[grid_old_r_x][grid_new_d_y] < 7 and map[grid_old_l_x][grid_new_u_y] < 7 and map[grid_old_l_x][grid_new_d_y] < 7 then
		comp.y = coordy
	end
	if map[grid_new_r_x][grid_old_u_y] < 7 and map[grid_new_l_x][grid_old_u_y] < 7 and map[grid_new_r_x][grid_old_d_y] < 7 and map[grid_new_l_x][grid_old_d_y] < 7 then
		comp.x = coordx
	end
end
-- Прорисовка
function love.draw()
	if game==true then
		for i = 1, #map do
			for j = 1, #map[i] do
				if map[i][j] == 8 then
					love.graphics.setColor(math.random(255),math.random(255),math.random(255))
					love.graphics.polygon('fill', indent_x + grid_size*(i - 1) + 1, grid_size*(j - 1) + 1,indent_x + grid_size*i - 1, grid_size*(j - 1) + 1, indent_x + grid_size*i - 1, grid_size*j - 1, indent_x + grid_size*(i - 1) + 1, grid_size*j - 1)
				elseif map[i][j] == 7 then
					love.graphics.setColor(math.random(255),math.random(255),math.random(255))
					love.graphics.circle( 'fill', 80 + grid_size*i, grid_size*j - 20, 10, 150 )
				elseif map[i][j] == 1 then
					love.graphics.setColor(50,50,200)
					love.graphics.printf('+bomb', 80 + grid_size*i, grid_size*j - 20, 0, 'center' )
				elseif map[i][j] == 2 then
					love.graphics.setColor(50,50,200)
					love.graphics.printf('+range', 80 + grid_size*i, grid_size*j - 20, 0, 'center' )
				elseif map[i][j] == 3 then
					love.graphics.setColor(255,255,255)
					love.graphics.draw(life, 60 + grid_size*i, grid_size*j - 40, 0)
				elseif map[i][j] == 4 then
					love.graphics.setColor(50,50,200)
					love.graphics.printf('+speed', 60 + grid_size*i, grid_size*j - 40, 0, 'center' )
				end
			end
		end

		love.graphics.setColor(255,255,255)
		direction = sprite(player, direction)
		love.graphics.setColor(255,120,120)
		direction2 = sprite(comp, direction2)
		love.graphics.setColor(255,255,255)

		for i = 1, table.getn(Bombs) do
			if Bombs[i].timer>0 then
				love.graphics.draw(bomb, Bombs[i].x*40 + 60, Bombs[i].y*40 - 40, 0)
			end
		end
		u = 0
		for i = 1, #expl_map1 do
			for j = 1, #expl_map1[i] do
				if expl_map1[i][j]==-1 then
					u = u+1
					love.graphics.circle('fill' , i*40+80, j*40 - 20, 6, 15)
					isDownHealth(i,j)
				end
			end
		end
		love.graphics.printf('HEALTH: ', 50, 50, 0, 'center')
		love.graphics.printf( player.health, 80, 50, 0, 'center')
		love.graphics.printf('BOMBS: ', 50, 70, 0, 'center')
		love.graphics.printf( player.remaining_bombs, 80, 70, 0, 'center')
		love.graphics.printf('RANGE: ', 50, 90, 0, 'center')
		love.graphics.printf( player.range, 80, 90, 0, 'center')
		love.graphics.printf('HEALTH: ', 750, 450, 0, 'center')
		love.graphics.printf( comp.health, 780, 450, 0, 'center')
		love.graphics.printf('BOMBS: ', 750, 470, 0, 'center')
		love.graphics.printf( comp.remaining_bombs, 780, 470, 0, 'center')
		love.graphics.printf('RANGE: ', 750, 490, 0, 'center')
		love.graphics.printf( comp.range, 780, 490, 0, 'center')

		-- for j = 1, #current_way do
		-- 	love.graphics.circle('fill' , current_way[j][1]*40+80, current_way[j][2]*40 - 20, 2, 15)
		-- end
	else
		if player.health<1 then
			love.graphics.printf('GAME OVER', 400, 300, 0, 'center')
		else
			love.graphics.printf('YOU WIN', 400, 300, 0, 'center')
		end
	end
end

function sprite(person, direction)
	local Vx = math.abs(person.speedx)
	local Vy = math.abs(person.speedy)
	local f1 = true
	if clock >0.25 then
		clock = 0
		condition = not condition
	end
	if person.speedx>0 and Vx>Vy then
		direction = 1 -- right
	elseif person.speedx<0 and Vx>Vy then
		direction = 2 -- left
	elseif person.speedy>0 and Vy>Vx then
		direction = 3 -- down
	elseif person.speedy<0 and Vy>Vx then
		direction = 4 -- up
	else 
		f1 = false
	end
	if f1 == true then
		if condition == true then
			love.graphics.draw(move[direction*2], person.x - 15, person.y - 30, 0)
		else
			love.graphics.draw(move[(direction*2 - 1)], person.x - 15, person.y - 30, 0)
		end
	else
		love.graphics.draw(stay[direction], person.x - 15, person.y - 30, 0)
	end
	return direction
end