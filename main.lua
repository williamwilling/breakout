-- Everything we need to know about the current state of the bal.
ball = {
  -- The position of the center of the ball in pixels.
  position = { x = 25, y = 150 },
  
  -- The speed of the ball in pixels per second. (Technically, this should be called 'velocity', but
  -- let's not be pedantic.)
  speed = { x = 500, y = 20 },
  
  -- The radius of the ball in pixels. Note that the radius is half of the entire width of the ball
  -- (which is called the diameter). So, while the ball's sprite is 24 pixels by 24 pixels, the
  -- radius is only 12 pixels. Most of our calculations require the radius, so it's more convenient
  -- to store the radius than the diameter.
  radius = 12
}
  
-- Everything we need to know about the current state of the playing field.
field = {
  -- The coordinates of the upperleft corner of the playing field.
  left = 0, top = 0,
  
  -- The coordinates of the lowerright corner of the playing field.
  right = 1280, bottom = 720
}

function love.load()
  -- Set the resolution at which the game will run.
  love.window.setMode(1280, 720, { fullscreen = false, vsync = false })
  
  -- Load all the sprites we need. 'Sprite' is basically game dev speak for 'image'.
  sprites = {}
  sprites.ball = love.graphics.newImage("assets/ball.png")
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
  
  -- Did the ball hit the right side of the playing field?
  if ball.right >= field.right then
    -- Yes, make the ball move to the left.
    ball.speed.x = -ball.speed.x
    
    -- The ball (probably) moved a little beyond the right side of the playing field. Move the ball
    -- back into the field.
    local distance = ball.right - field.right
    ball.position.x = ball.position.x - 2 * distance
  end
end

function love.draw()
  -- We store the position of the center of the ball, but when drawing a sprite, Löve wants to know
  -- the position of the upperleft corner, so we translate the position before drawing.
  local x = ball.position.x - ball.radius
  local y = ball.position.y - ball.radius
  
  -- Draw the sprite of the ball.
  love.graphics.draw(sprites.ball, x, y)
end