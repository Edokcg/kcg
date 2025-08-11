--传说骑士 海聂默斯(ZCG)
function c77240204.initial_effect(c)
    c:EnableReviveLimit()
    --cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c77240204.efilter)
	c:RegisterEffect(e1)

    --summon success
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(c77240204.sumsuc)
    c:RegisterEffect(e2)

    --Redirect attack
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c77240204.cbcon)
	e3:SetOperation(c77240204.cbop)
	c:RegisterEffect(e3)

    --sendcard
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetOperation(c77240204.activate)
	c:RegisterEffect(e4)
end

function c77240204.efilter(e,re,rp)
	return re:GetHandler():IsType(TYPE_MONSTER) and re:GetHandler():IsControler(1-(e:GetHandler():GetOwner()))
end

function c77240204.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetTarget(c77240204.distg)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c77240204.disop)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetTargetRange(0,1)
    e3:SetValue(c77240204.aclimit)
    e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
    Duel.RegisterEffect(e3,tp)
end

function c77240204.distg(e,c)
	return c~=e:GetHandler() and c:IsType(TYPE_MONSTER)
end

function c77240204.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_SZONE and re:IsActiveType(TYPE_MONSTER) then
		Duel.NegateEffect(ev)
	end
end

function c77240204.aclimit(e,re,tp)
    return re:GetHandler():IsType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end

function c77240204.cfilter1(c)
    return c:IsCode(77240202) and c:IsAbleToGraveAsCost()
end

function c77240204.cfilter2(c)
    return c:IsCode(77240203) and c:IsAbleToGraveAsCost()
end

function c77240204.cfilter3(c)
    return c:IsCode(77240204) and c:IsAbleToGraveAsCost()
end

function c77240204.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bt=eg:GetFirst()
	return c~=bt and bt:GetControler()==c:GetControler()
	and c:GetFlagEffect(294)==0
	and c:GetFlagEffect(725)==0
end

function c77240204.cbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(294,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end

function c77240204.cbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg2=Duel.GetAttackTarget()
	local tg=Duel.GetAttacker()
	if not (tg:IsOnField() and not tg:IsStatus(STATUS_ATTACK_CANCELED)) or not tg2:IsOnField() then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77240204.cfilter,tp,LOCATION_GRAVE,0,1,99,nil)
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(c:GetAttack()*e:GetLabel())
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	Duel.ChangeAttackTarget(c)
end

function c77240204.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end

function c77240204.desfilter(c,rc)
    return c:IsType(TYPE_MONSTER)
end

function c77240204.activate(e,tp,eg,ep,ev,re,r,rp,c)
    local tg=Duel.SelectMatchingCard(tp,c77240204.desfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SendtoHand(tg,tp,REASON_EFFECT)
end
