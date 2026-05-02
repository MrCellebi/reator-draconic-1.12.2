local component = require("component")
local term = require("term")

-- encontra o reator
local reactor = nil

for address, comp in component.list() do
  if comp == "draconic_reactor" or comp == "draconic_reactor_adapter" then
    reactor = component.proxy(address)
  end
end

if not reactor then
  error("Reator nao encontrado!")
end

-- helpers
local function pct(v)
  if not v then return 0 end
  return v * 100
end

-- layout fixo (3 colunas x 2 linhas)
local layout = {
  {"TEMP", 1, 1},
  {"CAMPO", 1, 2},
  {"SAT", 1, 3},

  {"FUEL", 2, 1},
  {"GEN", 2, 2},
  {"STATUS", 2, 3}
}

-- desenha labels fixos uma vez
term.clear()

for _, cell in ipairs(layout) do
  local label, row, col = cell[1], cell[2], cell[3]
  term.setCursor(col * 15 - 14, row * 3)
  term.write(label .. ":")
end

while true do
  local info = reactor.getReactorInfo()

  -- valores
  local temp = info.temperature or 0
  local field = pct(info.fieldStrength)
  local sat = pct(info.energySaturation)
  local fuel = pct(info.fuelConversion)
  local gen = info.generationRate or 0

  -- TEMP
  term.setCursor(6, 1)
  term.write(string.format("%.0f C   ", temp))

  -- CAMPO
  term.setCursor(6, 4)
  term.write(string.format("%.1f%%   ", field))

  -- SAT
  term.setCursor(6, 7)
  term.write(string.format("%.1f%%   ", sat))

  -- FUEL
  term.setCursor(21, 1)
  term.write(string.format("%.2f%%   ", fuel))

  -- GEN
  term.setCursor(21, 4)
  term.write(string.format("%d RF/t   ", gen))

  -- STATUS
  term.setCursor(21, 7)

  local status = "OK"

  if temp > 8000 then
    status = "HOT"
  elseif sat > 60 then
    status = "WASTE"
  elseif field < 45 then
    status = "UNSTABLE"
  end

  term.write(status .. "     ")

  os.sleep(1)
end
