--殉道者 镜灵蛇
function c77240160.initial_effect(c)
    c:EnableCounterPermit(0xa11)
    --summon success
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(71413901,0))
    e1:SetCategory(CATEGORY_COUNTER)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c77240160.addct)
    e1:SetOperation(c77240160.addc)
    c:RegisterEffect(e1)
	
    --Activate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(71413901,0))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c77240160.descost)
    e2:SetCondition(c77240160.condition)
    e2:SetTarget(c77240160.target)
    e2:SetOperation(c77240160.activate)
    c:RegisterEffect(e2)

    --对方效果发动无效并破坏
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77239091,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_CHAINING)
    e3:SetCost(c77240160.descost)
	e3:SetCondition(c77240160.condition4)
	e3:SetTarget(c77240160.target4)
	e3:SetOperation(c77240160.activate4)
	c:RegisterEffect(e3)

    --奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77240160.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77240160.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77240160.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77240160.disop)
    c:RegisterEffect(e13)
end
---------------------------------------------------------------------
function c77240160.addct(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,LOCATION_GRAVE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xa11)
end
function c77240160.addc(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,LOCATION_GRAVE)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0xa11,ct)
    end
end
---------------------------------------------------------------------
function c77240160.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xa11,1,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0xa11,1,REASON_COST)
end
function c77240160.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function c77240160.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tg=Duel.GetAttacker()
    if chkc then return chkc==tg end
    if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
    Duel.SetTargetCard(tg)
end
function c77240160.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.NegateAttack()
    end
end
---------------------------------------------------------------------
--[[function c77240160.codisable(e,tp,eg,ep,ev,re,r,rp)
    return rp~=tp and Duel.IsChainNegatable(ev)
end
function c77240160.tgdisable(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c77240160.opdisable(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end]]
function c77240160.condition4(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev) and ep~=tp
end
function c77240160.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77240160.activate4(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

function c77240160.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77240160.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77240160.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end