-- UI to adjust shop used vehicle sale settings
-- @author John Griebel
-- @date 2024-09-11

VehicleSaleSystemCustomizerScreen = {}
VehicleSaleSystemCustomizerScreen.MOD_DIRECTORY = g_currentModDirectory

VehicleSaleSystemCustomizerScreen.CONTROLS = {
    "GeneratedHourlyChance",
    "MaxGeneratedItemsDuration",
    "MinGeneratedItemDuration",
    "MaxGeneratedItems",
    "MinimumItemValue",
    -- "BuyPriceFactor",
    -- "MaxMultiplayerItemDuration",
    -- "MinMultiplayerItemDuration",
    -- "MultiplayerAcceptChance",
    -- "MaxMultiplayerItems",
    "NewMaxDiscount",
    "UseRepricing"
}

local VehicleSaleSystemCustomizerScreen_mt = Class(VehicleSaleSystemCustomizerScreen, ScreenElement)

function VehicleSaleSystemCustomizerScreen.register()
    local screen = VehicleSaleSystemCustomizerScreen.new()

    if g_gui ~= nil then
        local filename = Utils.getFileName("gui/VehicleSaleSystemCustomizerScreen.xml", VehicleSaleSystemCustomizerScreen.MOD_DIRECTORY)
        g_gui:loadGui(filename, "VehicleSaleSystemCustomizerScreen", screen)
    end

    VehicleSaleSystemCustomizerScreen.INSTANCE = screen
end

function VehicleSaleSystemCustomizerScreen.show(callbackFunc, callbackTarget)
    if VehicleSaleSystemCustomizerScreen.INSTANCE ~= nill then
        local screen = VehicleSaleSystemCustomizerScreen.INSTANCE
        screen:setCallback(callbackFunc, callbackTarget)
        g_gui:changeScreen(nil, VehicleSaleSystemCustomizerScreen)
    end
end

function VehicleSaleSystemCustomizerScreen.new(custom_mt)
    local self = ScreenElement.new(nil, custom_mt or VehicleSaleSystemCustomizerScreen_mt)
    self:registerControls(VehicleSaleSystemCustomizerScreen.CONTROLS)

    self.callbackFunc = nil
    self.callbackTarget = nil

    local generatedHourlyChangeOpts = {}
    local maxItemDurationOpts = {}
    local minItemDurationOpts = {}
    local minValueOpts = {}
    local maxDiscountOpts = {}

    for i = 1, 11 do
        generatedHourlyChangeOpts[i] = tostring((i - 1) * 10)
        maxDiscountOpts[i] = tostring((i - 1) * 10)
        minValueOpts[i] = tostring(i * 1000)

        if i < 11 then
            maxItemDurationOpts[i] = tostring(i * 12)
            minItemDurationOpts[i] = tostring(i * 12)
        end

    end

    self.settingOptionTexts = {
        generatedHourlyChangeOpts = generatedHourlyChangeOpts,
        maxItemDurationOpts = maxItemDurationOpts,
        minItemDurationOpts = minItemDurationOpts,
        minValueOpts = minValueOpts,
        maxDiscountOpts = maxDiscountOpts
    }
    
end

function VehicleSaleSystemCustomizerScreen.createFromExistingGui(gui, guiName)
    VehicleSaleSystemCustomizerScreen.register()
    local callbackFunc = gui.callbackFunc
    local callbackTarget = gui.callbackTarget

    VehicleSaleSystemCustomizerScreen.show(callbackFunc, callbackTarget)
end

function VehicleSaleSystemCustomizerScreen.setCallback(callbackFunc, callbackTarget)
    self.callbackFunc = callbackFunc
    self.callbackTarget = callbackTarget
end

function VehicleSaleSystemCustomizerScreen.onOpen()
    VehicleSaleSystemCustomizerScreen.superClass().onOpen(self)

    self.GeneratedHourlyChance:setTexts(self.settingOptionTexts[generatedHourlyChangeOpts])
    self.MaxGeneratedItemsDuration:setTexts(self.settingOptionTexts[maxItemDurationOpts])
    self.MinGeneratedItemDuration:setTexts(self.settingOptionTexts[minItemDurationOpts])
    self.MinimumItemValue:setTexts(self.settingOptionTexts[minValueOpts])
    self.NewMaxDiscount:setTexts(self.settingOptionTexts[maxDiscountOpts])

end