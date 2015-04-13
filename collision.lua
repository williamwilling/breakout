-- Checks for a collision between the ball and a block and, if a collision occurs, changes the
-- ball's speed so it moves away from the block.
function bounce(ball, block)
  -- Calculate the coordinates of the edges of the block.
  local left = block.x
  local right = block.x + block.width
  local top = block.y
  local bottom = block.y + block.height
  
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
  
  -- Did the ball hit the top side of the block?
  if ball.bottom >= top and ball.top <= top and ball.position.x >= left and ball.position.x <= right then
    -- Yes, make the ball move to the top.
    ball.speed.y = -ball.speed.y
    
    -- The ball (probably) moved a little beyond the top side of the block. Move the ball
    -- back so it doesn't overlap the block.
    local distance = ball.bottom - top
    ball.position.y = ball.position.y - 2 * distance
  end
  
  -- Did the ball hit the bottom side of the block?
  if ball.top <= bottom and ball.bottom >= bottom and ball.position.x >= left and ball.position.x <= right then
    -- Yes, make the ball move to the bottom.
    ball.speed.y = -ball.speed.y
    
    -- The ball (probably) moved a little beyond the bottom side of the block. Move the ball
    -- back so it doesn't overlap the block.
    local distance = bottom - ball.top
    ball.position.y = ball.position.y + 2 * distance
  end
  
  -- Did the ball hit the top left corner of the block?
  local dx = ball.position.x - left
  local dy = ball.position.y - top
  local distance = math.sqrt(dx * dx + dy * dy)   -- Pythagoras
  
  if distance < ball.radius then
    -- Yes, make the ball move to the top left while keeping the speed the same.
    local speed = math.sqrt(ball.speed.x * ball.speed.x + ball.speed.y * ball.speed.y)    -- Pythagoras, again!
    ball.speed.x = -0.5 * math.sqrt(2) * speed
    ball.speed.y = -0.5 * math.sqrt(2) * speed
  end
  
  -- Did the ball hit the bottom left corner of the block?
  dx = ball.position.x - left
  dy = ball.position.y - bottom
  distance = math.sqrt(dx * dx + dy * dy)   -- Pythagoras
  
  if distance < ball.radius then
    -- Yes, make the ball move to the bottom left while keeping the speed the same.
    local speed = math.sqrt(ball.speed.x * ball.speed.x + ball.speed.y * ball.speed.y)    -- Pythagoras, again!
    ball.speed.x = -0.5 * math.sqrt(2) * speed
    ball.speed.y = 0.5 * math.sqrt(2) * speed
  end
  
  -- Did the ball hit the bottom right corner of the block?
  dx = ball.position.x - right
  dy = ball.position.y - bottom
  distance = math.sqrt(dx * dx + dy * dy)   -- Pythagoras
  
  if distance < ball.radius then
    -- Yes, make the ball move to the bottom right while keeping the speed the same.
    local speed = math.sqrt(ball.speed.x * ball.speed.x + ball.speed.y * ball.speed.y)    -- Pythagoras, again!
    ball.speed.x = 0.5 * math.sqrt(2) * speed
    ball.speed.y = 0.5 * math.sqrt(2) * speed
  end
  
  -- Did the ball hit the top right corner of the block?
  dx = ball.position.x - right
  dy = ball.position.y - top
  distance = math.sqrt(dx * dx + dy * dy)   -- Pythagoras
  
  if distance < ball.radius then
    -- Yes, make the ball move to the top right while keeping the speed the same.
    local speed = math.sqrt(ball.speed.x * ball.speed.x + ball.speed.y * ball.speed.y)    -- Pythagoras, again!
    ball.speed.x = 0.5 * math.sqrt(2) * speed
    ball.speed.y = -0.5 * math.sqrt(2) * speed
  end
end

-- Checks for a collision between the ball and the sides of the playing field and, if a collision
-- occurs, changes the ball's speed so it moves away from the side it collided with.
function bounce_inside(ball, field)
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
end