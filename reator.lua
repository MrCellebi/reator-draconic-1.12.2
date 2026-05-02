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

while true do
  term.clear()

  local info = reactor.getReactorInfo()

  print("=== REATOR DRACONIC ===")

  print("Temperatura: " .. (info.temperature or 0) .. " C")
  print("Campo: " .. (info.fieldStrength or 0))
  print("Saturacao: " .. (info.energySaturation or 0))
  print("Geracao: " .. (info.genRate or 0) .. " RF/t")
  print("Combustivel: " .. (info.fuelConversion or 0))

  print("\n=== STATUS ===")

  if info.temperature > 8000 then
    print("ALERTA: Superaquecendo!")
  elseif info.temperature < 7000 then
    print("Baixa temperatura")
  else
    print("Temperatura OK")
  end

  if info.energySaturation > 0.6 then
    print("Saturacao alta (ineficiente)")
  elseif info.energySaturation < 0.4 then
    print("Saturacao baixa (instavel)")
  else
    print("Saturacao ideal")
  end

  os.sleep(1)
end
