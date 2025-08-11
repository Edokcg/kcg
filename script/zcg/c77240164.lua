--殉道者 魔导领主
function c77240164.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c77240164.destg)
    e1:SetOperation(c77240164.desop)
    c:RegisterEffect(e1)

    --奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77240164.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77240164.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77240164.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77240164.disop)
    c:RegisterEffect(e13)
end
function c77240164.dectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
    local op=Duel.SelectOption(tp,aux.Stringid(77240164,0),aux.Stringid(77240164,1))
    e:SetLabel(op)
end
--[[function c77240164.decop(e,tp,eg,ep,ev,re,r,rp,chk)
    local op=e:GetLabel()
    local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if op==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
        local rc=Duel.AnnounceRace(tp,1,RACE_ALL)
		Duel.ConfirmCards(1-tp,g)
        local tg=g:Filter(Card.IsIsRace,nil,rc)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		local rc=Duel.AnnounceAttribute(tp,1,0xff-e:GetHandler():GetAttribute())
		Duel.ConfirmCards(1-tp,g)
        local tg=g:Filter(Card.IsAttribute,nil,rc)
    end
	if tg:GetCount()>0 then
        Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
        Duel.ShuffleHand(1-tp)
    end
end]]
function c77240164.desfilter(c,rc)
    return c:IsAttribute(rc)
end
function c77240164.desfilter1(c,rc)
    return c:IsRace(rc)
end
function c77240164.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local op=0
    op=Duel.SelectOption(tp,aux.Stringid(77240164,0),aux.Stringid(77240164,1))
    if op==1 then
        Duel.Hint(HINT_SELECTMSG,tp,563)
        local rc=Duel.AnnounceAttribute(tp,1,0xff)
        Duel.SetTargetParam(rc)
        e:GetHandler():SetHint(CHINT_ATTRIBUTE,rc)
        local g=Duel.GetMatchingGroup(c77240164.desfilter,tp,0,LOCATION_DECK,nil,rc)
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
		e:SetLabel(0)
    else
        Duel.Hint(HINT_SELECTMSG,tp,563)
        local rc=Duel.AnnounceRace(tp,1,0xffffff)
        Duel.SetTargetParam(rc)
        e:GetHandler():SetHint(CHINT_RACE,rc)
        local g=Duel.GetMatchingGroup(c77240164.desfilter,tp,0,LOCATION_DECK,nil,rc)
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
		e:SetLabel(1)
    end
end
function c77240164.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if e:GetLabel()==0 then
        local g=Duel.GetMatchingGroup(c77240164.desfilter,tp,0,LOCATION_DECK,nil,rc)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    else
	    local g=Duel.GetMatchingGroup(c77240164.desfilter1,tp,0,LOCATION_DECK,nil,rc)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

function c77240164.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77240164.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77240164.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end