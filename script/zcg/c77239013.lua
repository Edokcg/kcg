--恶作剧的神抽
function c77239013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77239013.target)
	e1:SetOperation(c77239013.activate)
	c:RegisterEffect(e1)
	
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c77239013.reptg)
    e3:SetValue(c77239013.repval)
    e3:SetOperation(c77239013.repop)
    c:RegisterEffect(e3)	
end
------------------------------------------------------------------
function c77239013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)	
end
function c77239013.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetDecktopGroup(tp,1)
    tc=g:GetFirst()
    local g2=Duel.GetDecktopGroup(tp,2)
    tc2=g2:GetFirst()
    local g3=Duel.GetDecktopGroup(tp,3)
    tc3=g3:GetFirst()
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
	    local dc=Duel.GetOperatedGroup()
        Duel.ConfirmCards(1-tp,dc)			
		local cc=dc:Filter(Card.IsLocation,nil,LOCATION_HAND)
	    local ct=cc:GetCount()
	    if ct>0 and Duel.SelectYesNo(p,aux.Stringid(77239013,0))then
		    Duel.BreakEffect()
			local cg=cc:Select(p,1,ct,nil)
			Duel.HintSelection(cg)
			Duel.SendtoGrave(cg,REASON_EFFECT+REASON_DISCARD)
		end
	end
    local c=e:GetHandler()
	if tc:IsType(TYPE_TRAP) or tc2:IsType(TYPE_TRAP) or tc3:IsType(TYPE_TRAP) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
        e1:SetTargetRange(LOCATION_HAND,0)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
	end
    if tc:IsType(TYPE_MONSTER) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and tc:IsLocation(LOCATION_HAND) and Duel.SelectYesNo(tp,aux.Stringid(77239013,1)) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
    if tc2:IsType(TYPE_MONSTER) and tc2:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and tc2:IsLocation(LOCATION_HAND) and Duel.SelectYesNo(tp,aux.Stringid(77239013,1)) then
        Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
    end
    if tc3:IsType(TYPE_MONSTER) and tc3:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and tc3:IsLocation(LOCATION_HAND) and Duel.SelectYesNo(tp,aux.Stringid(77239013,1)) then
        Duel.SpecialSummon(tc3,0,tp,tp,false,false,POS_FACEUP)
    end	
	Duel.ShuffleHand(tp)
end	
----------------------------------------------------
function c77239013.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c77239013.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c77239013.repfilter,1,nil,tp) end
    return Duel.SelectYesNo(tp,aux.Stringid(77239013,2))
end
function c77239013.repval(e,c)
    return c77239013.repfilter(c,e:GetHandlerPlayer())
end
function c77239013.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end

