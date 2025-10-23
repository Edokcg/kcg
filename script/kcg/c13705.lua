--Number C1: Gate of Chaos Numeron - Shunya
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,2,4,s.ovfilter,aux.Stringid(13705,2))
	c:EnableReviveLimit()

	--cannot destroyed
	  local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(1)
	c:RegisterEffect(e0)

	--selfdes
	-- local e2=Effect.CreateEffect(c)
	-- e2:SetType(EFFECT_TYPE_SINGLE)
	-- e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	-- e2:SetRange(LOCATION_MZONE)
	-- e2:SetCode(EFFECT_SELF_DESTROY)
	-- e2:SetCondition(s.descon)
	-- c:RegisterEffect(e2)

	--Banish and Damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9161357,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCondition(s.rmcon)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
end 
s.xyz_number=1
s.listed_series = {0x48}
s.listed_names={41418852,15232745}

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.ovfilter(c)
	return c:IsFaceup() and c:IsCode(15232745) 
	--and Duel.IsExistingMatchingCard(s.damfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end

-- function s.descon(e)
-- 	local c=e:GetHandler()
-- 	return not Duel.IsExistingMatchingCard(s.damfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
-- end

function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)	
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function s.rrfilter(c,e)
	return c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tatk=c:GetAttack()
	local g=Duel.GetMatchingGroup(s.rrfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if g:GetCount()>0 and c:IsRelateToEffect(e) and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
	local tc=g:GetFirst() 
	local tatk=0
	  while tc do
		local atk=tc:GetPreviousAttackOnField() 
		if atk<0 then atk=0 end 
		tatk=tatk+atk 
		tc=g:GetNext() 
	  end

	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10449150,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCountLimit(1)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	if Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()==tp then
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	else
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
	end
	c:RegisterEffect(e4)

	--damage
	local e5=Effect.CreateEffect(c) 
	e5:SetDescription(aux.Stringid(10449150,2)) 
	e5:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY) 
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET) 
	e5:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e5:SetCondition(s.damcon) 
	e5:SetTarget(s.damtg) 
	e5:SetOperation(s.damop)  
	e5:SetLabel(tatk)
	if Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()==tp then
		e5:SetReset(RESET_EVENT+0x1fe0000-RESET_TOFIELD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	else
		e5:SetReset(RESET_EVENT+0x1fe0000-RESET_TOFIELD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
	end
	c:RegisterEffect(e5) end 
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL+1,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_SPECIAL+1,tp,tp,false,false,POS_FACEUP)
	end
end

function s.damfilter(c)
	return c:IsFaceup() and c:IsCode(41418852)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(s.damfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
	    Duel.SetTargetPlayer(1-tp)
        Duel.SetTargetParam(e:GetLabel())
        Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel()) 
	else
        e:SetProperty(0) 
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),0,0,0) 
	end
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsExistingMatchingCard(s.damfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
        local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
        Duel.Damage(p,d,REASON_EFFECT)
    else
        Duel.Destroy(e:GetHandler(),REASON_EFFECT)
    end
end