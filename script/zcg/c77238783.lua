--真红眼究极龙(ZCG)
function c77238783.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCodeRep(c,77238788,3,true,true)
	
	--Destroy monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77238783,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c77238783.descost)
	e1:SetTarget(c77238783.destg)
	e1:SetOperation(c77238783.desop)
	c:RegisterEffect(e1)
	
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77238783,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	--e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e2:SetRange(LOCATION_MZONE)
    --e2:SetValue(c77239031.efilter)
	e2:SetCost(c77238783.descost)
	e2:SetOperation(c77238783.atop)
	--[[e2:SetValue(1)
	e2:SetCost(c77238783.descost)
	e2:SetReset(RESET_EVENT+0x1fe0000)]] 
	c:RegisterEffect(e2)
	
	--[[spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77238783,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1) 
	e1:SetCost(c77238783.cost)
	e1:SetOperation(c77238783.operation)
	c:RegisterEffect(e1)]]	
end
--[[function c77238783.mgfilter(c,fusc,mg)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE) and bit.band(c:GetReason(),0x40008)==0x40008
	and c:GetReasonCard()==fusc and fusc:CheckFusionMaterial(mg,c)
end
function c77238783.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetMaterial()
	local ct=g:GetCount()
	if chk==0 then return Duel.IsExistingMatchingCard(c77238783.mgfilter,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler(),g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c77238783.mgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e:GetHandler(),g)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c77238783.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local op=Duel.SelectOption(tp,aux.Stringid(77238783,0),aux.Stringid(77238783,1))
	else
		local op=Duel.SelectOption(tp,aux.Stringid(77238783,0))
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end	 
	else
		--cannot be target
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)	  
		e:GetHandler():RegisterEffect(e1)
	end
end]]

function c77238783.filter1(c)
    return c:IsAbleToRemove() and c:IsCode(74677422)
end
function c77238783.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77238783.filter1,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c77238783.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c77238783.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77238783.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c77238783.afilter(e,re)
    return re:GetHandler():IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
end

function c77238783.atop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        --cannot be target
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c77238783.afilter)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
    c:RegisterEffect(e2)
    end
end