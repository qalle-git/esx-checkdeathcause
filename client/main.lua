local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }
  
  ESX               = nil
  
  Citizen.CreateThread(function()
	  while ESX == nil do
		  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		  Citizen.Wait(0)
	  end
		PlayerData = ESX.GetPlayerData()
  end)
  
  RegisterNetEvent('esx:playerLoaded')
  AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
  end)
  
  RegisterNetEvent('esx:setJob')
  AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
  end)
  
  local checking = false
  
  Citizen.CreateThread(function()
		while true do
		  Citizen.Wait(3000)
  
		  if not checking then
  
			  local player, distance = ESX.Game.GetClosestPlayer()
  
			  if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
				  if distance ~= -1 and distance <= 2.0 then	
					  if IsPedDeadOrDying(GetPlayerPed(player)) then
						  Start(GetPlayerPed(player))
					  end
				  end
			  end
		  end
  
	  end
  end)
  
  function Start(ped)
	  checking = true
	  while checking do
		  Citizen.Wait(3)
  
		  local distance = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(ped))
  
		  local x,y,z = table.unpack(GetEntityCoords(ped))
  
		  if distance < 2.0 then
			  DrawText3D(x,y,z, 'Tryck [~g~E~s~] för att hantera person', 0.4)
			  --DrawText3D(GetEntityCoords(GetPlayerPed(player))["x"], GetEntityCoords(GetPlayerPed(player))["y"], GetEntityCoords(GetPlayerPed(player))["z"], "Tryck [~g~E~w~] för att kolla på persones skador.", 0.4)
			  if IsControlPressed(0,  Keys['E']) then
				  OpenDeathMenu(ped)
			  end
		  end
  
		  if distance > 7.5 or not IsPedDeadOrDying(ped) then
			  checking = false
		  end
  
	  end
  
	  checking = false
  end
  
  function Notification(x,y,z, message)
	  local timestamp = GetGameTimer()
  
	  while (timestamp + 4500) > GetGameTimer() do
		  Citizen.Wait(0)
		  DrawText3D(x, y, z, 'Personen verkar skadad här', 0.4)
		  checking = false
	  end
  end
  
  function OpenDeathMenu(player)
			local elements   = {}
	
			table.insert(elements, {label = 'Kolla Dödsorsak', value = 'deathcause'})
			table.insert(elements, {label = 'Kolla Vart personen är skadad', value = 'damage'})
  
  
	ESX.UI.Menu.Open(
	  'default', GetCurrentResourceName(), 'dead_citizen',
	  {
		title    = 'Person-handlingar',
		align    = 'top-right',
		elements = elements,
	  },
	  function(data, menu)
		  local ac = data.current.value
  
		  --local player, distance = ESX.Game.GetClosestPlayer()
  
		  if ac == 'damage' then
  
			  local bone
			  local success = GetPedLastDamageBone(player,bone)
  
			  local success,bone = GetPedLastDamageBone(player)
			  if success then
				  print(bone)
				  local x,y,z = table.unpack(GetPedBoneCoords(player, bone))
  
					if bone == 24817 then
						Notification(x, y, z, 'Personen är skadad i bröstet')
					elseif bone == 24816 then
				  Notification(x, y, z, 'Personen är skadad i bröstet')
					elseif bone == 31086 then
						Notification(x,y,z,'Personen är skadad i huvudet')
					elseif bone == 58271 then
						Notification(x,y,z,'Personen är skadad i vänster-benet')
					elseif bone == 51826 then
						Notification(x,y,z,'Personen är skadad i höger-benet')
					elseif bone == 14201 then
						Notification(x,y,z,'Personen är skadad i vänster-foten')
					elseif bone == 52301 then
						Notification(x,y,z,'Personen är skadad i höger-foten')
					elseif bone == 18905 then
						Notification(x,y,z,'Personen är skadad i vänster-handen')
					elseif bone == 57005 then
						Notification(x,y,z,'Personen är skadad i höger-handen')
					end
			  else
				-- couldn't get the bone, uh oh
			  end
		  end
  
		  if ac == 'deathcause' and distance ~= -1 and distance <= 2.0 then
			  --gets deathcause
			  local d = GetPedCauseOfDeath(player)		
			  local playerPed = GetPlayerPed(-1)
  
			  --starts animation
  
			  TaskStartScenarioInPlace(playerPed, Config.Animation, 0, true)
  
			  Citizen.Wait(Config.TimeDoingAnimation)
  
			  --exits animation			
  
			  ClearPedTasksImmediately(playerPed)
  
				  if d == -1569615261 or d == 1737195953 or d == 1317494643 or d == -1786099057 or d == 1141786504 or d == -2067956739 or d == -868994466 or d == -1951375401 then
					  sendNotification(_U('hardmeele'), 'warning', 2500)
				  elseif d == 453432689 or d == 1593441988 or d == 584646201 or d == -1716589765 or d == 324215364 or d == 736523883 or d == -270015777 or d == -1074790547 or d == -2084633992 or d == -1357824103 or d == -1660422300 or d == 2144741730 or d == 487013001 or d == 2017895192 or d == -494615257 or d == -1654528753 or d == 100416529 or d == 205991906 or d == 1119849093 or d == -1045183535 then
					  sendNotification(_U('bullet'), 'warning', 2500)
				  elseif d == -1716189206 or d == 1223143800 or d == -1955384325 or d == -1833087301 or d == 910830060 then
					  sendNotification(_U('knifes'), 'warning', 2500)
				  elseif d == -100946242 or d == 148160082 then
					  sendNotification(_U('bitten'), 'warning', 2500)
				  elseif d == -842959696 then
					  sendNotification(_U('brokenlegs'), 'warning', 2500)
				  elseif d == -1568386805 or d == 1305664598 or d == -1312131151 or d == 375527679 or d == 324506233 or d == 1752584910 or d == -1813897027 or d == 741814745 or d == -37975472 or d == 539292904 or d == 341774354 or d == -1090665087 then
					  sendNotification(_U('explosive'), 'warning', 2500)
				  elseif d == -1600701090 then
					  sendNotification(_U('gas'), 'warning', 2500)
				  elseif d == 101631238 then
					  sendNotification(_U('fireextinguisher'), 'warning', 2500)
				  elseif d == 615608432 or d == 883325847 or d == -544306709 then
					  sendNotification(_U('fire'), 'warning', 2500)
				  elseif d == -10959621 or d == 1936677264 then
					  sendNotification(_U('drown'), 'warning', 2500)
				  elseif d == 133987706 or d == -1553120962 then
					  sendNotification(_U('caraccident'), 'warning', 2500)
				  else
					  sendNotification(_U('unknown'), 'error', 2500)
				  end
			  end
  
		  if ac == 'dna' and distance ~= -1 and distance <= 2.0 then
			  --hämtar en bag med identifiern som ligger död
			  TriggerServerEvent('esx_qalle_dna:getBag', GetPlayerServerId(player), GetPlayerServerId(PlayerId()))
			  sendNotification('Du tog ett dna-prov och la ner det i fickan', 'success', 5000)
		  end
  
  
	  end,
	  function(data, menu)
		menu.close()
	  end
	)
  end
  
  function hintToDisplay(text)
	  SetTextComponentFormat("STRING")
	  AddTextComponentString(text)
	  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
  end
  
  
  function LocalPed()
	  return GetPlayerPed(-1)
  end
  
  function sendNotification(message, messageType, messageTimeout)
	  TriggerEvent("pNotify:SendNotification", {
		  text = message,
		  type = messageType,
		  queue = "qalle",
		  timeout = messageTimeout,
		  layout = "bottomCenter"
	  })
  end
  
  function DrawText3D(x, y, z, text, scale)
	  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	  local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
   
	  SetTextScale(scale, scale)
	  SetTextFont(4)
	  SetTextProportional(1)
	  SetTextEntry("STRING")
	  SetTextCentre(1)
	  SetTextColour(255, 255, 255, 215)
   
	  AddTextComponentString(text)
	  DrawText(_x, _y)
   
	  local factor = (string.len(text)) / 370
   
	  DrawRect(_x, _y + 0.0150, 0.030 + factor, 0.025, 41, 11, 41, 100)
  end