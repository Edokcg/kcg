--暗黑抽牌(ZCG)
function c77239564.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_END_PHASE)
    e1:SetCondition(c77239564.con)	
    e1:SetTarget(c77239564.target)	
    e1:SetOperation(c77239564.activate)
    c:RegisterEffect(e1)	

	--
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCondition(c77239564.decon)
    e2:SetTarget(c77239564.detg)
    e2:SetOperation(c77239564.deop)
    c:RegisterEffect(e2)
end

function c77239564.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
--[[function c77239564.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
    local op=Duel.AnnounceType(tp)
    e:SetLabel(op)
end
function c77239564.activate(e,tp,eg,ep,ev,re,r,rp)
    local ty=e:GetLabel()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_DRAW)
    e1:SetOperation(c77239564.desop)
    e1:SetLabel(ty)
    e1:SetReset(RESET_PHASE+PHASE_STANDBY)
    Duel.RegisterEffect(e1,tp)
end
function c77239564.desop(e,tp,eg,ep,ev,re,r,rp)
    local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
    if hg:GetCount()==0 then return end
    Duel.ConfirmCards(1-ep,hg)
    local win=0	
    local tc=hg:GetFirst()
    local opt=e:GetLabel()
    if (opt==0 and tc:IsType(TYPE_MONSTER)) or (opt==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP)) then
        Duel.Draw(tp,1,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,77239564,RESET_PHASE+PHASE_STANDBY,0,0)
		if Duel.GetFlagEffect(tp,77239564)>5 then
			Duel.Win(tp,0x50)
		end
    end
    Duel.ShuffleHand(ep)	
end]]

function c77239564.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	Duel.SetTargetParam(Duel.SelectOption(tp,70,71,72))
end
function c77239564.activate(e,tp,eg,ep,ev,re,r,rp)
    local a=0
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<0 then return end
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
    Duel.BreakEffect()
	local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	while tc and (opt==0 and tc:IsType(TYPE_MONSTER)) or (opt==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP)) do
        local g=Duel.GetDecktopGroup(tp,1)
        local tc=g:GetFirst()
        Duel.Draw(tp,1,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
        a=a+1
        if a==5 then
        Duel.Win(tp,0x20)
        return end
        if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	end
end
function c77239564.decon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_DESTROY)~=0
        and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
        and e:GetHandler():IsPreviousPosition(POS_FACEDOWN)
end
function c77239564.detg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239564.deop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_RULE)
    end
end

