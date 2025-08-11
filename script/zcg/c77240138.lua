--战斗终止
function c77240138.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCondition(c77240138.condition)
    e1:SetTarget(c77240138.target)
    e1:SetOperation(c77240138.activate)
    c:RegisterEffect(e1)
end
function c77240138.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end

function c77240138.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end

function c77240138.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsChainDisablable(0) then
        local sel=1
        local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_HAND,nil,TYPE_MONSTER)
        Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(59344077,0))
        if g:GetCount()>0 then
            sel=Duel.SelectOption(1-tp,1213,1214)
        else
            sel=Duel.SelectOption(1-tp,1214)+1
        end
        if sel==0 then
            Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
            local sg=g:Select(1-tp,1,1,nil)
            Duel.ConfirmCards(tp,sg)
            Duel.NegateEffect(0)
            return
        end
    end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.NegateAttack() and Duel.Destroy(tc,REASON_EFFECT) then
        Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
    end
end
