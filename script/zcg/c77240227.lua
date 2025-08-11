--殉道者的庇护（ZCG）
function c77240227.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c77240227.cost)
	e1:SetTarget(c77240227.target)
	e1:SetOperation(c77240227.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c77240227.ntcon)
	e3:SetValue(SUMMON_TYPE_NORMAL)
	c:RegisterEffect(e3)
	e1:SetLabelObject(e3)
--immune
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e13:SetRange(LOCATION_ONFIELD)
	e13:SetCode(EFFECT_IMMUNE_EFFECT)
	e13:SetValue(c77240227.efilter9)
	c:RegisterEffect(e13)
--disable
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_DISABLE)
	e12:SetRange(LOCATION_ONFIELD)
	e12:SetTargetRange(0,LOCATION_ONFIELD)
	e12:SetTarget(c77240227.distg9)
	c:RegisterEffect(e12)
end
function c77240227.distg9(e,c)
	return c:IsSetCard(0xa50)
end
function c77240227.efilter9(e,te)
	return te:GetHandler():IsSetCard(0xa50)
end
function c77240227.cfilter(c,ft,tp)
	return c:IsSetCard(0xa60)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c77240227.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c77240227.cfilter,1,nil,ft,tp) end
	local rg=Duel.SelectReleaseGroup(tp,c77240227.cfilter,1,1,nil,ft,tp)
	Duel.Release(rg,REASON_COST)
end
function c77240227.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.CheckTribute(c,0)
end
function c77240227.filter(c,se)
	if not c:IsSummonableCard() then return false end
	local mi,ma=c:GetTributeRequirement()
	return mi>0 and (c:IsSummonable(true,se) or c:IsMSetable(true,se))
end
function c77240227.get_targets(se,tp)
	local g=Duel.GetMatchingGroup(c77240227.filter,tp,LOCATION_HAND,0,nil,se)
	local minct=5
	local maxct=0
	local tc=g:GetFirst()
	while tc do
		local mi,ma=tc:GetTributeRequirement()
		if mi>0 and mi<minct then minct=mi end
		if ma>maxct then maxct=ma end
		tc=g:GetNext()
	end
	return minct,maxct
end
function c77240227.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local se=e:GetLabelObject()
	if chk==0 then
		local mi,ma=c77240227.get_targets(se,tp)
		if mi==5 then return false end
		return Duel.CheckLPCost(tp,mi*0)
	end
	local mi,ma=c77240227.get_targets(se,tp)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c77240227.sfilter(c,se,ct)
	if not c:IsSummonableCard() then return false end
	local mi,ma=c:GetTributeRequirement()
	return (mi==ct or ma==ct) and (c:IsSummonable(true,se) or c:IsMSetable(true,se)) and c:IsSetCard(0xa60)
end
function c77240227.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ct=e:GetLabel()
	local se=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c77240227.sfilter,tp,LOCATION_HAND,0,1,1,nil,se,ct)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,se)
		local s2=tc:IsMSetable(true,se)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,se)
		else
			Duel.MSet(tp,tc,true,se)
		end
		if  Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(77240227,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
		Duel.Destroy(g2,REASON_EFFECT)
end
	end
end
