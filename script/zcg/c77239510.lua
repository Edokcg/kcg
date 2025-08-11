--女子佣兵 地灵(ZCG)
function c77239510.initial_effect(c)
    --形式变更
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c77239510.target)
    e1:SetOperation(c77239510.operation)
    c:RegisterEffect(e1)

    --效果免疫
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetCondition(c77239510.actcon)	
    e2:SetValue(c77239510.efilter)
    c:RegisterEffect(e2)
	
    --direct attack
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_DIRECT_ATTACK)	
    c:RegisterEffect(e3)	
end
----------------------------------------------------------------------------
function c77239510.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
    local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c77239510.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=tc:Filter(Card.IsRelateToEffect,nil,e)	
    Duel.ChangePosition(sg,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
end
----------------------------------------------------------------------------
function c77239510.atkfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c77239510.actcon(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
	 and not Duel.IsExistingMatchingCard(c77239510.atkfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c77239510.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
----------------------------------------------------------------------------


