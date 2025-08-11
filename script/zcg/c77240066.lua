--究极幻魔兽-神炎皇
function c77240066.initial_effect(c)
    c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
	
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c77240066.spcon)
    e2:SetOperation(c77240066.spop)
    c:RegisterEffect(e2)	
	
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c77240066.efilter)
	c:RegisterEffect(e3)

    --atk twice
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EXTRA_ATTACK)
    e4:SetValue(1)
    c:RegisterEffect(e4)
	
    --destroy
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(210008,0))
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(c77240066.target)
    e5:SetOperation(c77240066.operation)
    c:RegisterEffect(e5)	
	
    --atk/def
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(c77240066.adval)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e7)

    --
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_HANDES)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e1:SetTarget(c77240066.target1)
    e1:SetOperation(c77240066.activate1)
    c:RegisterEffect(e1)	
end
--------------------------------------------------------------------------
function c77240066.spfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c77240066.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77240066.spfilter,c:GetControler(),LOCATION_GRAVE,0,3,nil)
end
function c77240066.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectMatchingCard(tp,c77240066.filter,tp,LOCATION_GRAVE,0,3,3,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--------------------------------------------------------------------------
function c77240066.adval(e,c)
    return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_GRAVE+LOCATION_REMOVED,0)*1000
end
--------------------------------------------------------------------------
function c77240066.desfilter(c)
    return c:IsFacedown()
end
function c77240066.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77240066.desfilter,tp,0,LOCATION_SZONE,1,nil) end
    local sg=Duel.GetMatchingGroup(c77240066.desfilter,tp,0,LOCATION_SZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240066.operation(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c77240066.desfilter,tp,0,LOCATION_SZONE,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end
--------------------------------------------------------------------------
function c77240066.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c77240066.activate1(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
    if g:GetCount()>0 then
        Duel.ConfirmCards(p,g)
        Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
        local sg=g:Select(p,1,1,nil)
        Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
        Duel.ShuffleHand(1-p)
    end
end
function c77240066.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end