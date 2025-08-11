--奥利哈刚 天空龙(ZCG)
function c77239232.initial_effect(c)
	--通常召唤
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c77239232.ttcon)
	e1:SetOperation(c77239232.ttop)
	e1:SetValue(SUMMON_TYPE_TRIBUTE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c77239232.setcon)
	c:RegisterEffect(e2)
	
	--召唤不会被无效
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	
	--特殊召唤
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c77239232.spcon)
	e4:SetOperation(c77239232.spop)
	c:RegisterEffect(e4)	
	
	--抗性
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c77239232.efilter)
	c:RegisterEffect(e5)
	
	--攻守变化
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c77239232.adval)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
	
	--下降攻击力
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_ATKCHANGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetCondition(c77239232.atkcon)
	e8:SetTarget(c77239232.atktg)
	e8:SetOperation(c77239232.atkop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e10)
end
----------------------------------------------------------
function c77239232.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c77239232.spop(e,tp,eg,ep,ev,re,r,rp,c)
	  local c=e:GetHandler()
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
----------------------------------------------------------
function c77239232.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function c77239232.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c77239232.setcon(e,c,minc)
	if not c then return true end
	return false
end
---------------------------------------------------------
function c77239232.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*2000
end
---------------------------------------------------------
function c77239232.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
---------------------------------------------------------
function c77239232.atkfilter(c, tp)
	return c:IsControler(tp) and c:IsPosition(POS_FACEUP)
	--and (not e or c:IsRelateToEffect(e))
	-- and not c:IsRace(RACE_CREATORGOD)
end

function c77239232.atkcon(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(c77239232.atkfilter, 1, nil, 1 - tp)
end

function c77239232.atktg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return eg:IsContains(chkc) and c77239232.atkfilter(chkc,tp) end
	if chk == 0 then
		return e:GetHandler():IsRelateToEffect(e)
	end
	Duel.SetTargetCard(eg:Filter(c77239232.atkfilter,nil,1-tp))
end

function c77239232.atkop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
	local dg = Group.CreateGroup()
	local c = e:GetHandler()
	if g:GetCount() > 0 then
		local tc = g:GetFirst()
		local atk=tc:GetAttack()
		while tc do
			local preatk = tc:GetAttack()
			local predef = tc:GetDefense()
			if tc:GetPosition() == POS_FACEUP_ATTACK and preatk > 0 then
				local e1 = Effect.CreateEffect(c)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-5000)
				e1:SetReset(RESET_EVENT + 0x1fe0000)
				tc:RegisterEffect(e1)
				if tc:GetAttack() == 0 then
					dg:AddCard(tc)
				end
			end

			if tc:GetPosition() == POS_FACEUP_DEFENSE and predef > 0 then
				local e1 = Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_UPDATE_DEFENSE)
				e1:SetValue(-5000)
				e1:SetReset(RESET_EVENT + 0x1fe0000)
				tc:RegisterEffect(e1)
				if tc:GetDefense() == 0 then
					dg:AddCard(tc)
				end
			end
			tc = g:GetNext()
		end
		Duel.Destroy(dg, REASON_EFFECT)
		Duel.Damage(1-tp,5000-atk,REASON_EFFECT)
	end
end