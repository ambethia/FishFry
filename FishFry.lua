local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)

function f:PLAYER_LOGIN(...)
  f:UnregisterEvent("PLAYER_LOGIN"); self.PLAYER_LOGIN = nil
end
f:RegisterEvent("PLAYER_LOGIN")

local function EquipWeapons()
  print("Fish Fry: Equipping weapons.")
  EquipItemByName(FishFryDB.mainHand, INVSLOT_MAINHAND)
  if (FishFryDB.offHand ~= '') then
    EquipItemByName(FishFryDB.offHand, INVSLOT_OFFHAND)
  end
end

local function EquipFishingPole()
  print("Fish Fry: Equipping pole.")
  EquipItemByName(FishFryDB.pole, INVSLOT_MAINHAND)
end

local function FFEnable()
  FishFryDB.enabled = true
  f:RegisterEvent("PLAYER_REGEN_DISABLED")
  f:RegisterEvent("PLAYER_REGEN_ENABLED")
  EquipFishingPole()
  print("Fish Fry enabled.")
end

local function FFDisable()
  FishFryDB.enabled = false
  f:UnregisterEvent("PLAYER_REGEN_DISABLED")
  f:UnregisterEvent("PLAYER_REGEN_ENABLED")
  EquipWeapons()
  print("Fish Fry disabled.")
end

function f:PLAYER_REGEN_ENABLED(...)
  EquipFishingPole()
end

function f:PLAYER_REGEN_DISABLED(...)
  EquipWeapons()
end

function f:VARIABLES_LOADED(...)
  if not ( FishFryDB ) then FishFryDB = {}; end
end
f:RegisterEvent("VARIABLES_LOADED")

SLASH_FISHFRY1, SLASH_FISHFRY2 = "/fishfry", "/ff"
SlashCmdList.FISHFRY = function(msg)
  msg = msg or ""
  local cmd, arg = string.split(" ", msg, 2)
  cmd = string.lower(cmd or "")
  arg = string.lower(arg or "")

  if (cmd == "" or cmd == "toggle") then
    if (FishFryDB.enabled) then
      FFDisable()
    else
      FFEnable()
    end
  elseif (cmd == "pole") then
    FishFryDB.pole = arg
    print("Fish Fry: Pole set to " .. FishFryDB.pole)
  elseif (cmd == "mh") then
    FishFryDB.mainHand = arg
    print("Fish Fry: Main hand set to " .. FishFryDB.mainHand)
  elseif (cmd == "oh") then
    FishFryDB.offHand = arg
    print("Fish Fry: Off hand set to " .. FishFryDB.offHand)
  end
end
