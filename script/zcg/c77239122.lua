--青眼圣约龙(ZCG)
function c77239122.initial_effect(c)
    c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c77239122.spcon)
	e2:SetOperation(c77239122.spop)
	c:RegisterEffect(e2)
	
	--破坏
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239122,0))	
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
    e3:SetCost(c77239122.cost)
    e3:SetTarget(c77239122.target)
    e3:SetOperation(c77239122.activate)
    c:RegisterEffect(e3)	
	
	--卡组破坏
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77239122,1))
    e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)	
    e4:SetOperation(c77239122.regop)
	c:RegisterEffect(e4)

	--特殊召唤
    local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77239122,2))	
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)	
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)	
    e5:SetTarget(c77239122.target2)
    e5:SetOperation(c77239122.activate2)
    c:RegisterEffect(e5)	
end
----------------------------------------------------------------------------
function c77239122.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c77239122.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
----------------------------------------------------------------------------
function c77239122.filter(c)
    return c:IsType(TYPE_MONSTER)
end
function c77239122.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239122.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77239122.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c77239122.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239122.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end
----------------------------------------------------------------------------
function c77239122.regop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetCountLimit(1)
	e1:SetCondition(c77239122.condition)	
    e1:SetOperation(c77239122.mtop)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
    Duel.RegisterEffect(e1,tp)
end
function c77239122.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c77239122.mtop(e,tp,eg,ep,ev,re,r,rp)
    local g2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
    Duel.DiscardDeck(1-tp,g2/2,REASON_EFFECT) 
end
----------------------------------------------------------------------------
function c77239122.filter2(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xdd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239122.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239122.filter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.SelectTarget(tp,c77239122.filter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77239122.activate2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e1:SetValue(1)
		tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetValue(1)
        tc:RegisterEffect(e2)		
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e3:SetRange(LOCATION_MZONE)
        e3:SetCode(EFFECT_IMMUNE_EFFECT)
        e3:SetValue(c77239122.efilter)
        tc:RegisterEffect(e3)		
		Duel.SpecialSummonComplete()
	end
end
function c77239122.efilter(e,te)
    return te:GetOwner()~=te:GetOwner()
end