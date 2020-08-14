--------------
-- ESX core -- 
--------------

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

---------------------------
-- Inventory check event --
---------------------------

RegisterNetEvent('esx_minebitcoins:CheckIfHasRaspberry')
AddEventHandler('esx_minebitcoins:CheckIfHasRaspberry', function(xPlayer)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getInventoryItem('raspberry').count >= 1 then
        TriggerClientEvent('esx_minebitcoins:HasRaspberry', source)
        if Config.RemoveRaspberry then
            xPlayer.removeInventoryItem('raspberry', 1)
        end
    else
        xPlayer.showNotification(_U('need_raspberry'))
    end
end)

-------------------------
-- Mine bitcoins event --
-------------------------

RegisterNetEvent('esx_minebitcoins:RecieveBitcoins')
AddEventHandler('esx_minebitcoins:RecieveBitcoins', function(xPlayer)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.canCarryItem('bitcoin', 1) then
        xPlayer.addInventoryItem('bitcoin', 1)
    else
        xPlayer.showNotification(_U('no_space'))
    end
end)

------------------------
-- Bitcoin sale event --
------------------------

RegisterNetEvent('esx_minebitcoins:SellBitcoins')
AddEventHandler('esx_minebitcoins:SellBitcoins', function(xPlayer)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local amount = xPlayer.getInventoryItem('bitcoin').count
    local reward = Config.SellReward * amount
    if amount >= 1 then
        TriggerClientEvent('esx_minebitcoins:HasBitcoins', source)
        Citizen.Wait(Config.SellDuration)
        xPlayer.removeInventoryItem('bitcoin', amount)
        if Config.GiveDirtMoney then
            xPlayer.addAccountMoney('black_money', reward)
        else
            xPlayer.addMoney(reward)
        end
        xPlayer.showNotification(_U('sold_part_1') .. amount .. _U('sold_part_2') .. reward .. _U('sold_part_3'))
    else
        xPlayer.showNotification(_U('no_bitcoins'))
    end
end)
