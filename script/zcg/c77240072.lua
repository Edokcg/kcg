--卡通黑暗大法师
function c77240072.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77240072,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1)
    e1:SetCondition(c77240072.condition1)
    e1:SetTarget(c77240072.target)
    e1:SetOperation(c77240072.operation)
    c:RegisterEffect(e1)
	
    --win
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_ADJUST)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetOperation(c77240072.winop)
    c:RegisterEffect(e2)
end
----------------------------------------------------------------------
function c77240072.filter(c)
    return c:IsAbleToRemove()
end
function c77240072.filter2(c)
    return c:IsSetCard(0x62)
end
function c77240072.filter(c)
	return c:IsAbleToRemove()
end
function c77240072.condition1(e,c)
    return Duel.IsExistingMatchingCard(c77240072.filter2,e:GetHandlerPlayer(),LOCATION_HAND,0,5,nil)
end
function c77240072.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c77240072.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,1,c) end
	local sg=Duel.GetMatchingGroup(c77240072.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240072.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77240072.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,e:GetHandler())
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
----------------------------------------------------------------------
-----------------------------------------------------------------
function c77240072.cfilter3(c)
    return c:IsFaceup() and c:IsSetCard(0x62)
end
function c77240072.winop(e,tp,eg,ep,ev,re,r,rp)
    local WIN_REASON_EXODIA = 0x10
    local g=Duel.GetMatchingGroup(c77240072.cfilter3,tp,LOCATION_ONFIELD,0,nil)
    if g:GetCount()==5 then
        Duel.Win(tp,WIN_REASON_EXODIA)
    end
end