local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
    Xyz.AddProcedure(c,nil,4,2,nil,nil,nil,nil,false)
    Xyz.AddProcedure(c,nil,6,2,nil,nil,nil,nil,false)
    Xyz.AddProcedure(c,nil,8,2,nil,nil,nil,nil,false)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.tncon)
	e1:SetOperation(s.tnop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.valcheck)
	c:RegisterEffect(e2)
end

function s.xyzcheck(g,tp,xyz)
    local chklv=true
    local tc=g:GetFirst()
    local ag=g
    ag:RemoveCard(tc)
    if tc:IsXyzLevel(xyz,4) then
        for ac in aux.Next(ag) do
            if not ac:IsXyzLevel(xyz,4) then chklv=false end
        end
    elseif tc:IsXyzLevel(xyz,6) then
        for ac in aux.Next(ag) do
            if not ac:IsXyzLevel(xyz,6) then chklv=false end
        end
    elseif tc:IsXyzLevel(xyz,8) then
        for ac in aux.Next(ag) do
            if not ac:IsXyzLevel(xyz,8) then chklv=false end
        end
    else
        chklv=false
    end
	return chklv
end

function s.valcheck(e,c)
	local g=c:GetMaterial()
    local lv=0
    local att=0
    for tc in aux.Next(g) do
        if tc:HasLevel() then lv=tc:GetLevel() end
        att=att|tc:GetAttribute()
    end
    c:RegisterFlagEffect(511003050,RESET_EVENT+EVENT_TO_DECK,0,1,att)
    if g:GetClassCount(Card.GetLevel)~=1 then return end
    c:RegisterFlagEffect(id,RESET_EVENT+EVENT_TO_DECK,0,1,lv)
end

function s.tncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ)
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
    e2:SetCode(EFFECT_CHANGE_RANK)
    e2:SetValue(lv)
    c:RegisterEffect(e2)
    if lv<5 then
        local e0=Effect.CreateEffect(c)
        e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e0:SetType(EFFECT_TYPE_SINGLE)
        e0:SetCode(EFFECT_SET_BASE_ATTACK)
        e0:SetValue(1900)
        e0:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e0)
        local e1=Effect.CreateEffect(c)
        e1:SetCode(EVENT_FREE_CHAIN)
        e1:SetType(EFFECT_TYPE_QUICK_O)
        e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
        e1:SetRange(LOCATION_MZONE)
        e1:SetHintTiming(TIMING_DAMAGE_STEP)
        e1:SetCondition(s.atkcon)
        e1:SetCost(s.atkcost)
        e1:SetTarget(s.atktg)
        e1:SetOperation(s.atkop)
        e1:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e1)
    elseif lv<7 then
        local e0=Effect.CreateEffect(c)
        e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e0:SetType(EFFECT_TYPE_SINGLE)
        e0:SetCode(EFFECT_SET_BASE_ATTACK)
        e0:SetValue(2500)
        e0:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e0)
        -- ATK
        local e1=Effect.CreateEffect(c)
        e1:SetCode(EVENT_FREE_CHAIN)
        e1:SetType(EFFECT_TYPE_QUICK_O)
        e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
        e1:SetRange(LOCATION_MZONE)
        e1:SetHintTiming(TIMING_DAMAGE_STEP)
        e1:SetCondition(s.atkcon)
        e1:SetCost(s.atkcost)
        e1:SetTarget(s.atktg)
        e1:SetOperation(s.atkop)
        e1:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e1)
        --Disable
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_BATTLE_START)
        e2:SetRange(LOCATION_MZONE)
        e2:SetOperation(s.disop)
        e2:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e2)
    elseif lv>=7 then
        local e0=Effect.CreateEffect(c)
        e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
        e0:SetType(EFFECT_TYPE_SINGLE)
        e0:SetCode(EFFECT_SET_BASE_ATTACK)
        e0:SetValue(3000)
        e0:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e0)
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(s.deffilter)
		e1:SetReset(RESET_EVENT+EVENT_TO_DECK) 
		c:RegisterEffect(e1)
        --actlimit
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        e2:SetCode(EVENT_ATTACK_ANNOUNCE)
        e2:SetCost(Cost.DetachFromSelf(1))
        e2:SetOperation(s.operation)
        e2:SetReset(RESET_EVENT+EVENT_TO_DECK) 
        c:RegisterEffect(e2)
	end
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()) and Duel.GetAttacker()==e:GetHandler()
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.filter(c,att)
	return c:IsFaceup() and bit.band(att,c:GetAttribute())~=0 and c:GetDefense()>0
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),e:GetHandler():GetAttribute()) end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler():GetAttribute())
		local def=0
		local tc=g:GetFirst()
		while tc do
			local cdef=tc:GetDefense()
			if cdef<0 then cdef=0 end
			def=def+cdef
			tc=g:GetNext()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(def/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
    local att=e:GetHandler():GetAttribute()
	local tc=e:GetHandler():GetBattleTarget()
	if tc and bit.band(att,tc:GetAttribute())~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x57a0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x57a0000)
		tc:RegisterEffect(e2)
	end
end

function s.deffilter(e,c)
    local g=Duel.GetMatchingGroup(s.filter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler():GetAttribute())
	local def=0
	local tc=g:GetFirst()
	while tc do
		local cdef=tc:GetDefense()
		if cdef<0 then cdef=0 end
		def=def+cdef
		tc=g:GetNext()
	end
	return def
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.aclimit)
	e1:SetCondition(s.actcon)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function s.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and not re:GetHandler():IsImmuneToEffect(e)
end
function s.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() 
end
