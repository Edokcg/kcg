--红莲魔龙的升华（neet）
local s,id=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,{id,0})
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCost(Cost.SelfBanish)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)	
end
s.listed_series={0x1045,0x57}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_SYNCHRO)
		return #pg<=0 and Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g1:GetFirst()
	e:SetLabelObject(sc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp,sc)
	local tuner=g2:GetFirst()
	local rg=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,tuner,e)
	local sg=aux.SelectUnselectGroup(rg,e,tp,nil,nil,s.rescon(tuner,sc),1,tp,HINTMSG_TODECK,s.rescon(tuner,sc))
	sg:AddCard(tuner)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,#sg,tp,LOCATION_GRAVE+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.filter1(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x1045) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function s.filter2(c,e,tp,sc)
	local rg=Duel.GetMatchingGroup(s.filter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,c,e)
	return c:IsSetCard(0x1045) and c:IsMonster() and c:IsAbleToDeck() and aux.SpElimFilter(c,true) 
		and aux.SelectUnselectGroup(rg,e,tp,nil,nil,s.rescon(c,sc),0) and c:IsCanBeEffectTarget(e)
end
function s.rescon(tuner,scard)
	return  function(sg,e,tp,mg)
				sg:AddCard(tuner)
				local res=Duel.GetLocationCountFromEx(tp,tp,sg,scard)>0 and sg:CheckWithSumEqual(Card.GetLevel,scard:GetLevel(),#sg,#sg)
				sg:RemoveCard(tuner)
				return res
			end
end
function s.filter3(c,e)
	return c:HasLevel() and c:IsType(TYPE_TUNER) and c:IsAbleToDeck() and aux.SpElimFilter(c,true) and c:IsCanBeEffectTarget(e)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp,chkc)
	local c=e:GetHandler()
	local sc=e:GetLabelObject()
	local sg=Duel.GetTargetCards(e)
	if #sg==0 or not sc then return end
	local lv=sg:GetSum(Card.GetLevel,nil)
	if lv==sc:GetLevel() and Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) and Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) then
		sc:CompleteProcedure()
	end
end
function s.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1045) and c:IsType(TYPE_SYNCHRO)
end
function s.tgfilter(c)
	return c:IsSetCard(0x57) and c:IsAbleToGrave() and c:IsMonster()
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.atkfilter(chkc) end
	if chk==0 then 
		return Duel.IsExistingTarget(s.atkfilter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local max_ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,max_ct,nil)
	if #g==0 then return end
	if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(#g)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end