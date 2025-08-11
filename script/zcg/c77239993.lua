--黑魔导 LV9
function c77239993.initial_effect(c)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
    e1:SetCondition(c77239993.spcon)
    e1:SetOperation(c77239993.spop)
    c:RegisterEffect(e1)

    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e2)	

    --destroy
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetTarget(c77239993.target1)
    e3:SetOperation(c77239993.activate1)
    c:RegisterEffect(e3)

    --
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239993,0))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCost(c77239993.cost)
    e4:SetOperation(c77239993.activate2)
    c:RegisterEffect(e4)	

    --
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(77239993,1))
    e5:SetCategory(CATEGORY_TOGRAVE)		
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTarget(c77239993.target3)
    e5:SetOperation(c77239993.activate3)
    c:RegisterEffect(e5)	
	
	--
    local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_REMOVE)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EVENT_LEAVE_FIELD)
    e6:SetTarget(c77239993.target4)
    e6:SetOperation(c77239993.activate4)
    c:RegisterEffect(e6)		
end
----------------------------------------------------------------
function c77239993.spfilter(c)
    return c:IsCode(77239991) and c:IsAbleToRemoveAsCost()
end
function c77239993.spfilter1(c)
    return c:IsCode(77239992) and c:IsAbleToRemoveAsCost()
end
function c77239993.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239993.spfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c77239993.spfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c77239993.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77239993.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
    local g1=Duel.SelectMatchingCard(tp,c77239993.spfilter1,tp,LOCATION_MZONE,0,1,1,nil)
    g:Merge(g1)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
----------------------------------------------------------------
function c77239993.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239993.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,e:GetHandler())
	local ct=Duel.Destroy(sg,REASON_EFFECT)
	Duel.Damage(1-tp,sg:GetCount()*500,REASON_EFFECT)
    Duel.Recover(tp,sg:GetCount()*500,REASON_EFFECT)
end
--[[function c77239993.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239993.activate1(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    local ct=Duel.Destroy(sg,REASON_EFFECT)
    local tg=Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)
	if tg>0 then
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local g=Duel.SelectMatchingCard(tp,c77239993.filter1,tp,LOCATION_REMOVED,0,ct:GetCount(),ct:GetCount(),nil)
		if g:GetCount()>0 then
            Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
        end
		Duel.Recover(tp,ct*500,REASON_EFFECT)
	end
end
function c77239993.filter1(c)
    return c:IsAbleToDeck()
end]]
----------------------------------------------------------------
function c77239993.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCurrentPhase()==PHASE_MAIN1 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_BP)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetTargetRange(1,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c77239993.activate2(e,tp,eg,ep,ev,re,r,rp)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_SUMMON)
    e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
    e2:SetTargetRange(0,1)
    Duel.RegisterEffect(e2,tp)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    Duel.RegisterEffect(e,tp)
end
----------------------------------------------------------------
function c77239993.filter(c)
    return c:IsAbleToGrave()
end
function c77239993.target3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239993.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c77239993.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil) end
    local g=Duel.GetMatchingGroup(c77239993.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c77239993.activate3(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetMatchingGroup(c77239993.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239993.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,ct:GetCount(),e:GetHandler())
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        local g1=Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.BreakEffect()
        local g2=Duel.SelectMatchingCard(tp,c77239993.filter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,g1,g1,nil)
        Duel.HintSelection(g2)
        Duel.SendtoGrave(g2,REASON_EFFECT)
    end
end
----------------------------------------------------------------
function c77239993.target4(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil) end
    local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239993.activate4(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
    Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end

