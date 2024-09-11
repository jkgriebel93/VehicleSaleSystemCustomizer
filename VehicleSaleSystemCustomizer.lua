-- Name: VehicleSaleSystemCustomizer
-- Author: RedFoxModding
-- Email: my.games1050@gmail.com
-- Version: 1.0.0.0
-- Date: Dez. 2021

--[[
Known Bugs:
If your VehicleSaleSystem menu is open and to number of offers is <= 4 and a new offer is generated, you have to reopen the shop menu to see the new discount
]]--

VehicleSaleSystemCustomizer = {}
VehicleSaleSystemCustomizer.dir = g_currentModDirectory
VehicleSaleSystemCustomizer.Settings = {}
VehicleSaleSystemCustomizer.Settings.DebuggerMode = false
VehicleSaleSystemCustomizer.SaleSystemItems = {}


function VehicleSaleSystemCustomizer:loadMap(name)

	if VehicleSaleSystemCustomizer.Settings.DebuggerMode then
		print("VehicleSaleSystemCustomizer: Loading")
	end
	
	VehicleSaleSystemCustomizer.readXml()
	
	VehicleSaleSystem.GENERATED_HOURLY_CHANCE = VehicleSaleSystemCustomizer.Settings.GeneratedHourlyChance
	VehicleSaleSystem.MAX_GENERATED_ITEM_DURATION = VehicleSaleSystemCustomizer.Settings.MaxGeneratedItemsDuration
	VehicleSaleSystem.MIN_GENERATED_ITEM_DURATION = VehicleSaleSystemCustomizer.Settings.MinGeneratedItemDuration
	VehicleSaleSystem.MAX_GENERATED_ITEMS = VehicleSaleSystemCustomizer.Settings.MaxGeneratedItems
	VehicleSaleSystem.MINIMUM_ITEM_VALUE = VehicleSaleSystemCustomizer.Settings.MinimumItemValue
	VehicleSaleSystem.BUYPRICE_FACTOR = VehicleSaleSystemCustomizer.Settings.BuyPriceFactor
	VehicleSaleSystem.MAX_MULTIPLAYER_ITEM_DURATION = VehicleSaleSystemCustomizer.Settings.MaxMultiplayerItemDuration
	VehicleSaleSystem.MIN_MULTIPLAYER_ITEM_DURATION = VehicleSaleSystemCustomizer.Settings.MinMultiplayerItemDuration
	VehicleSaleSystem.MULTIPLAYER_ACCEPT_CHANCE = VehicleSaleSystemCustomizer.Settings.MultiplayerAcceptChance
	VehicleSaleSystem.MAX_MULTIPLAYER_ITEMS = VehicleSaleSystemCustomizer.Settings.MaxMultiplayerItems
	
	
	if VehicleSaleSystemCustomizer.Settings.UseRepricing ~= nil and VehicleSaleSystemCustomizer.Settings.UseRepricing then
		VehicleSaleSystemCustomizer.AppendFunctions()
	end
	
	print("VehicleSaleSystemCustomizer: Loaded")
end

function VehicleSaleSystemCustomizer.readXml()
	local xmlFilename = "settings.xml"
	local path = VehicleSaleSystemCustomizer.dir .. "settings.xml"
	local object = "VehicleSaleSystemCustomizer"
	local key = "VehicleSaleSystemCustomizer.Settings"
	
	local xmlFileId = loadXMLFile(object, path) 
	
	VehicleSaleSystemCustomizer.Settings.GeneratedHourlyChance = getXMLFloat(xmlFileId, key.."#GeneratedHourlyChance")
	VehicleSaleSystemCustomizer.Settings.MaxGeneratedItemsDuration = getXMLFloat(xmlFileId, key.."#MaxGeneratedItemsDuration")
	VehicleSaleSystemCustomizer.Settings.MinGeneratedItemDuration = getXMLFloat(xmlFileId, key.."#MinGeneratedItemDuration")
	VehicleSaleSystemCustomizer.Settings.MaxGeneratedItems = getXMLFloat(xmlFileId, key.."#MaxGeneratedItems")
	VehicleSaleSystemCustomizer.Settings.MinimumItemValue = getXMLFloat(xmlFileId, key.."#MinimumItemValue")
	VehicleSaleSystemCustomizer.Settings.BuyPriceFactor = getXMLFloat(xmlFileId, key.."#BuyPriceFactor")
	VehicleSaleSystemCustomizer.Settings.MaxMultiplayerItemDuration = getXMLFloat(xmlFileId, key.."#MaxMultiplayerItemDuration")
	VehicleSaleSystemCustomizer.Settings.MinMultiplayerItemDuration = getXMLFloat(xmlFileId, key.."#MinMultiplayerItemDuration")
	VehicleSaleSystemCustomizer.Settings.MultiplayerAcceptChance = getXMLFloat(xmlFileId, key.."#MultiplayerAcceptChance")
	VehicleSaleSystemCustomizer.Settings.MaxMultiplayerItems = getXMLFloat(xmlFileId, key.."#MaxMultiplayerItems")
	VehicleSaleSystemCustomizer.Settings.newMaxDiscount = getXMLFloat(xmlFileId, key.."#NewMaxDiscount")
	VehicleSaleSystemCustomizer.Settings.UseRepricing = getXMLBool(xmlFileId, key.."#UseRepricing")
	
	
	
	if VehicleSaleSystemCustomizer.Settings.DebuggerMode then
		print("VehicleSaleSystemCustomizer.readXml")
		
		for k,v in pairs(VehicleSaleSystemCustomizer.Settings) do
					print(tostring(k)..": "..tostring(v))
		end
		
		--[[
		default settings:
		
		VehicleSaleSystemCustomizer.Settings.GENERATED_HOURLY_CHANCE = 0.15
		VehicleSaleSystemCustomizer.Settings.MAX_GENERATED_ITEM_DURATION = 40
		VehicleSaleSystemCustomizer.Settings.MIN_GENERATED_ITEM_DURATION = 20
		VehicleSaleSystemCustomizer.Settings.MAX_GENERATED_ITEMS = 5
		VehicleSaleSystemCustomizer.Settings.MINIMUM_ITEM_VALUE = 10000
		VehicleSaleSystemCustomizer.Settings.BUYPRICE_FACTOR = 1.1
		VehicleSaleSystemCustomizer.Settings.MAX_MULTIPLAYER_ITEM_DURATION = 40
		VehicleSaleSystemCustomizer.Settings.MIN_MULTIPLAYER_ITEM_DURATION = 20
		VehicleSaleSystemCustomizer.Settings.MULTIPLAYER_ACCEPT_CHANCE = 0.8
		VehicleSaleSystemCustomizer.Settings.MAX_MULTIPLAYER_ITEMS = 20
		
		VehicleSaleSystemCustomizer.Settings.newMaxDiscount = 0.05
		
		]]--
	end
	
