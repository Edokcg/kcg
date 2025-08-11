-- 不死之太阳神·翼神龙
function c77238102.initial_effect(c)
    c:EnableReviveLimit()

    local e0 = Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e0)
    -- 召唤方式
    local e1 = Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c77238102.ttcon)
    e1:SetOperation(c77238102.ttop)
    e1:SetValue(SUMMON_TYPE_TRIBUTE)
    c:RegisterEffect(e1)

    local e2 = Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetOperation(c77238102.atkop1)
    c:RegisterEffect(e2)

    -- summon
    local e5 = Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e5)

    -- One Turn Kill
    local e9 = Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(77238102, 0))
    e9:SetCategory(CATEGORY_ATKCHANGE)
    e9:SetType(EFFECT_TYPE_IGNITION)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCost(c77238102.atkcost)
    e9:SetOperation(c77238102.atkop)
    c:RegisterEffect(e9)

    --
    local e10 = Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(77238102, 1))
    e10:SetCategory(CATEGORY_NEGATE)
    e10:SetType(EFFECT_TYPE_QUICK_O)
    e10:SetRange(LOCATION_MZONE)
    e10:SetCode(EVENT_BECOME_TARGET)
    e10:SetCondition(c77238102.con)
    e10:SetCost(c77238102.cost)
    e10:SetTarget(c77238102.target)
    e10:SetOperation(c77238102.activate)
    c:RegisterEffect(e10)
end

function c77238102.spmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ZOMBIE) and c:IsReleasable()
end
function c77238102.ttcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local a=Duel.GetMatchingGroupCount(c77238102.spmfilter,tp,LOCATION_MZONE,0,nil)
	return a>=3 and (Duel.GetLocationCount(tp,LOCATION_MZONE)>=-3)
end
function c77238102.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp, LOCATION_MZONE)<-3 then return end	
	local g=Duel.SelectMatchingCard(c:GetControler(),c77238102.spmfilter,c:GetControler(),LOCATION_MZONE,0,3,3,nil)
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

function c77238102.sumtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return true
    end
    Duel.SetOperationInfo(0, CATEGORY_ATKCHANGE, e:GetHandler(), 1, tp, e:GetLabel())
end
function c77238102.sumop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(e:GetLabel())
        e1:SetReset(RESET_EVENT + RESETS_STANDARD_DISABLE + RESET_PHASE + PHASE_END)
        c:RegisterEffect(e1)
    end
end

function c77238102.spmfilter(c)
    return c:IsRace(RACE_ZOMBIE)
end
function c77238102.spcon(e, c)
    if c == nil then
        return true
    end
    local tp = c:GetControler()
    local a = Duel.GetMatchingGroupCount(c77238102.spmfilter, tp, LOCATION_MZONE, 0, nil)
    return a >= 3 and (Duel.GetLocationCount(tp, LOCATION_MZONE) >= -3)
end
function c77238102.spop1(e, tp, eg, ep, ev, re, r, rp, c)
    if Duel.GetLocationCount(tp, LOCATION_MZONE) < -3 then
        return
    end
    local g = Duel.SelectMatchingCard(c:GetControler(), c77238102.spmfilter, c:GetControler(), LOCATION_ONFIELD, 0, 3,
                                      3, nil)
    Duel.Release(g, REASON_COST)
    local g2 = Duel.GetOperatedGroup()
    local tc = g2:GetFirst()
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
        tc = g2:GetNext()
    end
    ATK = tatk
    DEF = tdef
end

function c77238102.atkop1(e, tp, eg, ep, ev, re, r, rp)
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

--[[function c77238102.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetChainLimitTillChainEnd(aux.FALSE)
end]]

function c77238102.atkcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetLP(tp) > 100
    end
    local lp = Duel.GetLP(tp)
    e:SetLabel(lp - 100)
    Duel.PayLPCost(tp, lp - 100)
end
function c77238102.atkop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(e:GetLabel())
        e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_DISABLE)
        c:RegisterEffect(e1)
        local e2 = e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        c:RegisterEffect(e2)
    end
end

function c77238102.con(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsContains(e:GetHandler()) and rp == 1 - tp and Duel.IsChainNegatable(ev)
end
function c77238102.cfilter(c)
    return c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemoveAsCost()
end
function c77238102.cost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(c77238102.cfilter, tp, LOCATION_GRAVE, 0, 1, nil)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
    local g = Duel.SelectMatchingCard(tp, c77238102.cfilter, tp, LOCATION_GRAVE, 0, 3, 3, nil)
    Duel.Remove(g, POS_FACEUP, REASON_COST)
end
function c77238102.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsPlayerCanDraw(1 - tp, 1)
    end
    Duel.SetOperationInfo(0, CATEGORY_NEGATE, eg, 1, 0, 0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0, CATEGORY_DESTROY, eg, 1, 0, 0)
    end
end
function c77238102.activate(e, tp, eg, ep, ev, re, r, rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg, REASON_EFFECT)
    end
end
