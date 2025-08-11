--黑魔導女孩 橙将(ZCG)
function c77239957.initial_effect(c)
    --battle indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e1:SetCountLimit(1)
    e1:SetValue(c77239957.valcon)
    c:RegisterEffect(e1)

    --copy
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c77239957.sctg)
    e2:SetOperation(c77239957.operation)
    c:RegisterEffect(e2)	
end
-----------------------------------------------------------------
function c77239957.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0
end
-----------------------------------------------------------------
function c77239957.cfilter(c)
    return c:IsRace(RACE_SPELLCASTER)
end
function c77239957.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239957.atkfilter,tp,LOCATION_HAND,0,1,nil) end
end
function c77239957.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c77239957.atkfilter,tp,LOCATION_HAND,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
    local c=e:GetHandler()
 	local tc=g:GetFirst()    
	local code=tc:GetOriginalCode()
    if not tc:IsType(TYPE_TOKEN+TYPE_TRAPMONSTER) then
        c:CopyEffect(code, RESET_EVENT+0x1fe0000)
    end
end