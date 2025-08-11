--奥利哈刚 九头狂蛇(ZCG)
function c77239227.initial_effect(c)
	--flip
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239227.spcon)	
    e1:SetOperation(c77239227.activate)
    c:RegisterEffect(e1)
	
    --
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FLIP+EFFECT_TYPE_SINGLE)
    e2:SetTarget(c77239227.tg)
    e2:SetOperation(c77239227.op)
    c:RegisterEffect(e2)	
end
---------------------------------------------------------------
function c77239227.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER)>0
end
function c77239227.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
end
---------------------------------------------------------------
function c77239227.filter(c)
    return c:IsLevelBelow(7) and c:IsSetCard(0xa50) and c:IsAbleToHand()
end
function c77239227.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239227.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c77239227.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end