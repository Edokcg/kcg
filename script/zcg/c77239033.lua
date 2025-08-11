--停时的时针(ZCG)
function c77239033.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
    --禁止
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DAMAGE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EVENT_PHASE+PHASE_DRAW)
    e3:SetCountLimit(1)
    e3:SetOperation(c77239033.activate)
    c:RegisterEffect(e3)
end
-------------------------------------------------------------------------
function c77239033.bantg(e,c)
    return c:IsType(TYPE_MONSTER)
end
function c77239033.bantg1(e,c)
    return c:IsType(TYPE_SPELL)
end
function c77239033.bantg2(e,c)
    return c:IsType(TYPE_TRAP)
end
function c77239033.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77239033,3))
    local ac=Duel.SelectOption(tp,aux.Stringid(77239033,0),aux.Stringid(77239033,1),aux.Stringid(77239033,2))
    if ac==0 then
	    --forbidden
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
        e1:SetCode(EFFECT_FORBIDDEN)
        e1:SetRange(LOCATION_SZONE)
        e1:SetTargetRange(0,0x7f)
        e1:SetTarget(c77239033.bantg)
        e1:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)		
        c:RegisterEffect(e1)
	end
    if ac==1 then
	    --forbidden
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
        e2:SetCode(EFFECT_FORBIDDEN)
        e2:SetRange(LOCATION_SZONE)
        e2:SetTargetRange(0,0x7f)
        e2:SetTarget(c77239033.bantg1)
        e2:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)		
        c:RegisterEffect(e2)
	end
    if ac==2 then
		--forbidden
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_FIELD)
        e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
        e3:SetCode(EFFECT_FORBIDDEN)
        e3:SetRange(LOCATION_SZONE)
        e3:SetTargetRange(0,0x7f)
        e3:SetTarget(c77239033.bantg2)
        e3:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)		
        c:RegisterEffect(e3)
	end	
end
