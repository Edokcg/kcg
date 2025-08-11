--Shining Hope Road
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon and Rank-Up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)	
end
s.listed_series={0x48,0x2048}

function s.filter(c)
	return c:IsSetCard(0x48) 
	    and ((not c:IsSetCard(0x2048) and c:GetRank()<13) or (c:IsSetCard(0x2048)))
end	
function s.filterno0(c,tp)
	local mg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
    local effs={}
	if #mg<1 then return false end
	for tc in aux.Next(mg) do	
		if not tc:IsSetCard(0x2048) then
            local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_RANK)
			e1:SetValue(1)
			tc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_ADD_SETCODE)
			e2:SetValue(0x2048)
			tc:RegisterEffect(e2,true)
            table.insert(effs,e1) table.insert(effs,e2)
		end
	end
	local res=c.minxyzct and c:IsXyzSummonable(nil,mg,c.minxyzct,c.maxxyzct)
    for _,eff in ipairs(effs) do
        eff:Reset()
    end
	return res
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0
	   and Duel.IsExistingMatchingCard(s.filterno0,tp,LOCATION_EXTRA,0,1,nil,tp) and #mg>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.no0(c,xyz,tp)
	return not xyz.xyz_filter or xyz.xyz_filter(c,false,xyz,tp)
end	
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
	local effs={}
    local sxg=Group.CreateGroup()
	for tc in aux.Next(mg) do
		if not tc:IsSetCard(0x2048) then
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_RANK)
			e1:SetValue(1)
			--e1:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_ADD_SETCODE)
			e2:SetValue(0x2048)
			tc:RegisterEffect(e2,true)
			table.insert(effs,e1) table.insert(effs,e2)
            sxg:AddCard(tc)
		end
	end
	local g=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if #g<1 then
        for _,eff in ipairs(effs) do
            eff:Reset()
        end
        return 
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=g:Select(tp,1,1,nil):GetFirst()
    if not tg or not tg.minxyzct then 
        for _,eff in ipairs(effs) do
            eff:Reset()
        end
        return 
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local xmg=mg:FilterSelect(tp,s.no0,tg.minxyzct,tg.maxxyzct,nil,tg,tp)
    Duel.XyzSummon(tp,tg,nil,xmg)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_COST)
    e1:SetOperation(function()
        for _,eff in ipairs(effs) do
            eff:Reset()
        end
    end)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    tg:RegisterEffect(e1,true)
    for sc in aux.Next(xmg) do
        if sxg:IsContains(sc) then
        sc:RegisterFlagEffect(366,0,0,1,sc:GetOriginalSetCard())
        local ss={sc:GetOriginalSetCard()}
        local srank=sc:GetOriginalRank()
        if #ss>3 then
            ss={0x2048}
        else
            table.insert(ss,0x2048)
        end
        sc:SetCardData(CARDDATA_SETCODE,ss)
        sc:SetCardData(CARDDATA_LEVEL,sc:GetRank()+1)
        local e1=Effect.CreateEffect(c)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_TO_GRAVE)
        e1:SetLabel(srank)
        e1:SetOperation(s.returno)
        e1:SetReset(RESET_EVENT+RESET_REMOVE+RESET_TOHAND+RESET_TODECK+RESET_TOFIELD)
        sc:RegisterEffect(e1,true)
        local e2=e1:Clone()
        e2:SetCode(EVENT_REMOVE)
        e2:SetReset(RESET_EVENT+RESET_TOGRAVE+RESET_TOHAND+RESET_TODECK+RESET_TOFIELD)			
        sc:RegisterEffect(e2,true)
        local e3=e1:Clone()
        e3:SetCode(EVENT_TO_HAND)
        e3:SetReset(RESET_EVENT+RESET_TOGRAVE+RESET_REMOVE+RESET_TODECK+RESET_TOFIELD)			
        sc:RegisterEffect(e3,true)	
        local e4=e1:Clone()
        e4:SetCode(EVENT_TO_DECK)
        e4:SetReset(RESET_EVENT+RESET_TOGRAVE+RESET_REMOVE+RESET_TOHAND+RESET_TOFIELD)			
        sc:RegisterEffect(e4,true)	
        local e5=e1:Clone()
        e5:SetCode(EVENT_MOVE)
        e5:SetReset(RESET_EVENT+RESET_TOGRAVE+RESET_REMOVE+RESET_TOHAND+RESET_TODECK)			
        sc:RegisterEffect(e5,true)
        local e6=e1:Clone()
        e6:SetCode(EVENT_SPSUMMON)
        e6:SetReset(RESET_EVENT+RESET_TOGRAVE+RESET_REMOVE+RESET_TOHAND+RESET_TODECK)			
        sc:RegisterEffect(e6,true)
        local e8=e1:Clone()
        e8:SetCode(EVENT_MSET)
        e8:SetReset(RESET_EVENT+RESET_TOGRAVE+RESET_REMOVE+RESET_TOHAND+RESET_TODECK)			
        sc:RegisterEffect(e8,true)	
        local e9=e1:Clone()
        e9:SetCode(EVENT_SSET)
        e9:SetReset(RESET_EVENT+RESET_TOGRAVE+RESET_REMOVE+RESET_TOHAND+RESET_TODECK)				
        sc:RegisterEffect(e9,true)		
        local e10=e1:Clone()
        e10:SetCode(EVENT_EQUIP)
        e10:SetReset(RESET_EVENT+RESET_TOGRAVE+RESET_REMOVE+RESET_TOHAND+RESET_TODECK)				
        sc:RegisterEffect(e10,true)						
    end
end
end
function s.returno(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if c:GetFlagEffectLabel(366) then
        c:SetCardData(CARDDATA_LEVEL,e:GetLabel()) 
        c:SetCardData(CARDDATA_SETCODE,c:GetFlagEffectLabel(366)) 	
        c:ResetFlagEffect(366)
        e:Reset()
    end
end