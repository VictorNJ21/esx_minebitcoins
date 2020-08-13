ESX              		  			 			 = nil
local PlayerData 		  			 			 = {}
local IsNearMine, IsNearSell, IsMining IsSelling = false, false, false, false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData() == nil do
		Citizen.Wait(10)
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

RegisterNetEvent('esx_minebitcoins:HasBitcoins')
AddEventHandler('esx_minebitcoins:HasBitcoins', function(source)
	SellBitcoins()
end)

RegisterNetEvent('esx_minebitcoins:HasRaspberry')
AddEventHandler('esx_minebitcoins:HasRaspberry', function(source)
	TriggerEvent("mhacking:show")
	TriggerEvent("mhacking:start", 7, Config.HackTime, mycb)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then	
		FreezeEntityPosition(PlayerPedId(), false)
		TriggerEvent('mhacking:hide')
	end
end)


Citizen.CreateThread(function()
	local location = Config.MineLoc
	local location2 = Config.SellLoc
	while true do
		Citizen.Wait(4)
		if IsNearMine then
			if not IsMining then
				DrawMarker(27, location.x, location.y, location.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)
				Draw3DText(location.x, location.y, location.z + 0.90, _U('mine_bitcoins'), 0.4)
				if IsControlJustReleased(1, 38) then
					if Config.NeedRaspberry then
						TriggerServerEvent('esx_minebitcoins:CheckIfHasRaspberry', xPlayer)
					else
						TriggerEvent("mhacking:show")
						TriggerEvent("mhacking:start", 7, Config.HackTime, mycb)
					end
				end
			else
				DrawMarker(27, location.x, location.y, location.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)
				Draw3DText(location.x, location.y, location.z + 0.90, _U('stop_bitcoins'), 0.4)
				if IsControlJustReleased(1, 38) then
					IsMining = false
					FreezeEntityPosition(PlayerPedId(), false)
				end
			end
		elseif IsNearSell then
			if not IsSelling then
				DrawMarker(27, location2.x, location2.y, location2.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.5, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)
				Draw3DText(location2.x, location2.y, location2.z + 0.90, _U('sell_bitcoins'), 0.4)
				if IsControlJustReleased(1, 38) then
					TriggerServerEvent('esx_minebitcoins:SellBitcoins', xPlayer)
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local coords = GetEntityCoords(PlayerPedId())
		if Vdist(coords, Config.MineLoc) <= Config.DrawDistance then
			IsNearMine = true
		else
			IsNearMine = false
		end
		if Vdist(coords, Config.SellLoc) <= Config.DrawDistance then
			IsNearSell = true
		else
			IsNearSell = false
		end
	end
end)

-- Create Blips
Citizen.CreateThread(function()
	if Config.EnableBlips then
		local blip = AddBlipForCoord(Config.MineLoc)
		local blip2 = AddBlipForCoord(Config.SellLoc)
		SetBlipSprite (blip, 605)
		SetBlipScale  (blip, 1.0)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('mine_blip'))
		EndTextCommandSetBlipName(blip)
		SetBlipSprite (blip2, 120)
		SetBlipColour(blip2, 76)
		SetBlipScale  (blip2, 1.0)
		SetBlipAsShortRange(blip2, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(_U('sell_blip'))
		EndTextCommandSetBlipName(blip2)
	end
end)

function mycb(success, timeremaining)
	if success then
		TriggerEvent('mhacking:hide')
		MineBitcoins()
	else
		TriggerEvent('mhacking:hide')
		if Config.NotifyCopsIfFailHack and (PlayerData.job ~= nil and PlayerData.job.name == 'police') then
			if Config.UseGcphone then
				PoliceAlert()
			else
				ESX.ShowAdvancedNotification(_U('notify_title'), _U('notify_subject'), _U('notify_msg_mine'), 'CHAR_CALL911', 2)
			end
		end
	end
end

function MineBitcoins()
	FreezeEntityPosition(PlayerPedId(), true)
	IsMining = true
	while IsMining do
		Citizen.Wait(Config.MineDuration)
		TriggerServerEvent('esx_minebitcoins:RecieveBitcoins', xPlayer)
	end
end

function SellBitcoins()
	if Config.NotfityCopsWhenSell and (PlayerData.job ~= nil and PlayerData.job.name == 'police') then
		if Config.UseGcphone then
			PoliceAlert2()
		else
			ESX.ShowAdvancedNotification(_U('notify_title'), _U('notify_subject'), _U('notify_msg_sell'), 'CHAR_CALL911', 2)
		end
	end
	local ped = PlayerPedId()
	FreezeEntityPosition(ped, true)
	IsSelling = true
	exports['progressBars']:startUI(Config.SellDuration, _U('putting_bitcoins'))
	Citizen.Wait(Config.SellDuration)
	IsSelling = false
	FreezeEntityPosition(ped, false)
end

function Draw3DText(x, y, z, text, scale)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry('STRING')
	SetTextCentre(true)
	SetTextColour(255, 255, 255, 215)
	AddTextComponentString(text)
	DrawText(_x, _y)
	local factor = (string.len(text)) / 700
	DrawRect(_x, _y + 0.0150, 0.06 + factor, 0.03, 41, 11, 41, 100)
end

function PoliceAlert()
    local playerPed = PlayerPedId()
    PedPosition	= GetEntityCoords(playerPed)
    robbery_alert = _U('notify_msg_mine')
    local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
    TriggerServerEvent('esx_addons_gcphone:startCall', 'police', robbery_alert, PlayerCoords, {
    PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
    })
end

function PoliceAlert2()
    local playerPed = PlayerPedId()
    PedPosition	= GetEntityCoords(playerPed)
    robbery_alert = _U('notify_msg_sell')
    local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
    TriggerServerEvent('esx_addons_gcphone:startCall', 'police', robbery_alert, PlayerCoords, {
    PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
    })
end