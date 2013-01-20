lg = love.graphics
local INIT_X = 50
local INIT_Y = 50
local canvas;
SCENE_WIDTH = 800
SCENE_HEIGHT = 400
local snake = {head={x=INIT_X, y=INIT_Y}, queue={}}
dx = 10
dy = 10
currentDir = ''

cellcopy = function ( cell )
  return {x=cell.x, y=cell.y}
end

function expand_snake( s )
  queueSize = table.getn(s.queue)
  print("Current queueSize=" .. queueSize)
  if queueSize < 1 then
    s.queue[1] = cellcopy(s.head)
  else
    s.queue[queueSize+1] = cellcopy(s.queue[queueSize])
  end
end

function move_snake( snake )
  if table.getn(snake.queue) >= 2 then
    for i=table.getn(snake.queue),2,-1 do
      snake.queue[i] = cellcopy(snake.queue[i-1])
    end
  end
  if table.getn(snake.queue) >= 1 then
    snake.queue[1] = cellcopy(snake.head)
  end
  directions[currentDir](snake)
end

function love.load()
  lg.setColor(255, 0, 0)
  lg.rectangle('fill', 0, 0, SCENE_WIDTH, SCENE_HEIGHT)
end

function up(s) 
  s.head.y = (s.head.y - dy) % SCENE_HEIGHT
  if(s.head.y <= -30) then s.head.y = SCENE_HEIGHT - 30 end
end
function down(s) 
  s.head.y = (s.head.y + dy) % SCENE_HEIGHT
end
function left(s) 
  s.head.x = (s.head.x - dx) % SCENE_WIDTH
  if(s.head.x <= -30) then s.head.x = SCENE_WIDTH - 30 end
end
function right(s) 
  s.head.x = (s.head.x + dx) % SCENE_WIDTH
end

directions = {up= up, down= down, right=right, left= left}

function love.keypressed(key, unicode) 
  print("Key pressed: " .. "(" .. key .. "," .. unicode .. ")")
  if directions[key] then
    currentDir = key
  end
  return false
end
local myTimer = 0
local myTimer2 = 0
function love.update(dt)
  myTimer2 = myTimer2 + dt
  myTimer = myTimer + dt
  -- Spawn a new piece of the snake every 1 second
  if myTimer > 1 then
    myTimer = 0
    expand_snake(snake)
  end
  -- Animation occurs every 0.1 second
  if myTimer2 > 0.1 then
    myTimer2 = 0
    if directions[currentDir] then
      move_snake(snake)
    end
  end
end

function draw_snake( s )
  lg.setColor(255, 0, 0) -- head in red
  lg.rectangle('fill', s.head.x, s.head.y, 10, 10)
  lg.setColor(255, 255, 0) -- Queue in yellow
  for i,v in ipairs(s.queue) do
    lg.rectangle('fill', v.x, v.y, 10, 10)
  end
end

love.draw = function() 
  lg.setColor(0, 255, 0) -- Scene in green
  love.graphics.rectangle('fill', 0, 0, SCENE_WIDTH, SCENE_HEIGHT)
  draw_snake(snake)
end

