--青眼白龙王
function c77239139.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239139.spcon)
    e1:SetOperation(c77239139.spop)
    c:RegisterEffect(e1)
	
    --activate
    local e2=Effect.CreateEffect(c)	
    e2:SetCategory(CATEGORY_CONTROL+CATEGORY_ATKCHANGE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
    e2:SetType(EFFECT_TYPE_IGNITION)  
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c77239139.eqcon)	
    e2:SetTarget(c77239139.target)
    e2:SetOperation(c77239139.activate)
    c:RegisterEffect(e2)	
end
-----------------------------------------------------------------
function c77239139.filter(c)
    return c:IsRace(RACE_DRAGON) 
end
function c77239139.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239139.filter,tp,LOCATION_HAND,0,1,c)
end
function c77239139.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c77239139.filter,tp,LOCATION_HAND,0,1,1,c)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
-----------------------------------------------------------------
function c77239139.eqcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,77238992)
end
function c77239139.filter1(c)
    return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c77239139.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(c77239139.filter1,tp,0,LOCATION_MZONE,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,c77239139.filter1,tp,0,LOCATION_MZONE,2,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,2,0,0)
end
function c77239139.tfilter(c,e)
    return c:IsRelateToEffect(e) and c:IsFaceup()
end
function c77239139.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c77239139.tfilter,nil,e)
    if g:GetCount()<2 then return end
    if Duel.GetControl(g,tp) then
	    local atk=g:GetSum(Card.GetAttack)
	    local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(atk)
        c:RegisterEffect(e1)
	end
end



