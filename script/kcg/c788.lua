--觉醒驱动大蛇帝 (KCG)
local s,id=GetID()
function s.initial_effect(c)
    c:EnableCounterPermit(0x577)
    --Link summon
	Link.AddProcedure(c,s.mfilter,4)
	c:EnableReviveLimit()

    --Attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(0xe)
	c:RegisterEffect(e1)

    --Disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(s.distarget)
	c:RegisterEffect(e2)

    --Prevent summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_MSET)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTargetRange(1,1)
	e3:SetTarget(s.tglimit1)
	e3:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_FORCE_SPSUMMON_POSITION)
	c:RegisterEffect(e4)

    --Attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SET_ATTACK_FINAL)
	e5:SetRange(LOCATION_MZONE)
    e5:SetValue(0)
	e5:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e5:SetTarget(s.distarget)
	c:RegisterEffect(e5)

    --Place hydradrive counters when summoned
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_COUNTER)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(s.ctcon)
	e6:SetTarget(s.cttg)
	e6:SetOperation(s.ctop)
	c:RegisterEffect(e6)

    --SendtoGrave
    local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TOGRAVE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(s.cost)
	e7:SetTarget(s.tg)
	e7:SetOperation(s.op)
	c:RegisterEffect(e7)
end
s.listed_series={0x577}

function s.mfilter(c,lc,sumtype,tp)
	return c:IsSetCard(0x577) and c:IsType(TYPE_LINK,lc,sumtype,tp)
end

function s.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_ATTRIBUTE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetValue(0xe)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end

function s.distarget(e,c)
	return c:IsAttribute(e:GetHandler():GetAttribute()) and c:IsType(TYPE_EFFECT) and not c:IsCode(788)
end

function s.tglimit1(e,c)
	return c:IsAttribute(e:GetHandler():GetAttribute()) and c:IsType(TYPE_MONSTER)
end

function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end

function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,4,0,0x577)
end

function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x577,4)
	end
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x577,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x577,1,REASON_COST)
end

function s.filter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_EARTH)
end

function s.filter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER)
end

function s.filter3(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE)
end

function s.filter4(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WIND)
end

function s.filter5(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT)
end

function s.filter6(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK)
end

function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	local g1=Duel.GetMatchingGroup(s.filter1,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_ONFIELD,nil)
    local g3=Duel.GetMatchingGroup(s.filter3,tp,0,LOCATION_ONFIELD,nil)
    local g4=Duel.GetMatchingGroup(s.filter4,tp,0,LOCATION_ONFIELD,nil)
    local g5=Duel.GetMatchingGroup(s.filter5,tp,0,LOCATION_ONFIELD,nil)
    local g6=Duel.GetMatchingGroup(s.filter6,tp,0,LOCATION_ONFIELD,nil)
	if g1:GetCount()~=0
    and g2:GetCount()~=0
    and g3:GetCount()~=0
    and g4:GetCount()~=0
    and g5:GetCount()~=0
    and g6:GetCount()~=0 then
		g1:Merge(g2)
        g1:Merge(g3)
        g1:Merge(g4)
        g1:Merge(g5)
        g1:Merge(g6)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	end
end

function s.op(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	if d==1 then
		local g=Duel.GetMatchingGroup(s.filter1,tp,0,LOCATION_ONFIELD,e:GetHandler())
		Duel.SendtoGrave(g,REASON_EFFECT)
        Duel.Damage(1-tp,g:GetCount()*500,REASON_EFFECT)
	elseif d==2 then
		local g=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_ONFIELD,e:GetHandler())
		Duel.SendtoGrave(g,REASON_EFFECT)
        Duel.Damage(1-tp,g:GetCount()*500,REASON_EFFECT)
    elseif d==3 then
		local g=Duel.GetMatchingGroup(s.filter3,tp,0,LOCATION_ONFIELD,e:GetHandler())
		Duel.SendtoGrave(g,REASON_EFFECT)
        Duel.Damage(1-tp,g:GetCount()*500,REASON_EFFECT)
    elseif d==4 then
		local g=Duel.GetMatchingGroup(s.filter4,tp,0,LOCATION_ONFIELD,e:GetHandler())
		Duel.SendtoGrave(g,REASON_EFFECT)
        Duel.Damage(1-tp,g:GetCount()*500,REASON_EFFECT)
    elseif d==5 then
		local g=Duel.GetMatchingGroup(s.filter5,tp,0,LOCATION_ONFIELD,e:GetHandler())
		Duel.SendtoGrave(g,REASON_EFFECT)
        Duel.Damage(1-tp,g:GetCount()*500,REASON_EFFECT)
	else
		local g=Duel.GetMatchingGroup(s.filter6,tp,0,LOCATION_ONFIELD,e:GetHandler())
		Duel.SendtoGrave(g,REASON_EFFECT)
        Duel.Damage(1-tp,g:GetCount()*500,REASON_EFFECT)
	end
end