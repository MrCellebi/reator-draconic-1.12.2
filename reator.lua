local component = require("component")
local term = require("term")
local gpu = component.gpu

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

-- modo fullscreen
local w, h = gpu.getResolution()

term.clear()

-- helpers
local function pct(v)
  if not v then return 0 end
  return v * 100
end

local function write(x, y, text)
  gpu.set(x, y, text)
end

-- labels fixos
write(2, 2,  "=== REATOR DRACONIC ===")

write(2, 5,  "TEMPERATURA:")
write(2, 7,  "CAMPO:")
write(2, 9,  "SATURACAO:")
write(2, 11, "FUEL:")
write(2, 13, "GERACAO:")
write(2, 15, "STATUS:")

while true do
  local info = reactor.getReactorInfo()

  local temp = info.temperature or 0
  local field = pct(info.fieldStrength)
  local sat = pct(info.energySaturation)
  local fuel = pct(info.fuelConversion)
  local gen = info.generationRate or 0

  -- limpa apenas valores (não a tela inteira)
  write(18, 5,  "                ")
  write(18, 7,  "                ")
  write(18, 9,  "                ")
  write(18, 11, "                ")
  write(18, 13, "                ")
  write(18, 15, "                ")

  -- valores atualizados
  write(18, 5,  string.format("%.0f C", temp))
  write(18, 7,  string.format("%.1f %%", field))
  write(18, 9,  string.format("%.1f %%", sat))
  write(18, 11, string.format("%.2f %%", fuel))
  write(18, 13, string.format("%d RF/t", gen))

  -- status lógico
  local status = "OK"

  if temp > 8000 then
    status = "OVERHEAT"
  elseif sat > 60 then
    status = "INEFFICIENT"
  elseif field < 45 then
    status = "UNSTABLE"
  end

  write(18, 15, status .. "        ")

  os.sleep(1)
end
