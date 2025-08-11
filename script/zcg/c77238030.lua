--达姿(ZCG)
function c77238030.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)	
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_SSET)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)	
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    c:RegisterEffect(e2)
	
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77238030,0))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_HAND)
    e3:SetTarget(c77238030.tg)
    e3:SetOperation(c77238030.op)
    c:RegisterEffect(e3)

    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77238030,1))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_HAND)
    e4:SetTarget(c77238030.target)
    e4:SetOperation(c77238030.activate)
    c:RegisterEffect(e4)
end
-------------------------------------------------------------------------------------
function c77238030.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return  not e:GetHandler():IsPublic() end
end
function c77238030.op(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_PUBLIC)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    e:GetHandler():RegisterEffect(e1)
end
-------------------------------------------------------------------------------------
function c77238030.filter(c)
    return c:IsCode(48179391) or c:IsCode(110000100) or c:IsCode(110000101)
	or c:IsCode(511000256) or c:IsCode(77239261) or c:IsCode(77239262) or c:IsCode(77239263)
end
function c77238030.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77238030.filter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsPublic() end
    local g=Duel.GetMatchingGroup(c77238030.filter,tp,LOCATION_DECK,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c77238030.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77238030,1))
    local g=Duel.SelectMatchingCard(tp,c77238030.filter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.ShuffleDeck(tp)
        Duel.MoveSequence(tc,0)
        Duel.ConfirmDecktop(tp,1)
    end
end

