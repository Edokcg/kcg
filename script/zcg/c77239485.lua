--千年轩辕剑(ZCG)
function c77239485.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    --remain field
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_REMAIN_FIELD)
    c:RegisterEffect(e2)
	
    --Activate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239485,1))	
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1)	
    e3:SetTarget(c77239485.target)
    e3:SetOperation(c77239485.activate)
    c:RegisterEffect(e3)
	
    --[[equip
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239485,0))	
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
    e4:SetCategory(CATEGORY_EQUIP)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTarget(c77239485.eqtg)
    e4:SetOperation(c77239485.eqop)
    c:RegisterEffect(e4)]]
end
----------------------------------------------------------------------------
function c77239485.filter(c)
    return c:IsFaceup()
end
function c77239485.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239485.filter,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c77239485.filter,tp,0,LOCATION_MZONE,nil)
    local tg=g:GetMinGroup(Card.GetAttack)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c77239485.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c77239485.filter,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        local tg=g:GetMaxGroup(Card.GetAttack)
        if tg:GetCount()>1 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local sg=tg:Select(tp,1,1,nil)
            Duel.HintSelection(sg)
            Duel.Destroy(sg,REASON_EFFECT)
        else Duel.Destroy(tg,REASON_EFFECT) end
    end
end
----------------------------------------------------------------------------
--[[function c77239485.filter1(c)
    return c:IsFaceup()
end
function c77239485.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c77239485.filter1(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77239485.filter1,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c77239485.filter1,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c77239485.eqop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        e:GetHandler():SetCardTarget(tc)		
        local e4=Effect.CreateEffect(e:GetHandler())
        e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
        e4:SetRange(LOCATION_SZONE)
        e4:SetCode(EVENT_LEAVE_FIELD)
        e4:SetCondition(c77239485.descon2)
        e4:SetOperation(c77239485.desop2)
        e:GetHandler():RegisterEffect(e4)
    end
end]]
function c77239485.descon2(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetFirstCardTarget()
    return tc and eg:IsContains(tc)
end
function c77239485.desop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

