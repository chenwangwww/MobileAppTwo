local JumpText = {};

function JumpText.new(node, time)
    local obj = {}
    setmetatable(obj, {
        __index = JumpText
    })
    obj.node = node;
    obj:ctor(time);
    return obj
end

function JumpText:ctor(time)
    self._useTime = time or 1.5
    self._typeName = self.node:getDescription();
    self.node:scheduleUpdateWithPriorityLua(handler(self, self.onUpdate), 0.02)
    self.number = 0;
    self.endNo = 0;
    self.isRuning = false;
end

function JumpText:stopScroll()
    self.isRuning = false;
    self:_setText(self.endNo)
end

function JumpText:setText(no, time)
    if no - self.number < 5 then
        self.isRuning = false;
        return self:_setText(no);
    end
    self.startNo = self.number;
    self.endNo = no;
    self.runTime = 0;
    self.delta = 0;
    self.isRuning = true;
    if time then
        self._useTime = time
    end
end

function JumpText:_setText(no)
    self.number = no;
    if self._typeName == "TextAtlas" then
        self.node:setString(no)
    elseif self._typeName == "Text" then
        self.node:setText(no);
    end
end

function JumpText:onUpdate()
    if self.isRuning == false then
        return;
    end
    if self.runTime > 0 then
        self.runTime = self.runTime - 0.02
        return;
    end
    local v = math.floor(self.delta / self._useTime * (self.endNo - self.startNo) + self.startNo)
    self.delta = self.delta + 0.02
    if self.delta > self._useTime then
        self.isRuning = false;
        self:_setText(self.endNo);
    elseif self.delta >= self._useTime - 0.15 then
        self.runTime = math.pow((0.15 + self.delta - self._useTime) * 10, 3) * 0.03;
        self:_setText(v)
    else
        self:_setText(v)
    end

end

return JumpText
