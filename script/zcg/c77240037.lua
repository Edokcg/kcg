--奥西里斯之森林战士
function c77240037.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c77240037.destg)
    e1:SetOperation(c77240037.desop)
    c:RegisterEffect(e1)

    --抗性
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetValue(c77240037.efilter11)
	c:RegisterEffect(e11)
	--disable effect
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e12:SetCode(EVENT_CHAIN_SOLVING)
	e12:SetRange(LOCATION_MZONE)
	e12:SetOperation(c77240037.disop12)
	c:RegisterEffect(e12)
	--disable
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetCode(EFFECT_DISABLE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e13:SetTarget(c77240037.distg12)
	c:RegisterEffect(e13)
	--self destroy
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD)
	e14:SetCode(EFFECT_SELF_DESTROY)
	e14:SetRange(LOCATION_MZONE)
	e14:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e14:SetTarget(c77240037.distg12)
	c:RegisterEffect(e14)
end
---------------------------------------------------------------------
function c77240037.desfilter(c,rc)
    return c:IsAttribute(rc)
end
function c77240037.desfilter1(c,rc)
    return c:IsRace(rc)
end
function c77240037.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local op=0
    op=Duel.SelectOption(tp,aux.Stringid(77240037,0),aux.Stringid(77240037,1))
    if op==1 then
        Duel.Hint(HINT_SELECTMSG,tp,563)
        local rc=Duel.AnnounceAttribute(tp,1,0xff)
        Duel.SetTargetParam(rc)
        e:GetHandler():SetHint(CHINT_ATTRIBUTE,rc)
        local g=Duel.GetMatchingGroup(c77240037.desfilter,tp,0,LOCATION_DECK,nil,rc)
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
		e:SetLabel(0)
    else
        Duel.Hint(HINT_SELECTMSG,tp,563)
        local rc=Duel.AnnounceRace(tp,1,0xffffff)
        Duel.SetTargetParam(rc)
        e:GetHandler():SetHint(CHINT_RACE,rc)
        local g=Duel.GetMatchingGroup(c77240037.desfilter1,tp,0,LOCATION_DECK,nil,rc)
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
		e:SetLabel(1)
    end
end
function c77240037.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if e:GetLabel()==0 then
        local g=Duel.GetMatchingGroup(c77240037.desfilter,tp,0,LOCATION_DECK,nil,rc)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    else
	    local g=Duel.GetMatchingGroup(c77240037.desfilter1,tp,0,LOCATION_DECK,nil,rc)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

function c77240037.efilter11(e,te)
	return te:GetHandler():IsSetCard(0xa60)
end
function c77240037.disop12(e,tp,eg,ep,ev,re,r,rp)
	if (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70)) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if g and g:IsContains(e:GetHandler()) then
			if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
				Duel.Destroy(re:GetHandler(),REASON_EFFECT)
			end
		end
	end
end
function c77240037.distg12(e,c)
	return c:GetCardTargetCount()>0 and (re:GetHandler():IsSetCard(0xa50) or re:GetHandler():IsSetCard(0xa70))
		and c:GetCardTarget():IsContains(e:GetHandler())
end