--植物的愤怒 树椿
function c77239636.initial_effect(c)
    --send to grave
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239636,0))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
    e1:SetTarget(c77239636.target)
    e1:SetOperation(c77239636.operation)
    c:RegisterEffect(e1)
end
function c77239636.tgfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa90) and c:IsAbleToGrave()
end
function c77239636.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239636.filter,tp,LOCATION_DECK,0,2,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c77239636.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239636.tgfilter,tp,LOCATION_DECK,0,2,2,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:GetCount()>0 then
		    local tc=g:GetFirst()
            while tc do
			    --Special Summon
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
                e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
                e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
                e1:SetRange(LOCATION_GRAVE)
                e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,2)				
                e1:SetCountLimit(1)
				e1:SetCondition(c77239636.condition)
                e1:SetTarget(c77239636.target1)
                e1:SetOperation(c77239636.operation1)
                tc:RegisterEffect(e1)
			    tc=g:GetNext()
			end
		end
    end
end
function c77239636.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer()
end
function c77239636.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77239636.operation1(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
    end
end