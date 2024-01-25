--///////////////////////////////////////////////////////////////////////////
--GLOBAL VALUE
--///////////////////////////////////////////////////////////////////////////
Point1_AREA=Region(0,0,0,0)
Point2_AREA=Region(0,0,0,0)

--///////////////////////////////////////////////////////////////////////////
--CLASS
--///////////////////////////////////////////////////////////////////////////
Event={}
Event.new=function(tapx,tapy,gcx1,gcy1,gcol1,gcx2,gcy2,gcol2)
    local obj={}
    obj.tapLocation={tapx,tapy}
    obj.compColorPoint={gcx1,gcy1,gcol1,gcx2,gcy2,gcol2}

    --METHOD
    obj.action=function(self,second)
        click(Location(self.tapLocation[1],self.tapLocation[2]))
        wait(second)
    end

    obj.compColor=function(self)
        local result=0
        --getColor returns int(r),int(g),int(b)
        local r1,g1,b1 = getColor(Location(self.compColorPoint[1],self.compColorPoint[2]))
        local ToDecCol1=r1 * 256 * 256 + g1 * 256 + b1 --10進化
        usePreviousSnap(true)
        local r2,g2,b2 = getColor(Location(self.compColorPoint[4],self.compColorPoint[5]))
        local ToDecCol2=r2 * 256 * 256 + g2 * 256 + b2 --10進化
        usePreviousSnap(false)

        --debug
        --Logs(self.compColorPoint[3].." == "..ToDecCol1.." and "..self.compColorPoint[6].." == "..ToDecCol2)
        Point1_AREA:highlightOff()
        Point2_AREA:highlightOff()
        Point1_AREA=Region(self.compColorPoint[1]-10,self.compColorPoint[2]-10,20,20)
        Point2_AREA=Region(self.compColorPoint[4]-10,self.compColorPoint[5]-10,20,20)

        if self.compColorPoint[3] == ToDecCol1 then 
            setHighlightStyle(0x8f0000ff, false)
            Point1_AREA:highlight()
            if self.compColorPoint[6] == ToDecCol2 then
                setHighlightStyle(0x8f0000ff, false)
                Point2_AREA:highlight()
                return 1
            else
                setHighlightStyle(0x8fff0000, false)
                Point2_AREA:highlight()
                return 0
            end
        else
            setHighlightStyle(0x8fff0000, false)
            Point1_AREA:highlight()
            Point2_AREA:highlight()
            return 0
        end
    end

    return obj
end