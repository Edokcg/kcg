--奥利哈刚 七武神·光之越(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	   c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(s.spcon)
	c:RegisterEffect(e0)
	 --to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(s.con)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.filter(c)
	return c:IsSetCard(0xa50) and c:IsType(TYPE_MONSTER)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_HAND,0,1,3,nil)
	local tc=g:GetFirst()
	while tc do
		local op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2),aux.Stringid(id,3))
		if op==0 and not tc:IsLocation(LOCATION_ONFIELD) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		   Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		elseif op==1 and not tc:IsLocation(LOCATION_HAND) and tc:IsAbleToHand() then
		   Duel.SendtoHand(tc,nil,REASON_EFFECT)
		   Duel.ShuffleHand(tp)
		elseif op==2 and not tc:IsLocation(LOCATION_GRAVE) and tc:IsAbleToGrave() then
		   Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		tc=g:GetNext()
	end
	local atk=g:GetSum(Card.GetAttack)*2
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e4:SetValue(atk)
	e:GetHandler():RegisterEffect(e4)
end 
function s.spfilter(c)
	return c:IsSetCard(0xa50) and c:IsLevelAbove(5)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,7,nil)
end