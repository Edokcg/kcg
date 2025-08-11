--魔手
function c77239026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c77239026.target)
	e1:SetOperation(c77239026.activate)
	c:RegisterEffect(e1)
end
function c77239026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239026.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local rg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_DECK,nil)
    if rg:GetCount()>0 then
        Duel.ConfirmCards(tp,rg)
        local tg=Group.CreateGroup()               
        local tc=rg:Select(tp,1,1,nil):GetFirst()
        rg:Remove(Card.IsCode,nil,tc:GetCode())
        tg:AddCard(tc)
        Duel.SendtoHand(tc,tp,REASON_EFFECT)
		if e:GetHandler():IsRelateToEffect(e) then
            e:GetHandler():RegisterFlagEffect(77239026,RESET_EVENT+0x1fe0000,0,0)
            local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
            if g:GetCount()==0 then return end
            local sg=g:RandomSelect(1-tp,1)
            Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
        end
    end	
end