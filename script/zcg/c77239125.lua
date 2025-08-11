--青眼白龙LV9(ZCG)
function c77239125.initial_effect(c)
    c:EnableReviveLimit()
	--特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c77239125.spcon)
	e1:SetOperation(c77239125.spop)
	c:RegisterEffect(e1)
	
	--装备
    local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(c77239125.target)
    e2:SetOperation(c77239125.activate)
    c:RegisterEffect(e2)
	
	
end
--------------------------------------------------------------------------
function c77239125.cfilter(c)
    return c:IsRace(RACE_DRAGON) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c77239125.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239125.cfilter,tp,LOCATION_HAND,0,1,c)
end
function c77239125.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c77239125.cfilter,tp,LOCATION_HAND,0,1,1,c)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
--------------------------------------------------------------------------
function c77239125.filter(c)
    return c:IsCode(89631139)
end
function c77239125.eqlimit(e,c)
    return e:GetOwner()==c
end
function c77239125.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c77239125.filter(chkc) end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c77239125.filter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c77239125.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsFaceup() and c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) then
        local atk=tc:GetTextAttack()
        if atk<0 then atk=0 end
        if not Duel.Equip(tp,tc,c,true) then return end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(c77239125.eqlimit)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_EQUIP)
        e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetCode(EFFECT_UPDATE_ATTACK)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        e2:SetValue(atk)
        tc:RegisterEffect(e2)	
    end
    local g=Duel.GetMatchingGroupCount(Card.IsRace,c:GetControler(),LOCATION_GRAVE,0,nil,RACE_DRAGON)		
    Duel.DiscardDeck(1-tp,g*3,REASON_EFFECT)
    Duel.Damage(1-tp,(g*3)*300,REASON_EFFECT)		
end
----------------------------------------------------------------------------