end

function VehicleSaleSystemCustomizer.getSaleSystemItems()
	if VehicleSaleSystemCustomizer.Settings.DebuggerMode then
		print("VehicleSaleSystemCustomizer.getSaleSystemItems")
	end
	
	print("++++++++++++++++++++++++++++g_currentMission.vehicleSaleSystem.items++++++++++++++++++++++++++++")
	if g_currentMission.vehicleSaleSystem.items ~= nil then
		for _,Item in pairs(g_currentMission.vehicleSaleSystem.items) do
			table.insert(VehicleSaleSystemCustomizer.SaleSystemItems, Item)
		end
	end
end

function VehicleSaleSystemCustomizer.getCustomizedSaleSystemItemPrice(Item)
	if VehicleSaleSystemCustomizer.Settings.DebuggerMode then
		print("VehicleSaleSystemCustomizer.getCustomizedSaleSystemItemPrice")
		print (Item.xmlFilename)
	end
	
	local storeItem = g_storeManager:getItemByXMLFilename(Item.xmlFilename)
	local oldMaxDiscount = 0.65		--estimated value
	local newMaxDiscount = VehicleSaleSystemCustomizer.Settings.newMaxDiscount
	local oldDiscountPercentage = 1 - (Item.price/storeItem.price)
	
	--check wether a change is needed (also disables multiple changes for one item)
	local bool = oldDiscountPercentage <= newMaxDiscount

	if not bool then
		local newDiscountPercentage = (oldDiscountPercentage/oldMaxDiscount) * newMaxDiscount
		
		--ensure that we stay inside given boundarys what ever oldMaxDiscount is
		if newDiscountPercentage > newMaxDiscount then
			newDiscountPercentage = newMaxDiscount
		end
		local newPrice = math.floor(storeItem.price - (newDiscountPercentage * storeItem.price))
		
		if VehicleSaleSystemCustomizer.Settings.DebuggerMode then
			print("oldDiscountPercentage: "..tostring(oldDiscountPercentage))
			print("newDiscountPercentage: "..tostring(newDiscountPercentage))
			print("VehicleSaleSystemCustomizer: new Price: "..tostring(newPrice))
		end
		
		return newPrice
	else
		return Item.price
	end
end
	
function VehicleSaleSystemCustomizer.init()
	if VehicleSaleSystemCustomizer.Settings.DebuggerMode then
		print("VehicleSaleSystemCustomizer.init")
	end

	if g_currentMission.vehicleSaleSystem.items ~= nil then
		for _,Item in pairs(g_currentMission.vehicleSaleSystem.items) do
			if Item.isGenerated then
				Item.price = VehicleSaleSystemCustomizer.getCustomizedSaleSystemItemPrice(Item)
			end
			if VehicleSaleSystemCustomizer.Settings.DebuggerMode then
				print("+++VehicleSaleSystemCustomizer.init: current Item: +++")
				for k,v in pairs(Item) do
					print(tostring(k)..": "..tostring(v))
				end
			end
		end
	end
end

function VehicleSaleSystemCustomizer.OnAddItem()
	if g_currentMission.vehicleSaleSystem.items ~= nil then
		for _,Item in pairs(g_currentMission.vehicleSaleSystem.items) do
			if Item.isGenerated then
				Item.price = VehicleSaleSystemCustomizer.getCustomizedSaleSystemItemPrice(Item)
			end
		end
	end
	
	if VehicleSaleSystemCustomizer.Settings.DebuggerMode then
		print("VehicleSaleSystemCustomizer.OnAddItem")
		DebugUtil.printTableRecursively(g_currentMission.vehicleSaleSystem.items,".",0,2);
	end
end

function VehicleSaleSystemCustomizer.AppendFunctions()
	FSBaseMission.onFinishedLoading = Utils.appendedFunction(FSBaseMission.onFinishedLoading, VehicleSaleSystemCustomizer.init)
	VehicleSaleSystem.addSale = Utils.appendedFunction(VehicleSaleSystem.addSale, VehicleSaleSystemCustomizer.OnAddItem)
end

addModEventListener(VehicleSaleSystemCustomizer)