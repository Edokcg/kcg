--奥利哈刚的圣光
function c77239282.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(c77239282.activate)
    c:RegisterEffect(e1)
end
----------------------------------------------------------------------
function c77239282.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
    local op=Duel.SelectOption(tp,aux.Stringid(77239282,0),aux.Stringid(77239282,1),aux.Stringid(77239282,2))
    if op==0 then	
	    --[[local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_CANNOT_DISEFFECT)
        e1:SetRange(LOCATION_SZONE)
        e1:SetValue(c77239282.chainfilter)
        c:RegisterEffect(e1)]]
		--inactivatable
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_INACTIVATE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetValue(c77239282.efilter)
		c:RegisterEffect(e1)
		elseif op==1 then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetRange(LOCATION_SZONE)
        e2:SetTargetRange(0,LOCATION_MZONE)
        e2:SetTarget(c77239282.disable)
        e2:SetCode(EFFECT_DISABLE)
        c:RegisterEffect(e2)  
	else
	    local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_FIELD)
        e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e3:SetCode(EFFECT_CANNOT_ACTIVATE)
        e3:SetRange(LOCATION_SZONE)
        e3:SetTargetRange(0,1)
        e3:SetValue(c77239282.aclimit)
        c:RegisterEffect(e3)
        --cannot set
        local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_FIELD)
        e4:SetCode(EFFECT_CANNOT_SSET)
        e4:SetRange(LOCATION_SZONE)
        e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e4:SetTargetRange(0,1)
        e4:SetTarget(c77239282.sfilter)
        c:RegisterEffect(e4)		
	end
end

--[[function c77239282.chainfilter(e,ct)
    local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
    local tc=te:GetHandler()
    return c:IsSetCard(0xa50)
end]]

function c77239282.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return te:IsActiveType(TYPE_MONSTER) and tc:IsSetCard(0xa50)
end

function c77239282.disable(e,c)
    return c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT
end
function c77239282.aclimit(e,re,tp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c77239282.sfilter(e,c,tp)
    return c:IsType(TYPE_FIELD)
end