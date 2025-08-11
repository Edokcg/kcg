--クリベー
--Kuribeh
local s,id=GetID()
function s.initial_effect(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(86585274,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
s.listed_names={44632120,71036835,7021574,CARD_KURIBOH,16404809}
s.listed_series={0xa4}

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa4)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,tp,1500)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1500)
		tc:RegisterEffect(e1)
	end
end

function s.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(s.chk,1,nil,sg,Group.CreateGroup(),44632120,71036835,7021574,CARD_KURIBOH)
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
function s.cfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemoveAsCost()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,44632120)
	local g2=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,71036835)
	local g3=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,7021574)
	local g4=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,CARD_KURIBOH)
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
function s.thfilter(c,e,tp)
	return c:IsCode(16404809) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		tc:CompleteProcedure()
	end
end
