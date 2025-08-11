--Number 39: Beyond the Hope
local s, id = GetID()
function s.initial_effect(c)
	c:AddSetcodesRule(0x107f)
	--xyz summon
	Xyz.AddProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	aux.EnableCheckRankUp(c,nil,nil,84013237)

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetValue(s.efilter)
	e1:SetLabel(RESET_EVENT+RESETS_STANDARD)

	--ATK to 0
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(s.atkcon)
	e2:SetValue(0)
	c:RegisterEffect(e2)

	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21521304,1))
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_BATTLE_PHASE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(s.condition)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_RANKUP_EFFECT)
	e5:SetLabelObject(e1)
	c:RegisterEffect(e5)
end
s.xyz_number=39
s.listed_series = {0x48}
s.listed_names={84013237}

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end
function s.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (not c:IsSetCard(0x48) or c:IsSetCard(0x1048))
end
function s.descon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(s.desfilter,c:GetControler(),0,LOCATION_MZONE,1,c)
end

--Immune
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function s.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end

--ATK to 0
function s.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return 
		 tp==e:GetHandler():GetControler() 
		 and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end

--Utopia
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsBattlePhase()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.rmfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAbleToRemove()
end
function s.spfilter(c,e,tp)
	return c:IsCode(84013237) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(s.rmfilter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,s.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	local tc1=g1:GetFirst()
	if not tc1:IsRelateToEffect(e) or Duel.Remove(tc1,POS_FACEUP,REASON_EFFECT)==0 then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)	
	if #g2 < 1 then return end
	if Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	Duel.Recover(tp,(g2:GetFirst():GetAttack())/2,REASON_EFFECT)
end

function s.chkmat(c)
	return c:GetLevel()==6
end
function s.chkmat2(c)
	return c:IsSetCard(0x7f)
end
