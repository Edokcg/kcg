--女子佣兵 卡灵(ZCG)
function c77239503.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)	
    e1:SetRange(LOCATION_MZONE)	
    e1:SetCountLimit(1)	
	e1:SetTarget(c77239503.target)
	e1:SetOperation(c77239503.activate)
	c:RegisterEffect(e1)
	
    --
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)	
    e2:SetCode(EVENT_BE_BATTLE_TARGET)
    e2:SetRange(LOCATION_MZONE)	
    e2:SetCost(c77239503.cost)	
    e2:SetTarget(c77239503.target2)
    e2:SetOperation(c77239503.activate2)
    c:RegisterEffect(e2)
	
    --negate
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DISABLE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCost(c77239503.cost)		
    e3:SetCondition(c77239503.discon)
    e3:SetTarget(c77239503.distg)
    e3:SetOperation(c77239503.disop)
    c:RegisterEffect(e3)	
end
------------------------------------------------------------------
--[[function c77239503.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)	
end
function c77239503.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetDecktopGroup(tp,1)
    tc=g:GetFirst()
    local g2=Duel.GetDecktopGroup(tp,2)
    tc2=g2:GetFirst()
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==2 then
        if tc:IsType(TYPE_MONSTER) and tc:IsAttribute(ATTRIBUTE_LIGHT) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	        and tc:IsLocation(LOCATION_HAND) and Duel.SelectYesNo(tp,aux.Stringid(77239503,0)) then
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
        end
        if tc2:IsType(TYPE_MONSTER) and tc2:IsAttribute(ATTRIBUTE_LIGHT) and tc2:IsCanBeSpecialSummoned(e,0,tp,false,false)
	        and tc2:IsLocation(LOCATION_HAND) and Duel.SelectYesNo(tp,aux.Stringid(77239503,0)) then
            Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
        end
	end
end]]
function c77239503.spfilter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239503.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
--[[function c77239503.activate(e,tp,eg,ep,ev,re,r,rp)
    if ep~=e:GetOwnerPlayer() then return end
    local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
    if hg:GetCount()==0 then return end
    local dg=hg:Filter(c77238506.spfilter,nil,e,tp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(22567609,1)) then
        Duel.ConfirmCards(1-tp,dg)
		Duel.SpecialSummon(dg,0,tp,tp,true,true,POS_FACEUP)
    end
end]]
function c77239503.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local g1=Duel.GetOperatedGroup()
	Duel.ConfirmCards(1-tp,g1)
	local sg=g1:Filter(c77239503.spfilter,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sdg=sg:Select(tp,sg:GetCount(),sg:GetCount(),nil)
		Duel.SpecialSummon(sdg,0,tp,tp,true,true,POS_FACEUP)
	end 
end
------------------------------------------------------------------
function c77239503.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
    Duel.Destroy(g,REASON_EFFECT)
end
function c77239503.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tg=Duel.GetAttacker()
    if chkc then return chkc==tg end
    if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
    Duel.SetTargetCard(tg)
end
function c77239503.activate2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttacker()
    if tc:IsRelateToEffect(e) then
        Duel.NegateAttack()
    end
end
------------------------------------------------------------------
function c77239503.discon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
    local loc,tg=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TARGET_CARDS)
    if not tg or not tg:IsContains(c) then return false end
    return Duel.IsChainDisablable(ev) and loc~=LOCATION_DECK
end
function c77239503.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c77239503.disop(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.NegateEffect(ev)
end


