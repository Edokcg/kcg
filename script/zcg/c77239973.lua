--魔导协调士
function c77239973.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77239973,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCost(c77239973.cost)
	e1:SetTarget(c77239973.sptg)
	e1:SetOperation(c77239973.spoperation)
	c:RegisterEffect(e1)
	--special summon
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetCode(EVENT_BE_MATERIAL)
	e11:SetCondition(c77239973.condition)
	e11:SetTarget(c77239973.target)
	e11:SetOperation(c77239973.operation)
	c:RegisterEffect(e11)
end
function c77239973.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	local ct={}
	for i=2,1,-1 do
		if Duel.IsPlayerCanDiscardDeckAsCost(tp,i) then
			table.insert(ct,i)
		end
	end
	if #ct==1 then 
		Duel.DiscardDeck(tp,ct[1],REASON_COST)
		e:SetLabel(1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77239973,2))
		local ac=Duel.AnnounceNumber(tp,table.unpack(ct))
		Duel.DiscardDeck(tp,ac,REASON_COST)
		e:SetLabel(ac)
	end
end
function c77239973.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,77239974,0x6e,0x4011,1000,1000,4,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c77239973.spoperation(e,tp,eg,ep,ev,re,r,rp)

	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=e:GetLabel()
	if ft>ct then ft=ct end
	if ft<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,77239974,0x6e,0x4011,1000,1000,4,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local ctn=true
	while ft>0 and ctn do
		local token=Duel.CreateToken(tp,77239974)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		ft=ft-1
		if ft<=0  then ctn=false end
	end
	Duel.SpecialSummonComplete()
end


function c77239973.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c77239973.spfilter(c,e,tp)
	return c:IsLevel(2) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239973.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239973.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c77239973.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77239973.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
