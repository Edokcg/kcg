--群豪攻击者-从男爵（neet）
local s,id=GetID()
function s.initial_effect(c)
	 Pendulum.AddProcedure(c)
	-- Special Summon self
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
 --Change ATK 
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(id,0))
	e10:SetCategory(CATEGORY_ATKCHANGE)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(1,id+1)
	e10:SetHintTiming(TIMING_DAMAGE_STEP)
	e10:SetCondition(s.atkcon)
	e10:SetOperation(s.atkop)
	c:RegisterEffect(e10)
-- Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e10:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_MOVE)
	e3:SetCountLimit(1,{id,2})
	e3:SetCondition(s.smvcon)
	e3:SetTarget(s.smvtg)
	e3:SetOperation(s.smvop)
	c:RegisterEffect(e3)
end
s.listed_series={0x27a}
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local zone=(1<<c:GetSequence())&0x1f
		return zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local zone=(1<<c:GetSequence())&0x1f
	if zone~=0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
	end
	-- Cannot Special Summon, except "Valiants" and from the Extra Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(s.splimit)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsSetCard(0x27a) and not c:IsLocation(LOCATION_EXTRA)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
		and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())and e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		--Gain ATK
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(600)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end
function s.smvcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_MZONE)
end
function s.filter(c,g)
	return g:IsContains(c) 
end
function s.smvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local cg=e:GetHandler():GetColumnGroup()
	if chkc then return chkc:IsOnField() and s.filter(chkc,cg) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,cg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,PLAYER_ALL,LOCATION_ONFIELD)
end
function s.smvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end