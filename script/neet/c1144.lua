--灵魂鸟神-朝孔雀(neet)
local m=1144
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local sme,soe=Spirit.AddProcedure(c,EVENT_SPSUMMON_SUCCESS)
	--Mandatory return
	sme:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	sme:SetTarget(cm.mrettg)
	sme:SetOperation(cm.retop)
	--Optional return
	soe:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	soe:SetTarget(cm.orettg)
	soe:SetOperation(cm.retop)
	--must ritual
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
cm.listed_names={25415052,52900000,1307,1607,1289}
function cm.rfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not c.shinobird_effect or not (c:IsCode(25415052) or c:IsCode(52900000) or c:IsCode(1307) or c:IsCode(1607)) or not c:IsAbleToHand()  then return false end
	local target=c.shinobird_effect:GetTarget()
	return not target or target(e,tp,eg,ep,ev,re,r,rp,0)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(1)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.rfilter,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.rfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_DECK)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	local te=tc.shinobird_effect
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local te=tc.shinobird_effect
	if Duel.SendtoHand(tc,tp,REASON_EFFECT) then
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end end
end
function cm.mrettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Spirit.MandatoryReturnTarget(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function cm.tkcheck(e,tp)
	return Duel.GetMZoneCount(tp,e:GetHandler())>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,25415053,0,TYPES_TOKEN,1500,1500,4,RACE_WINGEDBEAST,ATTRIBUTE_WIND)
end
function cm.orettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Spirit.OptionalReturnTarget(e,tp,eg,ep,ev,re,r,rp,0) and cm.tkcheck(e,tp) end
	Spirit.OptionalReturnTarget(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0
		and c:IsLocation(LOCATION_HAND) and cm.tkcheck(e,tp) then
			local token=Duel.CreateToken(tp,25415053)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end