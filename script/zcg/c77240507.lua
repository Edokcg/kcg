--妖歌·异约魂印之盾(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	  --flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil) end
end
function s.filter(c)
	return c:IsLevelAbove(1)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xa150) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,g)
	local g2=g:Filter(s.filter,nil)
	if g2:GetCount()>0 then
		local num=0
		local tc=g2:GetFirst()
		while tc do
			num=num+tc:GetLevel()
			tc=g2:GetNext()
		end
	   if Duel.Recover(tp,num*200,REASON_EFFECT)~=0 then
		if not Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE,0)<=0 then return end
			Duel.BreakEffect()
			if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			   local gg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		 if gg:GetCount()>0 then
			Duel.SpecialSummon(gg,0,tp,tp,false,false,POS_FACEUP)
		 end
		end
		end
		Duel.ShuffleHand(1-tp)
end
end
			

		
	   
