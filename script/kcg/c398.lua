--Golden Castle of Stromberg
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--maintain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)

	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.condition)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)

	--Opponent's monsters must attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_MUST_ATTACK)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	c:RegisterEffect(e5)

	--Destroy monsters
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetCondition(s.atkcon)
	e6:SetTarget(s.atktg)
	e6:SetOperation(s.atkop)
	c:RegisterEffect(e6)

	--indes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetValue(1)
	c:RegisterEffect(e7)

	--Cannot End
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_EP)
	e8:SetRange(LOCATION_FZONE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetTargetRange(1,1)
	e8:SetCondition(s.batcon)
	c:RegisterEffect(e8)
end

function s.mtop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    local g2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	if Duel.GetTurnPlayer()~=tp then return end
	local dg=Duel.GetDecktopGroup(tp, math.floor(g/2))
	if g2==0 or g2==1 or Duel.SendtoGrave(dg, REASON_EFFECT)==0 then 
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp 
	and Duel.GetCurrentPhase()~=PHASE_DRAW 
	and Duel.GetCurrentPhase()~=PHASE_STANDBY
	and Duel.GetCurrentPhase()~=PHASE_BATTLE
	and Duel.GetCurrentPhase()~=PHASE_MAIN2
	and Duel.GetCurrentPhase()~=PHASE_END
end
function s.filter(c,e,tp)
	return c:GetLevel()<=4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
      Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,LOCATION_DECK) 
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=g:RandomSelect(tp,1):GetFirst()
		if Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP_ATTACK)==0 then return end
		c:SetCardTarget(g2)
		--Must Attack
		--local e2=Effect.CreateEffect(c)
		--e2:SetType(EFFECT_TYPE_SINGLE)
	      --e2:SetCode(EFFECT_MUST_ATTACK)
		--g2:RegisterEffect(e2)
		--local e3=Effect.CreateEffect(c)
		--e3:SetType(EFFECT_TYPE_FIELD)
		--e3:SetCode(EFFECT_CANNOT_EP)
		--e3:SetRange(LOCATION_MZONE)
		--e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		--e3:SetTargetRange(1,0)
		--e3:SetCondition(s.becon)
		--g2:RegisterEffect(e3)
		Duel.SpecialSummonComplete()
		end
end

function s.becon(e)
return e:GetHandler():CanAttack()
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsDestructable() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	local dam=tg:GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsOnField() and tc:CanAttack() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		if Duel.Damage(1-tp,tc:GetAttack()/2,REASON_EFFECT)>0 then
            Duel.Destroy(tc,REASON_EFFECT) end
	end
end

function s.indval(e,re)
	return re:GetOwner():IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end

function s.batfilter(c)
	return c:CanAttack()
end
function s.batcon(e)
	return Duel.IsExistingMatchingCard(s.batfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
