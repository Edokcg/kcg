--陰陽超和 (K)
local s,id=GetID()
function s.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
s.listed_names={1686814}
s.listed_series={0x301}

function s.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and not (c:IsType(TYPE_TUNER) and c:IsSetCard(0x301))
end
function s.filter3(c)
	return c:IsFaceup() and c:IsCode(1686814)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and not (chkc:IsType(TYPE_TUNER) and chkc:IsSetCard(0x600)) end
	if chk==0 then return Duel.IsExistingTarget(s.filter3,tp,LOCATION_GRAVE,0,1,nil)
					 and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	  local tc=Duel.GetFirstTarget()
	  if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_TYPE)
	  e0:SetValue(TYPE_TUNER)
	  e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e0,true) 
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(s.synlimit)
	  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1,true)
	  local e2=Effect.CreateEffect(c)
	  e2:SetType(EFFECT_TYPE_SINGLE)
	  e2:SetCode(EFFECT_ADD_SETCODE)
	  e2:SetValue(0x301)
	  e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	  tc:RegisterEffect(e2,true) end
end
function s.synlimit(e,c)
	if not c then return false end
	local code=c:GetOriginalCode()
	if code==100000150 or code==100000151 or code==100000152 or code==100000153 or code==100000154 or code==100000155 or code==100000156 then
	return else return not c:IsSetCard(0x600) end
end
