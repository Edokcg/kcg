--クリバー
--Kuribah
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.spcon)
	c:RegisterEffect(e2)

	--special summon (kuribabylon)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)
end
s.listed_names={71036835,7021574,34419588,70914287,CARD_KURIBOH}
s.listed_series={0xa4}

function s.spcfilter1(c,tp)
	return c:IsPreviousSetCard(0xa4) and c:IsPreviousControler(tp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spcfilter1,1,nil,tp)
end
function s.spfilter1(c,e,tp)
	return c:IsAttack(300) and c:IsDefense(200) and not c:IsCode(id)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.spcfilter2(c,tp,code)
	return c:IsCode(code) and c:IsAbleToRemoveAsCost()
		and (c:IsControler(tp) or c:IsFaceup())
end
function s.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(s.chk,1,nil,sg,Group.CreateGroup(),34419588,71036835,7021574,CARD_KURIBOH)
end
function s.chk(c,sg,g,code,...)
	if not c:IsCode(code) then return false end
	local res
	if ... then
		g:AddCard(c)
		res=sg:IsExists(s.chk,1,g,sg,g,...)
		g:RemoveCard(c)
	else
		res=true
	end
	return res
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(s.spcfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp,34419588)
	local g2=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp,71036835)
	local g3=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp,7021574)
	local g4=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp,CARD_KURIBOH)
	local g=g1:Clone()
	g:Merge(g2)
	g:Merge(g3)
	g:Merge(g4)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and #g1>0 and #g2>0 and #g3>0 and #g4>0 
        and c:IsAbleToRemoveAsCost() and aux.SelectUnselectGroup(g,e,tp,4,4,s.rescon,0) end
    local sg=aux.SelectUnselectGroup(g,e,tp,4,4,s.rescon,1,tp,HINTMSG_REMOVE)
    sg:AddCard(c)
    Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function s.spfilter2(c,e,tp)
	return c:IsCode(70914287) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	end
end
