-- Everything we need to know about the current state of the bal.
ball = {
  -- The position of the center of the ball in pixels.
  position = { x = 225, y = 135 },
  
  -- The speed of the ball in pixels per second. (Technically, this should be called 'velocity', but
  -- let's not be pedantic.)
  speed = { x = -100, y = 0 },
  
  -- The radius of the ball in pixels. Note that the radius is half of the entire width of the ball
  -- (which is called the diameter). So, while the ball's sprite is 24 pixels by 24 pixels, the
  -- radius is only 12 pixels. Most of our calculations require the radius, so it's more convenient
  -- to store the radius than the diameter.
  radius = 12
}

-- Everything we need to know about the current state of the playing field.
field = {
  -- The coordinates of the upper left corner of the playing field.
  left = 0, top = 0,
  
  -- The coordinates of the bottom right corner of the playing field.
  right = 1280, bottom = 720,
  
  -- The blocks in the playing field.
  blocks = {
    { x = 120, y = 120, color = { 255,   0, 0 } },
    { x = 420, y = 120, color = {   0, 255, 0 } }
  }
}

function love.load()
  -- Set the resolution at which the game will run.
  love.window.setMode(1280, 720, { fullscreen = false, vsync = false })
  
  -- Load all the sprites we need. 'Sprite' is basically game dev speak for 'image'.
  sprites = {}
  sprites.ball = love.graphics.newImage("assets/ball.png")
  sprites.block = love.graphics.newImage("assets/block.png")
end

function love.update(time)
  -- Move the ball, taking its speed into account.
  ball.position.x = ball.position.x + ball.speed.x * time
  ball.position.y = ball.position.y + ball.speed.y * time
  
  -- Calculcate the coordinates of the edges of the ball. We need these values when doing collision
  -- detection.
  ball.left = ball.position.x - ball.radius
  ball.right = ball.position.x + ball.radius
  ball.top = ball.position.y - ball.radius
  ball.bottom = ball.position.y + ball.radius
  
  -- Did the ball hit the left side of the playing field?
  if ball.left <= field.left then
    -- Yes, make the ball move to the right.
    ball.speed.x = -ball.speed.x
    
    -- The ball (probably) moved a little beyond the left side of the playing field. Move the ball
    -- back into the field.
    local distance = field.left - ball.left
    ball.position.x = ball.position.x + 2 * distance
  end
  
  -- Did the ball hit the right side of the playing field?
  if ball.right >= field.right then
    -- Yes, make the ball move to the left.
    ball.speed.x = -ball.speed.x
    
    -- The ball (probably) moved a little beyond the right side of the playing field. Move the ball
    -- back into the field.
    local distance = ball.right - field.right
    ball.position.x = ball.position.x - 2 * distance
  end
  
  -- Did the ball hit the top side of the playing field?
  if ball.top <= field.top then
    -- Yes, make the ball move to the bottom.
    ball.speed.y = -ball.speed.y
    
    -- The ball (probably) moved a little beyond the top side of the playing field. Move the ball
    -- back into the field.
    local distance = field.left - ball.top
    ball.position.y = ball.position.y + 2 * distance
  end
  
  -- Did the ball hit the bottom side of the playing field?
  if ball.bottom >= field.bottom then
    -- Yes, make the ball move to the top.
    ball.speed.y = -ball.speed.y
    
    -- The ball (probably) moved a little beyond the top side of the playing field. Move the ball
    -- back into the field.
    local distance = ball.bottom - field.bottom
    ball.position.y = ball.position.y - 2 * distance
  end
  
  -- Check if the ball collides with any of the blocks.
  for _, block in ipairs(field.blocks) do
    -- Calculate the coordinates of the edges of the block.
    local left = block.x
    local right = block.x + sprites.block:getWidth()
    local top = block.y
    local bottom = block.y + sprites.block:getHeight()
    
    -- Did the ball hit the left side of the block?
    if ball.right >= left and ball.left <= left and ball.position.y >= top and ball.position.y <= bottom then
      -- Yes, make the ball move to the left.
      ball.speed.x = -ball.speed.x
      
      -- The ball (probably) moved a little beyond the left side of the block. Move the ball
      -- back so it doesn't overlap the block.
      local distance = ball.right - left
      ball.position.x = ball.position.x - 2 * distance
    end
    
    -- Did the ball hit the right side of the block?
    if ball.left <= right and ball.right >= right and ball.position.y >= top and ball.position.y <= bottom then
      -- Yes, make the ball move to the right.
      ball.speed.x = -ball.speed.x
      
      -- The ball (probably) moved a little beyond the right side of the block. Move the ball
      -- back so it doesn't overlap the block.
      local distance = right - ball.left
      ball.position.x = ball.position.x + 2 * distance
    end
    
    -- Did the ball hit the bottom left corner of the block?
    local dx = ball.position.x - left
    local dy = ball.position.y - bottom
    local distance = math.sqrt(dx * dx + dy * dy)   -- Pythagoras
    
    if distance < ball.radius then
      -- Yes, make the ball move to the bottom left while keeping the speed the same.
      local speed = math.sqrt(ball.speed.x * ball.speed.x + ball.speed.y * ball.speed.y)    -- Pythagoras, again!
      ball.speed.x = -speed * math.sqrt(2)
      ball.speed.y = speed * math.sqrt(2)
    end
  end
end

function love.draw()
  -- Draw the blocks.
  for _, block in ipairs(field.blocks) do
    love.graphics.setColor(block.color)
    love.graphics.draw(sprites.block, block.x, block.y)
  end
  
  -- Set the color back to white, otherwise the rest of the sprites will have the same color as the
  -- block that was drawn last.
  love.graphics.setColor(255, 255, 255, 255)
  
  -- We store the position of the center of the ball, but when drawing a sprite, Löve wants to know
  -- the position of the upper left corner, so we translate the position before drawing.
  local x = ball.position.x - ball.radius
  local y = ball.position.y - ball.radius
  
  -- Draw the sprite of the ball.
  love.graphics.draw(sprites.ball, x, y)
end