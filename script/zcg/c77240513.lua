--神之墓场(ZCG)
local s,id=GetID()
function s.initial_effect(c)
  c:EnableCounterPermit(0xa11)
		 --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
  --search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.srtg)
	e2:SetOperation(s.srop)
	c:RegisterEffect(e2)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(s.addc1)
	c:RegisterEffect(e1)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(s.atcon)
	e4:SetOperation(s.atop)
	c:RegisterEffect(e4)
end
function s.atcon(e)
return e:GetHandler():GetFlagEffect(id)<=0 and  e:GetHandler():GetCounter(0xa11)==5
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   c:RegisterFlagEffect(id,RESET_PHASE+RESETS_STANDARD,0,1)
   Duel.SetLP(1-tp,1)
end
function s.filter1(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0xa150) and c:IsType(TYPE_MONSTER)
end
function s.addc1(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.filter1,1,nil,tp) then
		e:GetHandler():AddCounter(0xa11,1)
	end
end
function s.srfilter(c)
	return c:IsSetCard(0xa150) and c:IsType(TYPE_MONSTER) and  c:IsAbleToDeck()
end
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.srfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function s.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.srfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end