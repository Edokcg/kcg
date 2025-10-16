local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
    Fusion.AddProcMix(c,true,true,511003050,s.ffilter)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.tncon)
	e1:SetOperation(s.tnop)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.valcheck)
	c:RegisterEffect(e0)
end
s.listed_names={511003050}

function s.ffilter(c,fc,sumtype,tp)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(1)
end

function s.valcheck(e,c)
	local g=c:GetMaterial()
    local exg=g:Filter(Card.IsCode,nil,511003050)
    local exg2=c:GetMaterial()
	exg2:Sub(exg)
    if #exg2~=1 then return end
    local lv=0
    local att=0
    for tc in aux.Next(exg2) do
        local templv=0
        if tc:HasLevel() then templv=tc:GetLevel() end
        lv=math.max(lv,templv)
        att=att|tc:GetAttribute()
    end
    local clv=0
    if lv<5 then clv=4
    elseif lv<7 then clv=6
    elseif lv>=7 then clv=8 end
    c:RegisterFlagEffect(511003050,RESET_EVENT+EVENT_TO_DECK,0,1,att)
    c:RegisterFlagEffect(id,RESET_EVENT+EVENT_TO_DECK,0,1,clv)
end

function s.tncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_FUSION)
end
function s.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
    local exg=g:Filter(Card.IsCode,nil,511003050)
    local exg2=c:GetMaterial()
	exg2:Sub(exg)
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
        e0:SetValue(1800)
        e0:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e0)
        local e1=Effect.CreateEffect(c)
        e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
        e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        e1:SetCode(EVENT_ATTACK_ANNOUNCE)
        e1:SetTarget(s.atktg2)
        e1:SetOperation(s.atkop2)
        e1:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e1)
    elseif lv<7 then
        local e0=Effect.CreateEffect(c)
        e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e0:SetType(EFFECT_TYPE_SINGLE)
        e0:SetCode(EFFECT_SET_BASE_ATTACK)
        e0:SetValue(2400)
        e0:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e0)
        local e1=Effect.CreateEffect(c)
        e1:SetCategory(CATEGORY_ATKCHANGE)
        e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        e1:SetCode(EVENT_ATTACK_ANNOUNCE)
        e1:SetTarget(s.atktg)
        e1:SetOperation(s.atkop)
        e1:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e1)
    elseif lv>=7 then
        local e0=Effect.CreateEffect(c)
        e0:SetType(EFFECT_TYPE_SINGLE)
        e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e0:SetCode(EFFECT_SET_BASE_ATTACK)
        e0:SetValue(3000)
        e0:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e0)
        --multiattack
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK)
        e1:SetValue(s.val)
        e1:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e1)
        --immune
        local e2=Effect.CreateEffect(c)
        e2:SetDescription(aux.Stringid(46132282,0))
        e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
        e2:SetCode(EVENT_SPSUMMON_SUCCESS)
        e2:SetOperation(s.effop)
        e2:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e2)   
	end
end

function s.filter(c,att)
	return c:IsFaceup() and bit.band(att,c:GetAttribute())~=0
end

function s.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local att=c:GetAttribute()
    local att=c:GetAttribute()
    local bt=e:GetHandler():GetBattleTarget()
	if chk==0 then return bt and bit.band(att,bt:GetAttribute())~=0 and (bt:GetAttack()>0 or not bt:IsDisabled()) end
end
function s.atkop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local att=c:GetAttribute()
    local att=c:GetAttribute()
    local bt=c:GetBattleTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and bt and bt:IsFaceup() and (bt:GetAttack()>0 or not bt:IsDisabled()) then
		if bt:GetAttack()>0 then
			local e1=Effect.CreateEffect(c)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
			bt:RegisterEffect(e1)
		end
        if not bt:IsDisabled() then
			local e1=Effect.CreateEffect(c)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
			bt:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            bt:RegisterEffect(e2)
            if bt:IsType(TYPE_TRAPMONSTER) then
                local e3=e1:Clone()
                e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
                bt:RegisterEffect(e3)
            end
		end
	end
end

function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local att=e:GetHandler():GetAttribute()
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),att) end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local att=c:GetAttribute()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c,att)
		local atk=g:GetSum(Card.GetAttack)
		if atk>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
			c:RegisterEffect(e1)
		end
	end
end

function s.val(e,c)
	if Duel.IsExistingMatchingCard(s.filter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttribute()) then
		return 2
	else 
		return 1
	end
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		c:RegisterEffect(e2)
	end
end
