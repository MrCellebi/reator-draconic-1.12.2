local component = require("component")
local term = require("term")
local event = require("event")

-- tenta encontrar o reator
local reactor = nil

for address, comp in component.list() do
  if comp == "draconic_reactor" then
    reactor = component.proxy(address)
  end
end

if not reactor then
  error("Reator nao encontrado! Verifique o Adapter.")
end

local function percent(value, max)
  return (value / max) * 100
end

while true do
  term.clear()
  
  local temp = reactor.getTemperature()
  local field = reactor.getFieldStrength()
  local maxField = reactor.getMaxFieldStrength()
  local sat = reactor.getEnergySaturation()
  local maxSat = reactor.getMaxEnergySaturation()
  local gen = reactor.getGenerationRate()
  local fuel = reactor.getFuelConversion()

  local fieldPct = percent(field, maxField)
  local satPct = percent(sat, maxSat)

  print("=== REATOR DRACONIC ===")
  print(string.format("Temp: %.0f C", temp))
  print(string.format("Campo: %.1f%%", fieldPct))
  print(string.format("Saturacao: %.1f%%", satPct))
  print(string.format("Geracao: %d RF/t", gen))
  print(string.format("Conversao: %.4f", fuel))

  print("\n=== ANALISE ===")

  if temp > 8000 then
    print("ALERTA: Temperatura alta!")
  elseif temp < 7000 then
    print("Temperatura baixa (ineficiente)")
  else
    print("Temperatura ideal")
  end

  if fieldPct < 50 then
    print("Campo baixo (RISCO!)")
  elseif fieldPct > 60 then
    print("Campo alto (ineficiente)")
  else
    print("Campo ok")
  end

  if satPct > 60 then
    print("Saturacao alta (perdendo eficiencia)")
  elseif satPct < 40 then
    print("Saturacao baixa (instavel)")
  else
    print("Saturacao ideal")
  end

  print("\nAtualizando em 1s...")
  os.sleep(1)
end
