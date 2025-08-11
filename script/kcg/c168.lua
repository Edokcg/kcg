--機皇枢インフィニティ・コア
local s,id=GetID()
function s.initial_effect(c)
	--Cannot be destroyed by battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(s.valcon)
	c:RegisterEffect(e1)

	--Add to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)

	--Special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(s.spcond)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end
s.listed_series={0x13,0x3013}
s.listed_names={178,179,180,181,182}

function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE)~=0
end

function s.filter(c)
	return c:IsSetCard(0x13) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.spcond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,5,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function s.filter2(c,e,tp)
	return c:IsCode(178,179,180,181,182,183) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.exfilter1(c)
	return c:IsFacedown() and c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
function s.exfilter3(c)
	return not c:IsLocation(LOCATION_EXTRA)
end
function s.rescon(ft1,ft2,ft4,ft)
	return	function(sg,e,tp,mg)
				local exnpct=sg:FilterCount(s.exfilter1,nil)
				local nexpct=sg:FilterCount(s.exfilter3,nil)
				local groupcount=#sg
				local res=ft2>=exnpct and ft4>=nexpct and ft>=groupcount
				    and mg:IsExists(Card.IsCode,1,nil,178) 
					and mg:IsExists(Card.IsCode,1,nil,179) 
					and mg:IsExists(Card.IsCode,1,nil,180) 
					and mg:IsExists(Card.IsCode,1,nil,181) 
					and mg:IsExists(Card.IsCode,1,nil,182) 
					and mg:IsExists(Card.IsCode,1,nil,183)
					and(#sg==sg:GetClassCount(Card.GetCode))
				return res, not res
			end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	Duel.Destroy(sg,REASON_EFFECT)
	Duel.BreakEffect()
	local ft=Duel.GetUsableMZoneCount(tp)
	local ft1=Duel.GetLocationCountFromEx(tp)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION)
	local ft4=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		if ft4>0 then ft4=1 end
		ft=1
	end
	local ect=aux.CheckSummonGate(tp)
	if ect then
		ft1 = math.min(ect, ft1)
		ft2 = math.min(ect, ft2)
		ft4 = math.min(ect, ft4)
	end
	local loc=0
	if ft4>0 then loc=loc+LOCATION_GRAVE end
	if ft1>0 or ft2>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	local g=Duel.GetMatchingGroup(s.filter2,tp,loc,0,nil,e,tp)
	if #g<6 or g:GetClassCount(Card.GetCode)<6 then return end
	local sg=aux.SelectUnselectGroup(g,e,tp,6,6,s.rescon(ft1,ft2,ft4,ft),1,tp,HINTMSG_SPSUMMON)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	local sg2 = Duel.GetOperatedGroup()
	if #sg2<1 then return end
	sg2:ForEach(function(c) c:CompleteProcedure() end)
end