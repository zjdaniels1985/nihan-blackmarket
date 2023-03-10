local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('nihan-blackmarket:server:UpdateShopItems', function(shop, itemData, amount)
    Config.Locations[shop]["products"][itemData.slot].amount = Config.Locations[shop]["products"][itemData.slot].amount - amount
    if Config.Locations[shop]["products"][itemData.slot].amount <= 0 then
        Config.Locations[shop]["products"][itemData.slot].amount = 0
    end
    TriggerClientEvent('nihan-blackmarket:client:SetShopItems', -1, shop, Config.Locations[shop]["products"])
end)

RegisterNetEvent('nihan-blackmarket:server:RestockShopItems', function(shop)
    if Config.Locations[shop]["products"] ~= nil then
        local randAmount = math.random(10, 50)
        for k in pairs(Config.Locations[shop]["products"]) do
            Config.Locations[shop]["products"][k].amount = Config.Locations[shop]["products"][k].amount + randAmount
        end
        TriggerClientEvent('nihan-blackmarket:client:RestockShopItems', -1, shop, randAmount)
    end
end)

QBCore.Functions.CreateCallback('nihan-blackmarket:server:getLicenseStatus', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local licenseTable = Player.PlayerData.metadata["licences"]
    local licenseItem = Player.Functions.GetItemByName("weaponlicense")
    cb(licenseTable.weapon, licenseItem)
end)

local ItemList = {
    ["casinochips"] = 1,
}

RegisterNetEvent('nihan-blackmarket:server:sellChips', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local xItem = Player.Functions.GetItemByName("casinochips")
    if xItem ~= nil then
        for k in pairs(Player.PlayerData.items) do
            if Player.PlayerData.items[k] ~= nil then
                if ItemList[Player.PlayerData.items[k].name] ~= nil then
                    local price = ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                    
                    Player.Functions.AddMoney("cash", price, "sold-casino-chips")
                    TriggerClientEvent('QBCore:Notify', src, "You sold your chips for $" .. price)
                    TriggerEvent("qb-log:server:CreateLog", "casino", "Chips", "blue", "**" .. GetPlayerName(src) .. "** got $" .. price .. " for selling the Chips")
                end
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "You have no chips..")
    end
end)