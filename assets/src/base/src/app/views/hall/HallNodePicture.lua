local HallNodePicture = class("HallNodePicture", function()
    return display.newNode()
end)

function HallNodePicture:ctor(args)
    self.data = args
    self:setContentSize(cc.size(346, 473))
    self:initView()
    self:enableNodeEvents()
end

function HallNodePicture:onEnter()
end

function HallNodePicture:onExit()
    self:disableNodeEvents()

    if self.schedulerID ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    end
end

function HallNodePicture:initView()
    local pageView = ccui.PageView:create()
    pageView:setContentSize(346, 473)
    pageView:setTouchEnabled(true)
    pageView:setDirection(ccui.ListViewDirection.horizontal)
    pageView:align(display.CENTER, 110, 260):addTo(self)
    local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            self.resfreshTime = os.time()
        end
    end
    pageView:addEventListener(pageViewEvent)
    self.pageView = pageView

    self.PictureList = {}
    if LangCtrl:isCN() then
        table.insert(self.PictureList, "app/hall/picture/bg_zdt_zhanshitu_cn.png")
    else
        table.insert(self.PictureList, "app/hall/picture/bg_zdt_zhanshitu_eng.png")
    end

    for i = 1, #self.PictureList do
        local itemView = ccui.Layout:create()
        itemView:setContentSize(346, 473)
        self.pageView:addPage(itemView)
        GameUtil.newSprite(self.PictureList[i], false):align(display.CENTER, 173, 237):addTo(itemView)
    end
    self.pageView:setCurPageIndex(0)

    self.resfreshTime = os.time()

    self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        if os.difftime(os.time(), self.resfreshTime) >= 4 then
            local index = self.pageView:getCurPageIndex() + 1
            if index >= #self.PictureList then
                index = 0
            end
            self.pageView:scrollToPage(index)
            self.resfreshTime = os.time()
        end
    end, 1, false)

end

return HallNodePicture
