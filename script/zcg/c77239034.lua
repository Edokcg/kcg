--Divine Window(ZCG)
function c77239034.initial_effect(c)
    --reflect
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c77239034.condition)
	e1:SetOperation(c77239034.operation)
    c:RegisterEffect(e1)
	
    --战斗伤害无效
    local e16=Effect.CreateEffect(c)
    e16:SetType(EFFECT_TYPE_ACTIVATE)
    e16:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e16:SetCondition(c77239034.damcon)
    e16:SetOperation(c77239034.damop)
    c:RegisterEffect(e16)
end
---------------------------------------------------------------------
function c77239034.condition(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
    local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
    if ex and (cp==tp or cp==PLAYER_ALL) then return true end
    ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
    return ex and (cp==tp or cp==PLAYER_ALL) and Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)
end
function c77239034.operation(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REFLECT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetLabel(cid)
	e1:SetValue(c77239034.refcon)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetLabel(cid)
	e2:SetValue(c77239034.dammul)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function c77239034.refcon(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	return cid==e:GetLabel()
end
function c77239034.dammul(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	return cid==e:GetLabel() and val+val or val
end
---------------------------------------------------------------------
function c77239034.damcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetBattleDamage(tp)>0
end
function c77239034.damop(e,tp,eg,ep,ev,re,r,rp)
    local dam=Duel.GetBattleDamage(tp)
    Duel.Damage(1-tp,dam*2,REASON_EFFECT)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e1:SetOperation(c77239034.dop)
    e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
    Duel.RegisterEffect(e1,tp)
end
function c77239034.dop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(tp,0)
end