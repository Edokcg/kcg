--奥利哈刚 灵魂摄取(ZCG)
function c77239250.initial_effect(c) 
    --recover
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c77239250.cost)
    e1:SetTarget(c77239250.target)
    e1:SetOperation(c77239250.activate)
    c:RegisterEffect(e1)
end
----------------------------------------------------------------------------
function c77239250.filter(c)
    return (c:IsSetCard(0xa50) or (c:IsCode(170000166) or c:IsCode(170000167) or c:IsCode(170000168) or c:IsCode(170000169) 
	or c:IsCode(170000170) or c:IsCode(170000171) or c:IsCode(170000172) or c:IsCode(170000174))) and c:IsAbleToGraveAsCost()
end
function c77239250.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239250.filter,tp,LOCATION_MZONE,0,1,nil) end
    local sg=Duel.SelectMatchingCard(tp,c77239250.filter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
    local atk=sg:GetAttack()
            if atk<0 then atk=0 end
    local def=sg:GetDefense()
            if def<0 then def=0 end
    local count=atk+def
    Duel.SendtoGrave(sg,REASON_COST)
    e:SetLabel(count)
end
function c77239250.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetMatchingGroupCount(c77239250.filter2,tp,LOCATION_DECK,0,nil,e,tp)>0 end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(e:GetLabel())
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
end
function c77239250.filter2(c,e,tp)
    return c:IsSetCard(0xa50) and c:GetLevel()<=4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239250.activate(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
    local g=Duel.GetMatchingGroup(c77239250.filter2,tp,LOCATION_DECK,0,nil,e,tp)
    if g:GetCount()==0 then return end
    Duel.BreakEffect()
    local tc=g:Select(tp,1,1,nil)
    Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
