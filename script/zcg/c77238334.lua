--太阳神之鹰身人
function c77238334.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK)
    e1:SetCondition(c77238334.spcon)
    c:RegisterEffect(e1)

    --spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e3)	

	--
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77238334,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c77238334.target)
    e2:SetOperation(c77238334.activate)
    c:RegisterEffect(e2)	
	
    --Attribute
    local e51=Effect.CreateEffect(c)
    e51:SetType(EFFECT_TYPE_SINGLE)
    e51:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e51:SetCode(EFFECT_ADD_ATTRIBUTE)
    e51:SetRange(LOCATION_MZONE)
    e51:SetValue(ATTRIBUTE_DARK+ATTRIBUTE_EARTH+ATTRIBUTE_FIRE+ATTRIBUTE_LIGHT+ATTRIBUTE_WATER+ATTRIBUTE_WIND)
    c:RegisterEffect(e51)

    --disable effect
    local e52=Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_MZONE)
    e52:SetOperation(c77238334.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_MZONE)
    e53:SetTargetRange(0xa,0xa)
    e53:SetTarget(c77238334.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_MZONE)
    e54:SetTargetRange(0xa,0xa)
    e54:SetTarget(c77238334.distg2)
    c:RegisterEffect(e54)
end
-------------------------------------------------------------------------
function c77238334.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_TRAP) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77238334.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:IsType(TYPE_TRAP)
        and c:GetCardTarget():IsContains(e:GetHandler())
end
-------------------------------------------------------------------------
function c77238334.spfilter(c)
    return c:IsSetCard(0xa210) and c:IsType(TYPE_MONSTER)
end
function c77238334.spcon(e,c)
    if c==nil then return true end
    if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
    local g=Duel.GetMatchingGroup(c77238334.spfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
    local ct=g:GetClassCount(Card.GetCode)
    return ct>2
end
-------------------------------------------------------------------------
function c77238334.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,563)
    local rc=Duel.AnnounceRace(tp,1,0xffffff)
    e:SetLabel(rc)
end
function c77238334.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    Duel.ConfirmCards(tp,g)
    local sg=Duel.GetMatchingGroup(c77238334.spfilter1,tp,0,LOCATION_HAND,nil,e:GetLabel())
    if sg:GetCount()>0 then
        Duel.Damage(1-tp,sg:GetCount()*500,REASON_EFFECT)
    end
    Duel.ShuffleHand(1-tp)
end
function c77238334.spfilter1(c,rc)
    return c:IsRace(rc)
end


