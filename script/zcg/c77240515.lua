--灭妖歌之影(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	  --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	 --recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.reccon)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
	--win
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ADJUST)
	e7:SetRange(LOCATION_SZONE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetOperation(s.winop)
	c:RegisterEffect(e7)
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,0,LOCATION_ONFIELD,nil,0xa150)
	return res>0
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_VENNOMINAGA = 0x12
	local c=e:GetHandler()
	local res=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,0,LOCATION_GRAVE,nil,0xa150)
	if res>=6 then
		Duel.Win(tp,WIN_REASON_VENNOMINAGA)
	end
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_ONFIELD)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,2,nil)
   Duel.SendtoGrave(g,REASON_EFFECT)
end