--太阳神之翼神龙
local s, id = GetID()
function s.initial_effect(c)
    aux.god(c,1,id,0)

    local e001 = Effect.CreateEffect(c)
    e001:SetType(EFFECT_TYPE_SINGLE)
    e001:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE + EFFECT_FLAG_CANNOT_DISABLE)
    e001:SetCode(805)
    e001:SetValue(3)
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
	
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(s.atkop)
	c:RegisterEffect(e5)
	
	--支付LP1000破坏对方场上所有怪兽
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetDescription(aux.Stringid(10000011,1))
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_ONFIELD)
	e6:SetCountLimit(1)
	e6:SetCost(s.descost)
	e6:SetTarget(s.destg)
	e6:SetOperation(s.desop)
	c:RegisterEffect(e6)

	--解放怪兽增加攻守
	local e70=Effect.CreateEffect(c)
	e70:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e70:SetDescription(aux.Stringid(10000011,0))
	e70:SetCategory(CATEGORY_ATKCHANGE)
	e70:SetType(EFFECT_TYPE_QUICK_O)
	e70:SetCode(EVENT_FREE_CHAIN)
	e70:SetRange(LOCATION_ONFIELD)
	e70:SetCountLimit(1)
	e70:SetCost(s.otkcost2)
	e70:SetOperation(s.otkop2)
	c:RegisterEffect(e70)

	--LP减至1增加攻守
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetDescription(aux.Stringid(110000010,2))
	e7:SetCategory(CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	  e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCost(s.otkcost)
	e7:SetOperation(s.otkop)
	--c:RegisterEffect(e7)

	--同时当作创造神族怪兽使用
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE)
	e14:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e14:SetCode(EFFECT_ADD_RACE)
	e14:SetValue(RACE_CREATORGOD+RACE_DRAGON)
	c:RegisterEffect(e14)
end

function s.spmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasableByEffect()
end
-----------------------------------------------------------
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local a=Duel.GetMatchingGroupCount(s.spmfilter,tp,LOCATION_MZONE,0,nil)
	return a>=3 and (Duel.GetLocationCount(tp,LOCATION_MZONE)>=-3)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp, LOCATION_MZONE)<-3 then return end	
	local g=Duel.SelectMatchingCard(c:GetControler(),s.spmfilter,c:GetControler(),LOCATION_MZONE,0,3,3,nil)
	Duel.Release(g,REASON_COST)
	  local g2=Duel.GetOperatedGroup()
	  local tc=g2:GetFirst()
	  local tatk=0
	  local tdef=0
	  while tc do
	  local atk=tc:GetAttack()
	  local def=tc:GetDefense()
	  if atk<0 then atk=0 end
	  if def<0 then def=0 end
	  tatk=tatk+atk 
	  tdef=tdef+def 
	  tc=g2:GetNext() end
	Original_ATK=tatk
	Original_DEF=tdef
end

function s.ofilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x900) and c:IsType(TYPE_FIELD)
end

function s.ocon2(e)
	return not Duel.IsExistingMatchingCard(s.ofilter2,e:GetHandlerPlayer(),LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function s.ermop(e,tp,eg,ep,ev,re,r,rp,c)
			Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_RULE+REASON_EFFECT)
end
-----------------------------------------------------------------------------------------------------------------
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(Original_ATK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(Original_DEF)
	c:RegisterEffect(e2)
end
-----------------------------------------------------------------------------------------------------------------
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(10000049)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	--e:GetHandler():RegisterEffect(e1)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_RULE+REASON_EFFECT)
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end
--------------------------------------------------------------------------------------------------------------------
function s.otkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>1 end
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,1)
	e:SetLabel(lp-1)
end
function s.otkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		--c:RegisterFlagEffect(10000012,RESET_EVENT+0x1ff0000,nil,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_FUSION)
		c:RegisterEffect(e3)
		  local e4=Effect.CreateEffect(c)
		  e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		  e4:SetCode(EVENT_ADJUST)
		e4:SetRange(LOCATION_MZONE)
		  e4:SetOperation(s.lpop)
		  e4:SetReset(RESET_EVENT+0x1fe0000)
		  c:RegisterEffect(e4) 
		local e5=e4:Clone()
		e5:SetCode(EVENT_CHAIN_SOLVED)
		c:RegisterEffect(e5) 
		local e6=e5:Clone()
		  e6:SetOperation(s.lpop2)
		c:RegisterEffect(e6) 
	end
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	  local ttp=c:GetControler()
	local lp=Duel.GetLP(ttp)
	if c:IsType(TYPE_FUSION) and lp>1 and c:GetFlagEffect(10000082)==0 then
		  Duel.SetLP(ttp,1)
			local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(lp-1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end 
end
function s.lpop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	  local ttp=c:GetControler()
	if c:GetFlagEffect(10000082)~=0 then
			c:ResetFlagEffect(10000082)
	end 
end
--------------------------------------------------------------------------------------------------------------
function s.otkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,nil,1,99,e:GetHandler())
	local tc=g:GetFirst()
    local tatk = 0
    local tdef = 0
    while tc do
        local atk = tc:GetAttack()
        local def = tc:GetDefense()
        if atk < 0 then
            atk = 0
        end
        if def < 0 then
            def = 0
        end
        tatk = tatk + atk
        tdef = tdef + def
        tc = g:GetNext()
    end
    e:SetLabelObject({tatk,tdef})
	Duel.Release(g,REASON_COST)
end

function s.otkop2(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    local tatk=e:GetLabelObject()[1]
    local tdef=e:GetLabelObject()[2]
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(tatk)
        e1:SetReset(RESET_EVENT + 0x1fe0000)
        c:RegisterEffect(e1)
        local e2 = e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetValue(tdef)
        c:RegisterEffect(e2)
    end
end