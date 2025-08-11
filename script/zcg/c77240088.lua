--强袭斗士 艾亚克雷
function c77240088.initial_effect(c)
    Xyz.AddProcedure(c,nil,3,3)
	c:EnableReviveLimit()
    --
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetCondition(c77240088.actcon)
    e1:SetValue(c77240088.value)
    c:RegisterEffect(e1)
    --
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_ATTACK_ANNOUNCE)
    e4:SetCost(c77240088.cost)
    e4:SetTarget(c77240088.distg)
    e4:SetOperation(c77240088.disop)
    c:RegisterEffect(e4)
	
    --must attack
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_MUST_ATTACK)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CANNOT_EP)
    e6:SetRange(LOCATION_MZONE)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetTargetRange(1,0)
    e6:SetCondition(c77240088.becon)
    c:RegisterEffect(e6)
end
-----------------------------------------------------------------------
function c77240088.becon(e)
    return e:GetHandler():IsAttackable()
end
-----------------------------------------------------------------------
function c77240088.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77240088.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,3)
end
function c77240088.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
end
-----------------------------------------------------------------------
function c77240088.actcon(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c77240088.value(e,c)
    return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_QUICKPLAY)*1000
end
