-- Everything we need to know about the current state of the paddle.
paddle = {
  -- The position of the upper left corner of the paddle in pixels.
  x = 604, y = 680,
  
  -- The size of the paddle in pixels.
  width = 72, height = 48,
  
  -- The speed with which the paddle moves in pixels per second.
  speed = 200
}

function paddle:move_left(time, field)
  -- Move the paddle to the left.
  self.x = self.x - self.speed * time
    
  -- Make sure the paddle doesn't leave the playing field.
  if self.x < field.left then
    paddle.x = field.left
  end
end

function paddle:move_right(time, field)
  -- Move the paddle to the right.
  self.x = self.x + self.speed * time
    
  -- Make sure the paddle doesn't leave the playing field.
  if self.x + self.width > field.right then
    self.x = field.right - self.width
  end
end

function paddle:draw()
  love.graphics.draw(sprites.paddle, self.x, self.y)
end