--魔导皇(ZCG)
function c77239091.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCondition(c77239091.sprcon)
	e2:SetOperation(c77239091.sprop)
	c:RegisterEffect(e2)
	
    --被破坏特招
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239091,0))
    e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetCondition(c77239091.spcon)
    e3:SetTarget(c77239091.sptg)
    e3:SetOperation(c77239091.spop)
    c:RegisterEffect(e3)

	--对方效果发动无效并破坏
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77239091,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_CHAINING)
    e4:SetCost(c77239091.cost)
	e4:SetCondition(c77239091.condition4)
	e4:SetTarget(c77239091.target4)
	e4:SetOperation(c77239091.activate4)
	c:RegisterEffect(e4)
end
------------------------------------------------------------------------------------------------------
function c77239091.spcfilter(c)
	return (c:IsCode(77239080) or c:IsCode(77239081) or c:IsCode(77239082) or c:IsCode(77239085)) and c:IsAbleToDeckAsCost()
end
function c77239091.mzfilter(c)
	return c:GetSequence()<5 and c:IsLocation(LOCATION_MZONE)
end
function c77239091.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c77239091.spcfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,e:GetHandler())
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	return ft>-4 and mg:GetCount()>3 and (ft>0 or mg:IsExists(c77239091.mzfilter,ct,nil))
end
function c77239091.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c77239091.spcfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,e:GetHandler())
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		g=mg:Select(tp,4,99,nil)
	elseif ft>-3 then
		local ct=-ft+1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		g=mg:FilterSelect(tp,c77239091.mzfilter,ct,ct,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=mg:Select(tp,4-ct,99,g)
		g:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		g=mg:FilterSelect(tp,c77239091.mzfilter,4,99,nil)
	end
	local cg=g:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	local atk=0
		local def=0
	    local tc=g:GetFirst()
	    while tc do
		   local batk=tc:GetTextAttack()
		   local bdef=tc:GetTextDefense()
		   if batk>0 then
			  atk=atk+batk
		   end
		   if bdef>0 then
			  def=def+bdef
		   end
		   tc=g:GetNext()
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
		local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetCode(EFFECT_SET_ATTACK)
	    e1:SetValue(atk)
	    e1:SetReset(RESET_EVENT+0xff0000)
	    c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
	    e2:SetValue(def)
		c:RegisterEffect(e2)
end
------------------------------------------------------------------------------------------------------
function c77239091.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_DESTROY)
end
function c77239091.spfilter(c,e,tp)
    return (c:Iscode(77239080) or c:Iscode(77239081) or c:Iscode(77239082) or c:Iscode(77239085)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239091.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c77239091.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c77239091.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c77239091.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77239091.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
------------------------------------------------------------------------------------------------------
function c77239091.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c77239091.condition4(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev) and ep~=tp
end
function c77239091.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77239091.activate4(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
