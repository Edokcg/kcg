--装甲 古代兵器
function c77239805.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,5,3)
	c:EnableReviveLimit()

	--[[disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c77239805.disop2)
	c:RegisterEffect(e2)

	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)

	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c77239805.indval)
	c:RegisterEffect(e3)]]

	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77239805,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c77239805.rmcost)
	e1:SetTarget(c77239805.rmtg)
	e1:SetOperation(c77239805.rmop)
	c:RegisterEffect(e1)

	--disable effect
    local e52=Effect.CreateEffect(c)
    e52:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e52:SetCode(EVENT_CHAIN_SOLVING)
    e52:SetRange(LOCATION_MZONE)
    e52:SetOperation(c77239805.disop2)
    c:RegisterEffect(e52)
    --disable
    local e53=Effect.CreateEffect(c)
    e53:SetType(EFFECT_TYPE_FIELD)
    e53:SetCode(EFFECT_DISABLE)
    e53:SetRange(LOCATION_MZONE)
    e53:SetTargetRange(0,1)
    e53:SetTarget(c77239805.distg2)
    c:RegisterEffect(e53)
    --self destroy
    local e54=Effect.CreateEffect(c)
    e54:SetType(EFFECT_TYPE_FIELD)
    e54:SetCode(EFFECT_SELF_DESTROY)
    e54:SetRange(LOCATION_MZONE)
    e54:SetTargetRange(0,1)
    e54:SetTarget(c77239805.distg2)
    c:RegisterEffect(e54)
end
---------------------------------------------------------------------
--[[function c77239805.disop2(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if g and g:IsContains(e:GetHandler()) then
			if rp~=tp and re:GetHandler():IsRelateToEffect(re) then
				--unaffectable
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e1:SetRange(LOCATION_MZONE)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetValue(c77239805.efilter)
				e1:SetLabelObject(re:GetHandler())  
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
				e:GetHandler():RegisterEffect(e1)
			end
		end
	end
end
function c77239805.efilter(e,te)
	local tc=e:GetLabelObject()
	return te:GetHandler():IsCode(tc:GetCode())
end]]
function c77239805.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
---------------------------------------------------------------------
function c77239805.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77239805.filter(c)
	return c:IsAbleToRemove()
end
function c77239805.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c77239805.filter,1-tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c77239805.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
	local g=Duel.GetMatchingGroup(c77239805.filter,1-tp,LOCATION_DECK,0,nil):RandomSelect(1-tp,math.floor(g2/2))
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end

function c77239805.disop2(e,tp,eg,ep,ev,re,r,rp)
    if re:GetHandler():IsControler(1-tp) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
        local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
        if g and g:IsContains(e:GetHandler()) then
            if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
                Duel.Destroy(re:GetHandler(),REASON_EFFECT)
            end
        end
    end
end
function c77239805.distg2(e,c)
    return c:GetCardTargetCount()>0 and c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
        and c:GetCardTarget():IsContains(e:GetHandler())
end