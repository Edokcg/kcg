--地缚神 Cuauhcatl(ZCG)
local s,id=GetID()
function s.initial_effect(c)
    c:SetUniqueOnField(1,1,s.unfilter,LOCATION_MZONE)
 --direct atk
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e6)
--Destroy
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_BATTLE_DESTROYING)
    e3:SetCondition(aux.bdocon)
    e3:SetTarget(s.destg)
    e3:SetOperation(s.desop)
    c:RegisterEffect(e3)  
   --
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_SELF_DESTROY)
    e4:SetCondition(s.sdcon)
    c:RegisterEffect(e4)
 --battle target
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(aux.imval1)
    c:RegisterEffect(e5)
end
function s.unfilter(c)
    return c:IsSetCard(0x21) and not Duel.IsPlayerAffectedByEffect(c:GetControler(),77238003)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
    if chk==0 then return g:GetCount()>0 end
        Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
        local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
function s.sdcon(e)
    return not Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
