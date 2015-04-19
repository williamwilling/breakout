function reset_level(blocks)
  for _, block in ipairs(blocks) do
    block.hits = 0
    block.destroyed = false
  end
end