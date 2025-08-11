--奥西里斯之天空龙
local s, id = GetID()
function s.initial_effect(c)
    aux.god(c,1,id,0)

    local e001 = Effect.CreateEffect(c)
    e001:SetType(EFFECT_TYPE_SINGLE)
    e001:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e001:SetCode(805)
    e001:SetValue(2)
    c:RegisterEffect(e001)

	c:EnableReviveLimit()

	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)

	--特殊召唤方式
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	--下降对手怪兽攻击、破坏
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetDescription(aux.Stringid(10000020,1))
	e6:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_MZONE)
	--e6:SetCountLimit(10)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetCondition(s.atkcon)
	e6:SetTarget(s.atktg)
	e6:SetOperation(s.atkop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e8)

	--同时当作创造神族怪兽使用
	local e114=Effect.CreateEffect(c)
	e114:SetType(EFFECT_TYPE_SINGLE)
	e114:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e114:SetCode(EFFECT_ADD_RACE)
	e114:SetValue(RACE_DRAGON)
	c:RegisterEffect(e114)

	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e22:SetRange(LOCATION_ONFIELD)
	e22:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e22:SetCountLimit(1)
	e22:SetCode(EVENT_PHASE+PHASE_END)
	e22:SetCondition(s.ocon2)
	e22:SetOperation(s.ermop)
	c:RegisterEffect(e22)
end

function s.ofilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x900) and c:IsType(TYPE_FIELD)
end

function s.spmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end--
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local a=Duel.GetMatchingGroupCount(s.spmfilter,tp,LOCATION_MZONE,0,nil)
	return a>=3 and (Duel.GetLocationCount(tp,LOCATION_MZONE)>=-3)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp, LOCATION_MZONE)<-3 then return end 
	local g=Duel.SelectMatchingCard(c:GetControler(),s.spmfilter,c:GetControler(),LOCATION_ONFIELD,0,3,3,nil)
	if #g<1 then return end
	Duel.Release(g,REASON_COST)
end

function s.ocon2(e)
	return not Duel.IsExistingMatchingCard(s.ofilter2,e:GetHandlerPlayer(),LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function s.ermop(e,tp,eg,ep,ev,re,r,rp,c)
			Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_RULE+REASON_EFFECT)
end
-------------------------------------------------------------------------------------------------------------------
function s.atkfilter(c,tp)
	return c:IsControler(tp) and c:IsPosition(POS_FACEUP) 
	--and (not e or c:IsRelateToEffect(e)) 
--and not c:IsRace(RACE_CREATORGOD)
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.atkfilter,1,nil,1-tp)
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and s.atkfilter(chkc,tp) end
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg:Filter(s.atkfilter,nil,1-tp))
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	if g:GetCount()>0 then
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local predef=tc:GetDefense()
		if tc:GetPosition()==POS_FACEUP_ATTACK and preatk>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-3000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		if tc:GetAttack()==0 then dg:AddCard(tc) end end

		if tc:GetPosition()==POS_FACEUP_DEFENSE and predef>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-3000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		if tc:GetDefense()==0 then dg:AddCard(tc) end end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_RULE+REASON_EFFECT) end
end