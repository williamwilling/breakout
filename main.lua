require "ball"
require "collision"

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
  -- The strength indicates how many hits it takes to destroy the block. Hits indicates how many
  -- hits the block has received.
  blocks = {
    { x = 120, y = 120, width = 48, height = 24, strength = 3, hits = 0, color = { 255,   0,   0 } },
    { x = 120, y = 240, width = 48, height = 24, strength = 3, hits = 0, color = {   0, 255,   0 } },
    { x = 120, y = 360, width = 48, height = 24, strength = 3, hits = 0, color = {   0,   0, 255 } },
    { x = 250, y = 120, width = 48, height = 24, strength = 3, hits = 0, color = { 255,   0,   0 } },
    { x = 250, y = 240, width = 48, height = 24, strength = 2, hits = 0, color = {   0, 255,   0 } },
    { x = 250, y = 360, width = 48, height = 24, strength = 2, hits = 0, color = {   0,   0, 255 } }
  }
}

function love.load()
  -- Initialize the random number generator.
  math.randomseed(os.time())
  
  -- Set the resolution at which the game will run.
  love.window.setMode(1280, 720, { fullscreen = false, vsync = false })
  
  -- Load all the sprites we need. 'Sprite' is basically game dev speak for 'image'.
  sprites = {}
  sprites.ball = love.graphics.newImage("assets/ball.png")
  sprites.block = love.graphics.newImage("assets/block.png")
  sprites.block_damaged = love.graphics.newImage("assets/block_damaged.png")
  sprites.block_almost_gone = love.graphics.newImage("assets/block_almost_gone.png")
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
  
  if love.keyboard.isDown(" ") then
    ball:launch()
  end
  
  ball:update(time, field, paddle)
end

function love.draw()
  -- Draw the blocks.
  for _, block in ipairs(field.blocks) do
    if not block.destroyed then
      love.graphics.setColor(block.color)
      
      -- Has the block been hit?
      if block.hits == 0 then
        -- No, draw an undamaged block.
        love.graphics.draw(sprites.block, block.x, block.y)
      elseif block.strength - block.hits == 1 then
        -- Yes, the block will be gone the next hit.
        love.graphics.draw(sprites.block_almost_gone, block.x, block.y)
      else
        -- Yes, the block is damaged, but can take a couple more hits.
        love.graphics.draw(sprites.block_damaged, block.x, block.y)
      end
    end
  end
  
  -- Set the color back to white, otherwise the rest of the sprites will have the same color as the
  -- block that was drawn last.
  love.graphics.setColor(255, 255, 255, 255)
  
  -- Draw the ball.
  ball:draw()
  
  -- Draw the sprite of the paddle.
  love.graphics.draw(sprites.paddle, paddle.x, paddle.y)
end