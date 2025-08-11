local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
    Synchro.AddProcedure(c,s.ffilter,1,1,s.ffilter,1,99,nil,nil,nil,nil,s.reqm)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.tncon)
	e1:SetOperation(s.tnop)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.valcheck)
	c:RegisterEffect(e0)

    local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetTargetRange(LOCATION_MZONE|LOCATION_HAND,0)
	e2:SetOperation(s.synop)
	c:RegisterEffect(e2)
end

function s.ffilter(c,fc,sumtype,tp)
	return c:IsType(TYPE_MONSTER) and c:HasLevel()
end

function s.reqm(sg,sc,tp)
	return sg:GetSum(function (c) return c:GetSynchroLevel(sc) end)<13
end

function s.valcheck(e,c)
	local g=c:GetMaterial()
    if #g<1 then return end
	local exg=g:Filter(Card.IsType,nil,TYPE_TUNER)
    local exg2=c:GetMaterial()
	exg2:Sub(exg)
    if #exg2<1 then return end
    local lv=exg:GetSum(Card.GetLevel)
    local att=0
    for tc in aux.Next(exg2) do
        if tc:HasLevel() then lv=lv+tc:GetLevel() end
        att=att|tc:GetAttribute()
    end
    c:RegisterFlagEffect(511003050,RESET_EVENT+EVENT_TO_DECK,0,1,att)
    c:RegisterFlagEffect(id,RESET_EVENT+EVENT_TO_DECK,0,1,lv)
end

function s.tncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=c:GetFlagEffectLabel(id)
    local att=c:GetFlagEffectLabel(511003050)
    local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e1:SetValue(att)
    e1:SetReset(RESET_EVENT+EVENT_TO_DECK) 
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CHANGE_LEVEL)
    e2:SetValue(lv)
    c:RegisterEffect(e2)
    if lv<5 then
        local e0=Effect.CreateEffect(c)
        e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e0:SetType(EFFECT_TYPE_SINGLE)
        e0:SetCode(EFFECT_SET_BASE_ATTACK)
        e0:SetValue(1600)
        e0:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e0)
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(50903514,0))
        e1:SetCategory(CATEGORY_ATKCHANGE)
        e1:SetType(EFFECT_TYPE_QUICK_O)
        e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
        e1:SetCode(EVENT_FREE_CHAIN)
        e1:SetHintTiming(TIMING_DAMAGE_STEP)
        e1:SetCountLimit(1)
        e1:SetRange(LOCATION_MZONE)
        e1:SetTarget(s.target)
        e1:SetOperation(s.operation)
        e1:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e1)
    elseif lv<7 then
        local e0=Effect.CreateEffect(c)
        e0:SetType(EFFECT_TYPE_SINGLE)
        e0:SetCode(EFFECT_SET_BASE_ATTACK)
        e0:SetValue(2200)
        e0:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e0)
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(50903514,0))
        e1:SetCategory(CATEGORY_ATKCHANGE)
        e1:SetType(EFFECT_TYPE_QUICK_O)
        e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
        e1:SetCode(EVENT_FREE_CHAIN)
        e1:SetHintTiming(TIMING_DAMAGE_STEP)
        e1:SetCountLimit(1)
        e1:SetRange(LOCATION_MZONE)
        e1:SetTarget(s.target)
        e1:SetOperation(s.operation)
        e1:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetDescription(aux.Stringid(31801517,0))
        e2:SetCategory(CATEGORY_ATKCHANGE)
        e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        e2:SetCode(EVENT_ATTACK_ANNOUNCE)
        e2:SetOperation(s.atkop)
        e2:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e2)
    elseif lv>=7 then
        local e0=Effect.CreateEffect(c)
        e0:SetType(EFFECT_TYPE_SINGLE)
        e0:SetCode(EFFECT_SET_BASE_ATTACK)
        e0:SetValue(2800)
        e0:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e0)
        local e1=Effect.CreateEffect(c)
        e1:SetDescription(aux.Stringid(50903514,0))
        e1:SetCategory(CATEGORY_ATKCHANGE)
        e1:SetType(EFFECT_TYPE_QUICK_O)
        e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
        e1:SetCode(EVENT_FREE_CHAIN)
        e1:SetHintTiming(TIMING_DAMAGE_STEP)
        e1:SetCountLimit(1)
        e1:SetRange(LOCATION_MZONE)
        e1:SetTarget(s.target2)
        e1:SetOperation(s.operation2)
        e1:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetDescription(aux.Stringid(31801517,0))
        e2:SetCategory(CATEGORY_ATKCHANGE)
        e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        e2:SetCode(EVENT_ATTACK_ANNOUNCE)
        e2:SetOperation(s.atkop2)
        e2:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e2)
	end
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,e:GetHandler())
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(-1000)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
end

function s.afilter(c)
	return not c:IsDisabled() or c:GetAttack()>0
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.afilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.afilter,tp,0,LOCATION_MZONE,nil)
    if #g<1 then return end
    for tc in aux.Next(g) do
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_ATTACK_FINAL)
        e2:SetValue(0)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2)
        local e1=e2:Clone()
        e1:SetCode(EFFECT_DISABLE)
        tc:RegisterEffect(e1)
        local e3=e2:Clone()
        e3:SetCode(EFFECT_DISABLE_EFFECT)
        tc:RegisterEffect(e3)
        if tc:IsType(TYPE_TRAPMONSTER) then
            local e4=e2:Clone()
            e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
            tc:RegisterEffect(e4)
        end
    end
end

function s.filter(c,att)
	return c:IsFaceup() and bit.band(att,c:GetAttribute())~=0
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local att=c:GetAttribute()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c,att)
		local val=g:GetSum(Card.GetLevel)*200
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end

function s.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local att=c:GetAttribute()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c,att)
		local val=g:GetSum(Card.GetLevel)*500
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end

function s.synop(e,tg,ntg,sg,lv,sc,tp)
	return true,sc==e:GetHandler()
end