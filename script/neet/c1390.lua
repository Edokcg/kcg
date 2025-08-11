--天启之圣像骑士(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon Procedure
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT),2,4,s.lcheck)	
	--Gains ATK equal to the ATK of the monsters it points to
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--Monsters this card points to cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.atklimit)
	c:RegisterEffect(e2)
	--Negate activation
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.discon)
	e3:SetCost(s.discost)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3)
end
s.listed_series={0x116,0xfe}
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,SET_CRUSADIA,lc,sumtype,tp) and g:IsExists(Card.IsType,1,nil,TYPE_LINK,lc,sumtype,tp)
end
function s.atkval(e,c)
	local g=e:GetHandler():GetLinkedGroup():Filter(Card.IsFaceup,nil) 
	return g:GetSum(Card.GetBaseAttack)
end
function s.atklimit(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev)
end
function s.cfilter(c,g)
	return g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.cfilter,1,false,nil,nil,lg) end
	local g=Duel.SelectReleaseGroupCost(tp,s.cfilter,1,1,false,nil,nil,lg)
	Duel.Release(g,REASON_COST)
	if g:GetFirst():IsSetCard(0x116) or g:GetFirst():IsSetCard(0xfe) then e:SetLabel(1) end
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.thfilter(c,ft,e,tp)
	return c:IsSetCard(0x116) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then 
		if re:GetHandler():IsRelateToEffect(re) then Duel.Destroy(eg,REASON_EFFECT) end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if e:GetLabel()==1 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,ft,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK,0,1,1,nil,ft,e,tp):GetFirst()
			if not sc then return end
			aux.ToHandOrElse(sc,tp,
				function(sc)
					return ft>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				end,
				function(sc)
					return Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
				end,
				aux.Stringid(id,2))
		end
	end
end