EnumUtils = {}

function EnumUtils.addNextKey(enum, key)
  max = -1
  for _, val in pairs(enum) do
    if val > max then
      max = val
    end
  end
  enum[key] = max + 1
end