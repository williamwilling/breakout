require "collision"

-- Everything we need to know about the current state of the ball.
ball = {
  -- The position of the center of the ball in pixels.
  position = { x = 152, y = 180 },
  
  -- The speed of the ball in pixels per second. (Technically, this should be called 'velocity', but
  -- let's not be pedantic.)
  speed = { x = 40, y = 200 },
  
  -- The radius of the ball in pixels. Note that the radius is half of the entire width of the ball
  -- (which is called the diameter). So, while the ball's sprite is 24 pixels by 24 pixels, the
  -- radius is only 12 pixels. Most of our calculations require the radius, so it's more convenient
  -- to store the radius than the diameter.
  radius = 12
}

-- Everything we need to know about the current state of the paddle.
paddle = {
  -- The position of the upper left corner of the paddle in pixels.
  x = 604, y = 680,
  
  -- The size of the paddle in pixels.
  width = 72, height = 48,
  
  -- The speed with which the paddle moves in pixels per second.
  speed = 200
}

-- Everything we need to know about the current state of the playing field.
field = {
  -- The coordinates of the upper left corner of the playing field.
  left = 0, top = 0,
  
  -- The coordinates of the bottom right corner of the playing field.
  right = 1280, bottom = 720,
  
  -- The blocks in the playing field.
  -- Note that the width and the height of the blocks are used for collision detection, but have no
  -- effect on the block's sprite.
  blocks = {
    { x = 120, y = 120, width = 48, height = 24, color = { 255,   0, 0 } },
    { x = 120, y = 240, width = 48, height = 24, color = {   0, 255, 0 } },
    { x = 250, y = 120, width = 48, height = 24, color = { 255,   0, 0 } },
    { x = 250, y = 240, width = 48, height = 24, color = {   0, 255, 0 } }
  }
}

function love.load()
  -- Set the resolution at which the game will run.
  love.window.setMode(1280, 720, { fullscreen = false, vsync = false })
  
  -- Load all the sprites we need. 'Sprite' is basically game dev speak for 'image'.
  sprites = {}
  sprites.ball = love.graphics.newImage("assets/ball.png")
  sprites.block = love.graphics.newImage("assets/block.png")
  sprites.paddle = love.graphics.newImage("assets/paddle.png")
end

function love.update(time)
  -- Move the paddle, based on the player's input.
  if love.keyboard.isDown("left") then
    paddle.x = paddle.x - paddle.speed * time
    
    -- Make sure the paddle doesn't leave the playing field.
    if paddle.x < field.left then
      paddle.x = field.left
    end
  end
  
  if love.keyboard.isDown("right") then
    paddle.x = paddle.x + paddle.speed * time
    
    -- Make sure the paddle doesn't leave the playing field.
    if paddle.x + paddle.width > field.right then
      paddle.x = field.right - paddle.width
    end
  end
    
  -- Move the ball, taking its speed into account.
  ball.position.x = ball.position.x + ball.speed.x * time
  ball.position.y = ball.position.y + ball.speed.y * time
  
  -- Calculcate the coordinates of the edges of the ball. We need these values when doing collision
  -- detection.
  ball.left = ball.position.x - ball.radius
  ball.right = ball.position.x + ball.radius
  ball.top = ball.position.y - ball.radius
  ball.bottom = ball.position.y + ball.radius
  
  -- Bounce the ball off the sides of the playing field.
  bounce_inside(ball, field)
  
  -- Bounce the ball off the paddle.
  bounce(ball, paddle)
  
  -- Check if the ball collides with any of the blocks.
  for _, block in ipairs(field.blocks) do
    -- Bounce the ball off the sides and corners of the block.
    bounce(ball, block)
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
  
  -- Draw the sprite of the paddle.
  love.graphics.draw(sprites.paddle, paddle.x, paddle.y)
end