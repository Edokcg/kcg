--神石板 王者归来(ZCG)
function c77239118.initial_effect(c)
    c:EnableReviveLimit()
    -- spsummon proc
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239118.spcon)
    e1:SetOperation(c77239118.spop)
    c:RegisterEffect(e1)
	
	--特殊召唤
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)	
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)	
	e2:SetRange(LOCATION_MZONE)	
    e2:SetTarget(c77239118.target2)
    e2:SetOperation(c77239118.activate2)
    c:RegisterEffect(e2)
	
	--5回合破坏
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetOperation(c77239118.activate3)
    c:RegisterEffect(e3)
end
--------------------------------------------------------------------------
function c77239118.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(aux.TRUE,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c77239118.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetReset(RESET_EVENT+0xff0000)
    e1:SetCode(EFFECT_SET_ATTACK)
    e1:SetValue(ct*1000)
    c:RegisterEffect(e1)
end
--------------------------------------------------------------------------
function c77239118.filter(c,e,tp)
    return (c:IsCode(77239106) or c:IsCode(77239107) or c:IsCode(77239108)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239118.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239118.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c77239118.activate2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239118.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
--------------------------------------------------------------------------
function c77239118.activate33(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)	
    e1:SetCondition(c77239118.descon)
    e1:SetOperation(c77239118.desop)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,5)
    e:GetHandler():RegisterEffect(e1)	
end

function c77239118.activate3(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return end
	local c=e:GetHandler()
	c:SetTurnCounter(0)
		--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c77239118.descon)
	e1:SetOperation(c77239118.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,5)
	c:RegisterEffect(e1)
end
function c77239118.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c77239118.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==5 then
		Duel.Destroy(c,REASON_RULE)
		if re then re:Reset() end
	end
end