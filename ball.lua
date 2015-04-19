require "collision"

-- Everything we need to know about the current state of the ball.
ball = {
  -- The position of the center of the ball in pixels.
  position = { x = 152, y = 180 },
  
  -- The speed of the ball in pixels per second. (Technically, this should be called 'velocity', but
  -- let's not be pedantic.)
  speed = { x = 80, y = 400 },
  
  -- The radius of the ball in pixels. Note that the radius is half of the entire width of the ball
  -- (which is called the diameter). So, while the ball's sprite is 24 pixels by 24 pixels, the
  -- radius is only 12 pixels. Most of our calculations require the radius, so it's more convenient
  -- to store the radius than the diameter.
  radius = 12,
  
  -- Indicates whether the ball is in play or whether the player should launch the ball.
  is_launched = false
}

function ball:launch()
  -- Has the player already launched the ball?
  if not self.is_launched then
    -- No, launch the ball by giving it speed and a random direction.
    local speed = 200
    self.speed.x = math.random() * speed - 0.5 * speed
    self.speed.y = -math.sqrt(speed * speed - self.speed.x * self.speed.x)
    self.is_launched = true
  end
end

-- Updates the position of the ball and performs collision detection.
function ball:update(time, field, paddle)
  -- Is the ball in play?
  if self.is_launched then
    -- Yes, move the ball, taking its speed into account.
    self.position.x = self.position.x + self.speed.x * time
    self.position.y = self.position.y + self.speed.y * time
    
    -- Calculcate the coordinates of the edges of the ball. We need these values when doing collision
    -- detection.
    self.left = self.position.x - self.radius
    self.right = self.position.x + self.radius
    self.top = self.position.y - self.radius
    self.bottom = self.position.y + self.radius
    
    -- Bounce the ball off the sides of the playing field.
    local side = bounce_inside(self, field)
    
    -- Did the ball hit the bottom of the field?
    if side == "bottom" then 
      -- Yes, the player should launch the ball again.
      ball.is_launched = false
    end
    
    -- Bounce the ball off the paddle.
    bounce(self, paddle)
    
    -- Check if the ball collides with any of the blocks.
    for _, block in ipairs(field.blocks) do
      -- Has the block been destroyed already?
      if not block.destroyed then
        -- No, bounce the ball off the sides and corners of the block.
        if bounce(self, block) then
          -- Register the hit to the block.
          block.hits = block.hits + 1
          
          -- Remember whether the block is destroyed now.
          block.destroyed = block.strength == block.hits
        end
      end
    end
  else
    -- No, until the player launches the ball, keep it close to the paddle.
    self.position.x = paddle.x + 0.5 * paddle.width
    self.position.y = paddle.y - self.radius - 4
  end
end

function ball:draw()
  -- We store the position of the center of the ball, but when drawing a sprite, Löve wants to know
  -- the position of the upper left corner, so we translate the position before drawing.
  local x = self.position.x - self.radius
  local y = self.position.y - self.radius
  
  -- Draw the sprite of the ball.
  love.graphics.draw(sprites.ball, x, y)
end