--装甲 超巨型坦克 （ZCG）
function c77240284.initial_effect(c)
		c:EnableReviveLimit()
--XyzSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c77240284.xyzcon)
	e1:SetOperation(c77240284.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
 --equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77240284,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c77240284.eqcon)
	e2:SetTarget(c77240284.eqtg)
	e2:SetOperation(c77240284.eqop)
	c:RegisterEffect(e2)
 --atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c77240284.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetValue(c77240284.desval)
	c:RegisterEffect(e4)
--direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	e5:SetCondition(c77240284.dircon)
	c:RegisterEffect(e5)
--negate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetCode(EVENT_CHAINING)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c77240284.negcon)
	e0:SetTarget(c77240284.negtg)
	e0:SetOperation(c77240284.negop)
	c:RegisterEffect(e0)
--negate attack
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e11:SetCode(EVENT_BE_BATTLE_TARGET)
	e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(c77240284.condition9)
	e11:SetTarget(c77240284.target9)
	e11:SetOperation(c77240284.operation9)
	c:RegisterEffect(e11)
end
function c77240284.condition9(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsPosition(POS_FACEUP_DEFENSE) and tc:IsSetCard(0xa110)
end
function c77240284.target9(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if chk==0 then return a:IsOnField() and a:GetControler(1-tp) end
	Duel.SetTargetCard(a)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,a,1,0,0)
end
function c77240284.operation9(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local dam=tc:GetAttack()
	if tc:IsRelateToEffect(e) and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		 Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
function c77240284.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or not g:IsContains(c) then return false end
	return rp==1-tp
end
function c77240284.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77240284.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
end
function c77240284.filter9(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c77240284.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		and not Duel.IsExistingMatchingCard(c77240284.filter9,tp,0,LOCATION_MZONE,1,nil)
end

function c77240284.atkfilter(c)
return c:GetFlagEffect(77240284)>0
end
function c77240284.atkval(e,c)
	local eg=c:GetEquipGroup():Filter(c77240284.atkfilter,nil)
	local atk=eg:GetSum(Card.GetAttack)
	return atk 
end
function c77240284.desval(e,c)
	local eg=c:GetEquipGroup():Filter(c77240284.atkfilter,nil)
	local des=eg:GetSum(Card.GetDefense)
	return des
end
function c77240284.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c77240284.filter(c)
	return c:IsSetCard(0x29) and c:IsRace(RACE_DRAGON) and not c:IsForbidden()
end
function c77240284.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())
	local sg=Duel.GetLocationCount(tp,LOCATION_SZONE,0)
	if chk==0 then return sg>=#mg end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,mg,#mg,0,0)
end
function c77240284.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())
	local sg=Duel.GetLocationCount(tp,LOCATION_SZONE,0)
	if sg<#mg then return end
	local tc=mg:GetFirst()
	while tc do
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(c)
		e1:SetValue(c77240284.eqlimit)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(77240284,RESET_EVENT+0x1de0000,0,1)
	tc=mg:GetNext()
	end 
end
function c77240284.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c77240284.xyzfilter1(c,masterc)
	return c:IsCanBeXyzMaterial(masterc) and c:IsSetCard(0xa110)
end
function c77240284.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
	return Duel.IsExistingMatchingCard(c77240284.xyzfilter1,tp,LOCATION_MZONE,0,3,nil,c)
end
function c77240284.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c77240284.xyzfilter1,tp,LOCATION_MZONE,0,3,3,nil,c)
	local tc=g1:GetFirst()
	while tc do
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		tc=g1:GetNext()
	end
	if g1:GetCount()<0 then return end
	c:SetMaterial(g1)
	Duel.Overlay(c,g1)
end