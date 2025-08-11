--宝玉兽 黄晶虎（neet）
local s,id=GetID()
function s.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)   
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(s.repcon)
	e0:SetOperation(s.repop)
	c:RegisterEffect(e0)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(function(e) return e:GetHandler():IsContinuousSpell() end)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,{0x1034,0x2034}))
	e2:SetValue(400)
	c:RegisterEffect(e2)
end
s.listed_series={0x1034,0x2034}
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,{0x1034,0x2034}),tp,LOCATION_MZONE,0,1,nil) and ep==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end
		if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			--Treated as a Continuous Spell
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetValue(TYPE_SPELL|TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD&~RESET_TURN_SET)
			c:RegisterEffect(e1)
			Duel.RaiseEvent(c,EVENT_CUSTOM+47408488,e,0,tp,0,0)
		end
	end
end
function s.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,EVENT_CUSTOM+47408488,e,0,tp,0,0)
end