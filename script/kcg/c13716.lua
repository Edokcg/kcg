--Number CI1000: Numerronius Numerronia
local s, id = GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,nil,13,5)
	c:EnableReviveLimit()

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--cannot special summon
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetType(EFFECT_TYPE_SINGLE)
	-- e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	-- e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	--c:RegisterEffect(e1)

	-- Negate Effects
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetTargetRange(0, LOCATION_MZONE)
    e1:SetTarget(s.actfilter)
    c:RegisterEffect(e1)
    local e10 = e1:Clone()
    e10:SetCode(EFFECT_DISABLE_EFFECT)
    c:RegisterEffect(e10)

	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87997872,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetCondition(s.value)
	c:RegisterEffect(e3)

	--indestructible
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_SINGLE) 
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE) 
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT) 
	e4:SetValue(1) 
	c:RegisterEffect(e4) 

	--atk restriction
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_MUST_ATTACK)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e6:SetValue(s.attg)
	c:RegisterEffect(e6)

	--win
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY+EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetCountLimit(1)
	e7:SetCondition(s.wincon)
	e7:SetOperation(s.winop)
	c:RegisterEffect(e7)

	--disable attack
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(84013237,0))
	e8:SetCategory(CATEGORY_RECOVER)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_ATTACK_ANNOUNCE)
	e8:SetCost(Cost.DetachFromSelf(1))
	e8:SetCondition(s.condition)
	e8:SetTarget(s.atktarget)
	e8:SetOperation(s.atkop)
	c:RegisterEffect(e8)

	-- Destroy a Monster
    local e9 = Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(1639384, 0))
    e9:SetCategory(CATEGORY_DESTROY + CATEGORY_SPECIAL_SUMMON)
    e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e9:SetType(EFFECT_TYPE_QUICK_O)
    e9:SetCode(EVENT_FREE_CHAIN)
    e9:SetHintTiming(0, TIMING_END_PHASE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCountLimit(1)
    e9:SetCost(Cost.DetachFromSelf(1))
    e9:SetTarget(s.target)
    e9:SetOperation(s.operation)
    c:RegisterEffect(e9)
end
s.xyz_number=1000
s.listed_series = {0x48}
s.listed_names={13715}

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.actfilter(e, c)
    return c:IsFaceup() and (c:IsSetCard(0x1048) or c:IsSetCard(0x1073))
end

function s.value(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsCode(13716)
end

function s.attg(e,c)
	return c==e:GetHandler()
end

function s.wincon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsTurnPlayer(tp) and e:GetHandler():GetBattledGroupCount()==0
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(tp,WIN_REASON_NUMBER_iC1000)
end

function s.desfilter(c)
	return c:IsFaceup() and (not c:IsSetCard(0x48) or c:IsSetCard(0x1048))
end
function s.descon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(s.desfilter,c:GetControler(),0,LOCATION_MZONE,1,c)
end

function s.cfilter(c,tp,code)
	return c:IsCode(code) and c:GetPreviousControler()==tp and c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp,13715)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler()
)>0
	and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and eg:IsExists(s.cfilter,1,nil,tp,13715) then
	local g=eg:Filter(s.cfilter,nil,tp,13715)
	e:GetHandler():SetMaterial(g)
	Duel.Overlay(e:GetHandler(),g)
	Duel.Hint(HINT_BGM,tp,aux.Stringid(828, 5))
	Duel.Hint(HINT_MUSIC,tp,aux.Stringid(828, 6))
	Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
	e:GetHandler():CompleteProcedure() end
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() 
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.atktarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetAttacker()
	if chk==0 then return tg:IsOnField() end
	Duel.SetTargetCard(tg)
	local rec=tg:GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:CanAttack() then
		if Duel.NegateAttack(tc) then
			Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
		end
	end
end

function s.filter2(c, e)
    local tpp = c:GetControler()
    return c:IsDestructable()
end
function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return e:GetHandler():CheckRemoveOverlayCard(tp, 1, REASON_COST)
    end
    e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end
function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then
        return chkc:IsLocation(LOCATION_MZONE) and s.filter2(chkc, e) and chkc~=e:GetHandler()
    end
    if chk == 0 then
        return Duel.IsExistingTarget(s.filter2, tp, LOCATION_MZONE, LOCATION_MZONE, 1, e:GetHandler(), e)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
    local g = Duel.SelectTarget(tp, s.filter2, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, e:GetHandler(), e)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, g:GetCount(), 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 0, 0, 0)
end
function s.operation(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    local ttp = tc:GetControler()
    if tc and tc:IsRelateToEffect(e) then
        if Duel.Destroy(tc, REASON_EFFECT) > 0 then
            if Duel.IsExistingMatchingCard(s.filter3, ttp, LOCATION_EXTRA, 0, 1, nil, e, ttp, tc) and Duel.SelectYesNo(tp, aux.Stringid(13717, 0)) then
				Duel.BreakEffect()
                local g2 = Duel.GetFieldGroup(ttp, LOCATION_EXTRA, 0)
                if tp ~= ttp then
                    Duel.ConfirmCards(tp, g2)
                end
                Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
                local g = Duel.SelectMatchingCard(tp, s.filter3, ttp, LOCATION_EXTRA, 0, 1, 1, nil, e, ttp)
                if g:GetCount() > 0 then
                    Duel.SpecialSummon(g, 0, tp, ttp, true, false, POS_FACEUP)
                end
            end
        end
    end
end
function s.filter3(c, e, tp)
	return (c:IsSetCard(0x1048) or c:IsSetCard(0x1073)) 
	and c:IsCanBeSpecialSummoned(e, 0, tp, true, false) 
	and Duel.GetLocationCountFromEx(tp,tp,nil,c) > 0
end