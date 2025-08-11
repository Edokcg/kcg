--混沌破坏龙
function c77240058.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77240058,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c77240058.spcost)
	e1:SetTarget(c77240058.sptg)
	e1:SetOperation(c77240058.spop)
	c:RegisterEffect(e1)

	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77240058,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c77240058.damtg)
	e2:SetOperation(c77240058.damop)
	c:RegisterEffect(e2)
end
--------------------------------------------------------------------
function c77240058.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c77240058.filter(c,e,tp)
	return c:GetLevel()==8 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77240058.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c77240058.filter1,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #sg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c77240058.filter,tp,LOCATION_HAND+LOCATION_DECK,0,2,nil,e,tp) and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function c77240058.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c77240058.filter,tp,LOCATION_HAND+LOCATION_DECK,0,2,2,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			tc=g:GetNext()
		end
	end
	local sg=Duel.GetMatchingGroup(c77240058.filter1,tp,0,LOCATION_ONFIELD,nil)
	if sg:GetCount()>0 then 
		Duel.BreakEffect()
		local ct=Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
		if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetValue(ct*800)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
		end
	end
end
function c77240058.filter1(c)
	return c:IsLevelBelow(8)
end
--------------------------------------------------------------------
function c77240058.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=Duel.GetLP(1-tp)/2
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c77240058.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end


