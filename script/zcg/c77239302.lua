--殉道者 地狱天神(ZCG)
function c77239302.initial_effect(c)
    c:EnableReviveLimit()
    --特殊召唤
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
    e1:SetCondition(c77239302.spcon)
    c:RegisterEffect(e1)
    --cannot special summon
    local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e2)

	--不受对方卡的效果影响
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    --e3:SetReset(RESET_EVENT+0x1fe0000)
    e3:SetValue(c77239302.efilter)
    c:RegisterEffect(e3)

    --不能直接攻击
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    c:RegisterEffect(e4)

    --不能攻击其他殉道者
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(0,LOCATION_MZONE)
    e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e5:SetValue(c77239302.atlimit)
    c:RegisterEffect(e5)

    --伤害
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_DAMAGE)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCost(c77239302.cost)
    e6:SetTarget(c77239302.target)
    e6:SetOperation(c77239302.operation)
    c:RegisterEffect(e6)

    --[[伤害无效
    local e7=Effect.CreateEffect(c)
    e7:SetCode(EVENT_CHAINING)	
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c77239302.condition)
    e7:SetCost(c77239302.cost1)
    e7:SetOperation(c77239302.operation7)
    c:RegisterEffect(e7)]]
	
	--reflect
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(c77239302.cost1)
	e7:SetCondition(c77239302.condition)
	e7:SetOperation(c77239302.operation7)
	c:RegisterEffect(e7)

	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239302.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239302.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239302.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77239302.disop)
    c:RegisterEffect(e13)
end
-----------------------------------------------------------------------
function c77239302.spfilter(c)
    return c:IsSetCard(0xa60)
end
function c77239302.spcon(e,c)
    if c==nil then return true end
    if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
    local g=Duel.GetMatchingGroup(c77239302.spfilter,c:GetControler(),LOCATION_GRAVE,0,nil)
    local ct=g:GetCount()
    return ct>=20
end
------------------------------------------------------------------------
function c77239302.efilter(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
------------------------------------------------------------------------
function c77239302.atlimit(e,c)
    return c~=e:GetHandler() and c:IsFaceup() and c:IsSetCard(0xa60)
end
------------------------------------------------------------------------
function c77239302.cfilter(c)
    return c:IsSetCard(0xa60) and c:IsAbleToGraveAsCost()
end
function c77239302.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239302.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239302.cfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    e:SetLabel(g:GetFirst():GetAttack())
    Duel.Release(g,REASON_COST)
end
function c77239302.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(e:GetLabel())
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())
end
function c77239302.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
------------------------------------------------------------------------
function c77239302.filter(c)
    return c:IsSetCard(0xa60) and c:IsAbleToRemoveAsCost()
end
function c77239302.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239302.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77239302.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--[[function c77239302.condition(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
    local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
    if ex then return true end
    ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
    if not ex then return false end
    if cp~=tp then return Duel.IsPlayerAffectedByEffect(cp,EFFECT_REVERSE_RECOVER)
    else return Duel.IsPlayerAffectedByEffect(0,EFFECT_REVERSE_RECOVER)
        or Duel.IsPlayerAffectedByEffect(1,EFFECT_REVERSE_RECOVER)
    end
end]]
function c77239302.operation7(e,tp,eg,ep,ev,re,r,rp)
    local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetLabel(cid)
    e1:SetValue(c77239302.refcon)
    e1:SetReset(RESET_CHAIN)
    Duel.RegisterEffect(e1,tp)
end

function c77239302.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and aux.damcon1(e,tp,eg,ep,ev,re,r,rp)
end
function c77239302.refcon(e,re,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or (r&REASON_EFFECT)==0 then return end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	return cid==e:GetLabel()
end

function c77239302.refcon(e,re,val,r,rp,rc)
    local cc=Duel.GetCurrentChain()
    if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
    local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
    if cid==e:GetLabel() then return 0
    else return val end
end
------------------------------------------------------------------------
function c77239302.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239302.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239302.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end
