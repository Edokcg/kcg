--邪之千年眼(ZCG)
function c77239575.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_DRAW)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)	
    e2:SetCondition(c77239575.con)	
    e2:SetTarget(c77239575.tg)	
    e2:SetOperation(c77239575.op)
    c:RegisterEffect(e2)	
end
function c77239575.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_DRAW
end
function c77239575.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(77239575,0))
    e:SetLabel(Duel.SelectOption(tp,70,71,72))
end
function c77239575.op(e,tp,eg,ep,ev,re,r,rp)
    if ep==e:GetOwnerPlayer() then return end
    local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
    if hg:GetCount()==0 then return end
    Duel.ConfirmCards(tp,hg)
    local tc=hg:GetFirst()
    while tc do	
	    if tc:IsType(TYPE_SPELL) and e:GetLabel()==1 then
	        Duel.SendtoHand(tc,tp,REASON_EFFECT)
	    elseif tc:IsType(TYPE_TRAP) and e:GetLabel()==2 then
		    Duel.SendtoHand(tc,tp,REASON_EFFECT)
		elseif tc:IsType(TYPE_MONSTER) and e:GetLabel()==0 then
		    if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(77239575,1)) then
			    Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			else
			    Duel.SendtoHand(tc,tp,REASON_EFFECT)
			end
		end
	    tc=hg:GetNext()
	end
    Duel.ShuffleHand(ep)	
end
