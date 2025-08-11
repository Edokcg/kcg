local s,id=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(s.spcon)
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	e0:SetValue(SUMMON_TYPE_SPECIAL+1)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(s.rcon)
	e1:SetOperation(s.rop)
	c:RegisterEffect(e1)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetCode(511002524)
	e10:SetCondition(s.damcon)
	e10:SetOperation(s.lvop)
	Duel.RegisterEffect(e10,0)

	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e01:SetCode(EFFECT_UPDATE_ATTACK)
	e01:SetRange(LOCATION_MZONE)
	e01:SetValue(s.atkval)
	c:RegisterEffect(e01)

    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.condition)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)

	--immune spell
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.econ)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)

    local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.econ10)
	e6:SetValue(s.efilter10)
	c:RegisterEffect(e6)

    local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(s.spcon2)
	e5:SetTarget(s.sptg2)
	e5:SetOperation(s.spop2)
	c:RegisterEffect(e5)

	--Negate opponent's Spell effects
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,2))
	e9:SetCategory(CATEGORY_NEGATE+CATEGORY_LVCHANGE)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e9:SetCode(EVENT_CHAINING)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetCondition(s.negcon)
	e9:SetTarget(s.negtg)
	e9:SetOperation(s.negop)
	c:RegisterEffect(e9)
end
s.listed_series={0xe7}
s.listed_names={CARD_SHINING_SARCOPHAGUS}
--------------------------------------------------------------------------------------------
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsRace,1,false,1,true,c,c:GetControler(),nil,false,nil,RACE_SPELLCASTER)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,false,true,true,c,nil,nil,false,nil,RACE_SPELLCASTER)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end

function s.rcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():HasLevel() and (ep==1-tp or e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1)
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=eg:GetCount()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or not c:HasLevel() then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetValue(ct)
	c:RegisterEffect(e2)
end

function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(584)>0 then val=c:GetFlagEffectLabel(584) end
	return eg:IsContains(c) and c:GetLevel()~=val
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetLevel()>=8 then c:SetCardData(1, 72443569)
	elseif c:GetLevel()>=4 then c:SetCardData(1, 41175645)
	elseif c:GetLevel()>=1 then c:SetCardData(1, 65726770) end
	c:SetCardData(CARDDATA_LEVEL, math.min(12,c:GetLevel()))
	local ae={c:IsHasEffect(EFFECT_UPDATE_LEVEL)}
	for _, te in ipairs(ae) do
		te:Reset()
	end
	local ae={c:IsHasEffect(EFFECT_CHANGE_LEVEL)}
	for _, te in ipairs(ae) do
		te:Reset()
	end
end

function s.atkval(e,c)
	local ct=c:GetLevel()
	return ct>0 and ct*500
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLevel()>3
        and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsChainNegatable(ev) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
end

function s.econ(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLevel()>7
end
function s.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function s.econ10(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLevel()>9
end
function s.efilter10(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (rp~=tp and c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp)))
		and c:IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():GetLevel()<5
end
function s.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe7)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsSpellEffect() and Duel.IsChainNegatable(ev)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,CARD_SHINING_SARCOPHAGUS),tp,LOCATION_ONFIELD,0,1,nil)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and c:IsRelateToEffect(e) and c:IsFaceup() and c:HasLevel() then
		--Increase its Level by 1
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		c:RegisterEffect(e1)
	end
end