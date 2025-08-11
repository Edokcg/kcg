--殉道者之命运的抉择
function c77240178.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

	--
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_DRAW)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c77240178.con)
    e2:SetOperation(c77240178.desop)
    c:RegisterEffect(e2)
	
    --
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e3:SetCountLimit(1)
    e3:SetValue(c77240178.valcon)
    c:RegisterEffect(e3)

    --奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_SZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77240178.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_SZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77240178.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_SZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77240178.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_SZONE)
    e13:SetOperation(c77240178.disop)
    c:RegisterEffect(e13)
end
---------------------------------------------------------------------
function c77240178.con(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp and Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW
end
function c77240178.desop(e,tp,eg,ep,ev,re,r,rp)
    local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
    if hg:GetCount()==0 then return end
    Duel.ConfirmCards(1-tp,hg)
    local tc=hg:GetFirst()
    while tc do
		if tc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		elseif tc:IsType(TYPE_SPELL) then
			Duel.Recover(tp,1000,REASON_EFFECT)
		else
			Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
		tc=hg:GetNext()
	end
    Duel.ShuffleHand(tp)
end
---------------------------------------------------------------------
function c77240178.valcon(e,re,r,rp)
    return bit.band(r,REASON_EFFECT)~=0
end

function c77240178.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77240178.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77240178.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end