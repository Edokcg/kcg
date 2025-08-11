--黑魔导女孩 LV9(ZCG)
function c77240197.initial_effect(c)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
    e1:SetCondition(c77240197.spcon)
    e1:SetOperation(c77240197.spop)
    c:RegisterEffect(e1)

    --summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e2)

    --SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c77240197.target)
	e3:SetOperation(c77240197.operation)
	c:RegisterEffect(e3)

    --to grave
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetTarget(c77240197.tg)
	e4:SetOperation(c77240197.op)
	c:RegisterEffect(e4)
end

function c77240197.cfilter(c,code)
    return c:IsCode(code) and c:IsReleasable()
end

function c77240197.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77240197.cfilter,tp,LOCATION_ONFIELD,0,1,nil,77240196)
end

function c77240197.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=Duel.SelectMatchingCard(tp,c77240197.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil,77240196)
    Duel.Release(g1,REASON_EFFECT)
end

function c77240197.filter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end

function c77240197.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77240197.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function c77240197.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77240197.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,1-tp,1-tp,true,true,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2,true)
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CANNOT_ATTACK)
        tc:RegisterEffect(e3)
        local e4=Effect.CreateEffect(e:GetHandler())
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
        tc:RegisterEffect(e4)
        local e5=Effect.CreateEffect(e:GetHandler())
        e5:SetType(EFFECT_TYPE_SINGLE)
        e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e5:SetRange(LOCATION_MZONE)
        e5:SetCode(EFFECT_UNRELEASABLE_SUM)
        e5:SetValue(1)
        tc:RegisterEffect(e5)
        local e6=e5:Clone()
        e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
        tc:RegisterEffect(e6)
        local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_SET_ATTACK_FINAL)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD)
		e7:SetValue(0)
		tc:RegisterEffect(e7)
	end
end

function c77240197.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,10) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(10)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,10)
end

function c77240197.op(e,tp,eg,ep,ev,re,r,rp)
	local p,val=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,val,REASON_EFFECT)
end