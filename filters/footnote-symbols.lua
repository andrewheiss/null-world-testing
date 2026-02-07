local symbols = {'*', '†', '‡', '§', '¶'}

local function get_symbol(n)
  local base_index = ((n - 1) % 5) + 1
  local repeat_count = math.floor((n - 1) / 5) + 1
  return string.rep(symbols[base_index], repeat_count)
end

local note_counter = 0

function Note(el)
  note_counter = note_counter + 1
  local symbol = get_symbol(note_counter)
  
  -- Store the symbol for this note
  el.attributes = el.attributes or {}
  el.attributes['data-symbol'] = symbol
  
  return el
end

function Link(el)
  -- Replace footnote reference links
  if el.classes:includes('footnote-ref') then
    local note_num = tonumber(el.attributes['data-footnote-number'])
    if note_num then
      local symbol = get_symbol(note_num)
      el.content = {pandoc.Str(symbol)}
    end
  -- Replace footnote back-references
  elseif el.classes:includes('footnote-back') then
    local href = el.target
    local note_num = tonumber(href:match('#fnref(%d+)'))
    if note_num then
      local symbol = get_symbol(note_num)
      el.content = {pandoc.Str('↩︎ ' .. symbol)}
    end
  end
  
  return el
end
