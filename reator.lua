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
  error("Reator nao encontrado! Verifique o Adapter.")
end

local function pct(value)
  if value == nil then return 0 end
  return value * 100
end

while true do
  term.clear()

  local info = reactor.getReactorInfo()

  local temp = info.temperature or 0
  local field = pct(info.fieldStrength)
  local sat = pct(info.energySaturation)
  local fuel = pct(info.fuelConversion)

  print("=== REATOR DRACONIC ===")

  print(string.format("Temperatura: %.0f °C", temp))
  print(string.format("Campo: %.1f%%", field))
  print(string.format("Saturacao: %.1f%%", sat))
  print(string.format("Conversao: %.2f%%", fuel))

  print("\n=== STATUS ===")

  -- temperatura (não é %)
  if temp > 8000 then
    print("ALERTA: Superaquecendo!")
  elseif temp < 7000 then
    print("Baixa temperatura")
  else
    print("Temperatura OK")
  end

  -- campo
  if field < 45 then
    print("Campo baixo (instavel)")
  elseif field > 60 then
    print("Campo alto (ineficiente)")
  else
    print("Campo ideal")
  end

  -- saturação
  if sat > 60 then
    print("Saturacao alta (desperdicio)")
  elseif sat < 40 then
    print("Saturacao baixa (instavel)")
  else
    print("Saturacao ideal")
  end

  os.sleep(1)
end
