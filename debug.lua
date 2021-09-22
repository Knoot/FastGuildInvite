local addon = FGI
local interface = addon.interface
local GUI = LibStub("AceGUI-3.0")
local fn = addon.functions
interface.debugFrame = GUI:Create("ClearFrame")
local debugFrame = interface.debugFrame
debugFrame:SetTitle("FGI Debug")
debugFrame:SetWidth(400)
debugFrame:SetHeight(720)
debugFrame:SetLayout("Fill")

debugFrame.title:SetScript('OnMouseUp', function(mover)
    local frame = mover:GetParent()
    frame:StopMovingOrSizing()
    local self = frame.obj
    local status = self.status or self.localstatus
    status.width = frame:GetWidth()
    status.height = frame:GetHeight()
    status.top = frame:GetTop()
    status.left = frame:GetLeft()
end)

debugFrame.debugList = GUI:Create("MultiLineEditBox")
local frame = debugFrame.debugList
-- frame:SetNumLines(50)
frame:SetLabel("")
frame:SetWidth(interface.debugFrame.frame:GetWidth()-40)
frame.txt = ''
frame:DisableButton(true)
frame:SetHeight(interface.debugFrame.frame:GetHeight()-40)
debugFrame:AddChild(frame)

debugFrame.closeButton = GUI:Create('Button')
local frame = debugFrame.closeButton
frame:SetText('X')
frame:SetWidth(frame.frame:GetHeight())
fn:closeBtn(frame)
frame:SetCallback('OnClick', function()
    interface.debugFrame:Hide()
end)
debugFrame:AddChild(frame)
-- debugFrame.closeButton:ClearAllPoints()
debugFrame.closeButton:SetPoint("CENTER", debugFrame.frame, "TOPRIGHT", -8, -8)
debugFrame:Hide()
-- if not addon.debug then debugFrame:Hide() else debugFrame:Show() end
