--龙纹骑士朱红(ZCG)
function c77239691.initial_effect(c)
	Xyz.AddProcedure(c,nil,10,3)
	c:EnableReviveLimit()

	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTarget(c77239691.disable) 
	c:RegisterEffect(e2)	
	
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c77239691.disable)
	c:RegisterEffect(e3)
	
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c77239691.target)
	e4:SetOperation(c77239691.activate)
	c:RegisterEffect(e4)	

	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77239691,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)	
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1)
	e5:SetCost(c77239691.cost)  
	e5:SetTarget(c77239691.tg)
	e5:SetOperation(c77239691.op)
	c:RegisterEffect(e5)	
end
-------------------------------------------------------------------------------------
function c77239691.disable(e,c)
	return c:IsType(TYPE_XYZ)
end
-------------------------------------------------------------------------------------
function c77239691.filter1(c,atk)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAttackBelow(atk)
end
function c77239691.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77239691.filter1,tp,0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack()) end
	local sg=Duel.GetMatchingGroup(c77239691.filter1,tp,0,LOCATION_MZONE,nil,e:GetHandler():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239691.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c77239691.filter1,tp,0,LOCATION_MZONE,nil,e:GetHandler():GetAttack())
	Duel.Destroy(sg,REASON_EFFECT)
end
-------------------------------------------------------------------------------------
function c77239691.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77239691.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP)
end
function c77239691.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c77239691.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)   
	local ft1=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c77239691.filter,tp,LOCATION_DECK,0,nil,e,tp)
	local g1=Duel.GetMatchingGroup(c77239691.filter,1-tp,LOCATION_DECK,0,nil,e,1-tp)
	if tc:GetOwner()==c:GetOwner() and g:GetCount()>0 and ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c77239691.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		end
	elseif tc:GetOwner()~=c:GetOwner() and g1:GetCount()>0 and ft1>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(1-tp,c77239691.filter,1-tp,LOCATION_DECK,0,1,1,nil,e,1-tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,1-tp,1-tp,true,true,POS_FACEUP)
		end	 
	end
end
