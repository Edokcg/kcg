--欧贝利斯克之死灵干扰(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target) 
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
--cannot trigger
	local e101=Effect.CreateEffect(c)
	e101:SetType(EFFECT_TYPE_FIELD)
	e101:SetCode(EFFECT_CANNOT_TRIGGER)
	e101:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e101:SetRange(LOCATION_SZONE)
	e101:SetTargetRange(0,0xa)
	e101:SetTarget(s.distg99)
	c:RegisterEffect(e101)
	--disable
	local e102=Effect.CreateEffect(c)
	e102:SetType(EFFECT_TYPE_FIELD)
	e102:SetCode(EFFECT_DISABLE)
	e102:SetRange(LOCATION_SZONE)
	e102:SetTargetRange(0,LOCATION_ONFIELD)
	e102:SetTarget(s.distg99)
	c:RegisterEffect(e102)
	--disable effect
	local e103=Effect.CreateEffect(c)
	e103:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e103:SetCode(EVENT_CHAIN_SOLVING)
	e103:SetRange(LOCATION_SZONE)
	e103:SetOperation(s.disop99)
	c:RegisterEffect(e103)
	--
	local e104=Effect.CreateEffect(c)
	e104:SetType(EFFECT_TYPE_FIELD)
	e104:SetCode(EFFECT_SELF_DESTROY)
	e104:SetRange(LOCATION_SZONE)
	e104:SetTargetRange(0,LOCATION_ONFIELD)
	e104:SetTarget(s.distg99)
	c:RegisterEffect(e104)
end
function s.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE) and c:IsLocation(LOCATION_GRAVE) and c:IsPreviousControler(tp) and c:IsSetCard(0xa220)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	local rc=tc:GetReasonCard()
	if chk==0 then return tc and rc and rc:IsOnField() and rc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsLocation(LOCATION_GRAVE) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_MZONE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local rc=tc:GetReasonCard()
	if tc and rc and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.Equip(tp,tc,rc,false) then
		local e1=Effect.CreateEffect(rc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
	   -- e1:SetLabelObject(tc)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(rc)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_SET_BASE_ATTACK)
		e2:SetValue(0)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		--indes
		local e3=Effect.CreateEffect(rc)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e3:SetValue(1)
		tc:RegisterEffect(e3)
		--
		local e4=Effect.CreateEffect(rc)
		e4:SetType(EFFECT_TYPE_EQUIP)
		e4:SetCode(EFFECT_UNRELEASABLE_SUM)
		e4:SetValue(1)
		tc:RegisterEffect(e4)
end
end
function s.eqlimit(e,c)
   return e:GetOwner()==c and not c:IsDisabled()
end
function s.distg99(e,c)
	return c:IsSetCard(0xa90) or c:IsSetCard(0xa110)
end
function s.disop99(e,tp,eg,ep,ev,re,r,rp)
	if  (re:GetHandler():IsSetCard(0xa90) or re:GetHandler():IsSetCard(0xa110)) and re:GetHandler():IsControler(1-tp) then
		Duel.NegateEffect(ev)
	end
end
