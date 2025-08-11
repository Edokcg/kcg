--靈魂攝取 (KA)
local s, id = GetID()
function s.initial_effect(c) 
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(545781,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x900}

function s.filter(c)
	return c:IsSetCard(0x900) and c:IsAbleToGraveAsCost()
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if not sg then return end
	local atk=sg:GetAttack()
			if atk<0 then atk=0 end
	local def=sg:GetDefense()
			if def<0 then def=0 end
	local count=atk+def
	Duel.SendtoGrave(sg,REASON_COST)
	e:SetLabel(count)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(s.filter2,tp,LOCATION_DECK,0,nil,e,tp)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function s.filter2(c,e,tp)
	return c:IsSetCard(0x900) and c:GetLevel()==4 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.BreakEffect()
	local tc=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
