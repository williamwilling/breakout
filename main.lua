ball = {
  position = { x = 25, y = 150 },
  speed = { x = 50, y = 20 },
  radius = 12
}

sprites = {}
  
function love.load()
  love.window.setMode(1280, 720, { fullscreen = false, vsync = false })
  sprites.ball = love.graphics.newImage("assets/ball.png")
end

function love.update(time)
  ball.position.x = ball.position.x + ball.speed.x * time
  ball.position.y = ball.position.y + ball.speed.y * time
end

function love.draw()
  local x = ball.position.x - ball.radius
  local y = ball.position.y - ball.radius
  
  love.graphics.draw(sprites.ball, x, y)
end