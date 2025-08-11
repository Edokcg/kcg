--娱乐伙伴 异色眼魔术小子(neet)
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.efilter)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetValue(s.valcon)
	c:RegisterEffect(e3)
	--DISABLE
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.ditg)
	e4:SetOperation(s.diop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(s.condition)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	e6:SetCost(s.cost)
	e6:SetTarget(s.sptg)
	e6:SetOperation(s.spop)
	c:RegisterEffect(e6)
end
s.listed_series={0x9f,0x98,0x99}
s.listed_names={id}
function s.efilter(e,c)
	local tc=c:GetMaterial()
	local tcc=tc:GetFirst()
	for ttc in aux.Next(tc) do
	if ttc:IsSetCard(0x9f) and c:IsSummonLocation(LOCATION_EXTRA) then return c end
   end
end
function s.valcon(e,re,r,rp)
	return (r&REASON_BATTLE)~=0
end
function s.disfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function s.ditg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.disfilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.disfilter,tp,0,LOCATION_ONFIELD,1,nil)
	local tg=Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,tg,0,0)
end
function s.diop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.disfilter,tp,0,LOCATION_ONFIELD,1,nil)
	local tg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if #g>0 and #tg>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	local tgg=g:Select(tp,1,#tg,nil)
	for tc in aux.Next(tgg) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		end
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.filter(c,e,tp)
	return (c:IsSetCard(0x9f) or c:IsSetCard(0x98) or c:IsSetCard(0x99)) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return s.rescon(sg) and Duel.GetLocationCount(tp,LOCATION_MZONE)>2 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsSetCard,1,nil,0x9f) and sg:IsExists(Card.IsSetCard,1,nil,0x98) and sg:IsExists(Card.IsSetCard,1,nil,0x99)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3
		or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
	if not s.rescon(sg) then return end
	local spg=aux.SelectUnselectGroup(sg,e,tp,3,3,s.rescon,1,tp,HINTMSG_SPSUMMON)
	if #spg==3 then
	Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
	end
end