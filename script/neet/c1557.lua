--混沌龙骑士 混沌盖亚（neet）
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e4)
--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(CARD_GAIA_CHAMPION)
	c:RegisterEffect(e1)
--position
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.poscon)
	e3:SetCountLimit(1)
	e3:SetTarget(s.postg)
	e3:SetOperation(s.posop)
	c:RegisterEffect(e3)
end
s.listed_names={66889139}
function s.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function s.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsDefensePos() or not tc:IsRelateToEffect(e) then return end
	if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)==0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(0)
	tc:RegisterEffect(e1)
end
function s.mfilter(c)
	return not c:IsType(TYPE_EFFECT)
end
function s.poscon(e)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return c:GetSummonType()==SUMMON_TYPE_RITUAL and #mg>0 and mg:IsExists(s.mfilter,1,nil)
end