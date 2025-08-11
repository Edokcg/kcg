--DDD超死偉王ホワイテスト・ヘル・アーマゲドン (Anime)
local s,id,alias=GetID()
function s.initial_effect(c)
	alias=c:GetOriginalCodeRule()
	--synchro summon
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xaf),1,1,Synchro.NonTunerEx(Card.IsSetCard,0xaf),1,99)
	--pendulum summon
	Pendulum.AddProcedure(c,false)

	--synchro indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SYNCHRO))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--synchro cannot be target
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)

	--destroy and damage
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,2))
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_ATTACK_ANNOUNCE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCondition(s.descon)
	e7:SetTarget(s.destg)
	e7:SetOperation(s.desop)
	c:RegisterEffect(e7)

	--cannot be negate/disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e4)

	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(alias,1))
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(s.distg)
	e5:SetOperation(s.disop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)

	--pendulum
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,3))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCondition(s.pencon)
	e8:SetTarget(s.pentg)
	e8:SetOperation(s.penop)
	c:RegisterEffect(e8)
end
s.listed_series={0xaf}

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp
end
function s.desfilter1(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x10af) and c:GetAttack()>0
		and Duel.IsExistingMatchingCard(s.desfilter2,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function s.desfilter2(c,atk)
	return c:IsFaceup() and c:IsDefenseBelow(atk)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.desfilter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.desfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,s.desfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	local g=Duel.GetMatchingGroup(s.desfilter2,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,#g*1000)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(s.desfilter2,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
		if #g==0 then return end
		local oc=Duel.Destroy(g,REASON_EFFECT)
		if oc>0 then Duel.Damage(1-tp,oc*1000,REASON_EFFECT) end
	end
end

function s.pfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
		and Duel.IsExistingMatchingCard(Card.IsNegatableMonster,tp,0,LOCATION_MZONE,1,c)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not eg:IsContains(e:GetHandler())
		and Duel.IsExistingMatchingCard(s.pfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	local g=Duel.GetMatchingGroup(Card.IsNegatableMonster,tp,0,LOCATION_MZONE,pc)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g-1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(alias,2))
	local pg=Duel.SelectMatchingCard(1-tp,s.pfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	local pc=pg:GetFirst()
	if not pc then return end
	Duel.HintSelection(pg)
	local c=e:GetHandler()
	local flag=(id+c:GetFieldID()+e:GetFieldID())*2
	local g=Duel.GetMatchingGroup(Card.IsNegatableMonster,tp,0,LOCATION_MZONE,pc)
	g:ForEach(function(tc)
		tc:RegisterFlagEffect(flag,RESET_EVENT+RESETS_STANDARD,0,1)
		--negate
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetLabel(flag)
		e1:SetCondition(s.discon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetLabelObject(e1)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		--reset
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(45014450,2))
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_SUMMON_SUCCESS)
		e3:SetLabel(flag)
		e3:SetLabelObject(e2)
		e3:SetRange(LOCATION_MZONE)
		e3:SetOperation(s.resetop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EVENT_SPSUMMON_SUCCESS)
		e4:SetLabelObject(e3)
		Duel.RegisterEffect(e4,tp)
		e3:SetLabelObject(e4)
	end)
end

function s.resetFilter(c,flag)
	return c:GetFlagEffect(flag)>0
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.resetFilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetLabel())
	g:ForEach(function(tc)
		tc:ResetFlagEffect(e:GetLabel())
	end)
	e:Reset()
	e:GetLabelObject():Reset()
end

function s.discon(e)
	if e:GetHandler():GetFlagEffect(e:GetLabel())>0 then return true
	else e:Reset() return false end
end

function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end