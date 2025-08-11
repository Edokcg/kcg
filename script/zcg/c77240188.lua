--星尘龙之盔甲-胸铠(ZCG)
function c77240188.initial_effect(c)
    --Negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c77240188.condition)
	e1:SetCost(aux.StardustCost)
	e1:SetTarget(c77240188.target)
	e1:SetOperation(c77240188.operation)
	c:RegisterEffect(e1)

    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetCode(EVENT_BATTLE_DESTROYING)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetTarget(c77240188.sptg)
    e2:SetOperation(c77240188.spop)
    c:RegisterEffect(e2)
end

function c77240188.condition(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-#tg>0
end

function c77240188.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

function c77240188.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	e:GetHandler():RegisterFlagEffect(77240188,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end

function c77240188.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetTargetCard(bc)
end

function c77240188.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
        e2:SetRange(LOCATION_GRAVE)
        e2:SetCountLimit(1)
        e2:SetCondition(c77240188.spcon2)
        e2:SetOperation(c77240188.spop2)
        tc:RegisterEffect(e2)
    end
end

function c77240188.spcon2(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer() and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
end

function c77240188.spop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.SpecialSummon(c,0,1-tp,1-tp,false,false,POS_FACEUP)
end