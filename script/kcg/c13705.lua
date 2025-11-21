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
	--Special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetOperation(s.op)
	e2:SetLabelObject(e3)
	c:RegisterEffect(e2)
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
		e:SetLabel(tatk)
	end
end

function s.op(e,tp,eg,ep,ev,re,r,rp)
	local res=(Duel.IsPhase(PHASE_STANDBY) and Duel.IsTurnPlayer(tp)) and 2 or 1
	local turn_asc=(Duel.GetCurrentPhase()<PHASE_STANDBY and Duel.IsTurnPlayer(tp)) and 0 or (Duel.IsTurnPlayer(tp)) and 2 or 1
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,4))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetCountLimit(1)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	e1:SetLabel(turn_asc+Duel.GetTurnCount())
	e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_STANDBY|RESET_SELF_TURN,res)
	e:GetHandler():RegisterEffect(e1)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel() and Duel.IsTurnPlayer(tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	local isme=false
	if c:GetReasonEffect()==te then isme=true end
	local atk=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsType,TYPE_XYZ),tp,LOCATION_REMOVED,LOCATION_REMOVED,c):GetSum(Card.GetAttack)
	if isme then atk=e:GetLabel() end
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		if Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,CARD_NUMERON_NETWORK),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and atk>0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		elseif not Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,CARD_NUMERON_NETWORK),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
			Duel.Destroy(e:GetHandler(),REASON_EFFECT)
		end
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