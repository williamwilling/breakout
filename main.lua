ball = {
  position = { x = 25, y = 150 },
  speed = { x = 50, y = 20 },
  size = 30
}
  
function love.load()
  love.window.setMode(1280, 720, { fullscreen = false, vsync = false })
end

function love.update(time)
  ball.position.x = ball.position.x + ball.speed.x * time
  ball.position.y = ball.position.y + ball.speed.y * time
end

function love.draw()
  local radius = ball.size / 2
  local x = ball.position.x - radius
  local y = ball.position.y - radius
  
  love.graphics.circle("fill", x, y, radius)
end