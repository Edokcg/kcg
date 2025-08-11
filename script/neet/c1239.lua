--邪心英雄 黯黑电魔(neet)
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,s.mfilter,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK))
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--cannot to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_DECK)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.atktg)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(s.condition)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
	--to hand 
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCondition(s.thcon)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
s.material_setcode={0x8,0x6008}
s.dark_calling=true
s.listed_names={CARD_DARK_FUSION,48130397}
function s.mfilter(c,sc,st,tp)
	return c:IsAttribute(ATTRIBUTE_DARK,sc,st,tp) and c:IsSetCard(0x3008,sc,st,tp)
end
function s.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(94820406,48130397)
		or Duel.IsPlayerAffectedByEffect(sp,72043279) and st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() and chkc:GetBaseAttack()>0 end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and re and re:IsActiveType(TYPE_SPELL)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	e:SetLabelObject(rc) 
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESET_TODECK+RESET_TURN_SET,0,1)
	rc:RegisterFlagEffect(id,RESET_EVENT+RESET_TODECK+RESET_REMOVE+RESET_TOHAND+RESET_TOFIELD,0,1)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject():GetLabelObject()
	if chk==0 then return tc and tc:GetFlagEffect(id)~=0 and tc:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetLabelObject()
	if tc:GetFlagEffect(id)~=0 and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
	end
end