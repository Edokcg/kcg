--奥利哈刚 神的强控者(ZCG)
function c77239217.initial_effect(c)
    --flip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(1834107,0))
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetTarget(c77239217.target)
    e1:SetOperation(c77239217.operation)
    c:RegisterEffect(e1)  
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2) 
    local e3=e1:Clone()
    e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e3) 
	
    --pos
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77239217,1))
    e4:SetCategory(CATEGORY_POSITION)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_ATTACK_ANNOUNCE)
    e4:SetTarget(c77239217.postg)
    e4:SetOperation(c77239217.posop)
    c:RegisterEffect(e4) 
end
--------------------------------------------------------------------------------
function c77239217.thfilter(c)
    return c:IsCode(77239240) and c:IsAbleToHand()
end
function c77239217.thfilter1(c)
    return c:IsCode(77239264) and c:IsAbleToHand()
end
function c77239217.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local rec=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)*500
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c77239217.operation(e,tp,eg,ep,ev,re,r,rp)
    local rec=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)*500
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    Duel.Recover(p,rec,REASON_EFFECT)
    local g=Duel.SelectMatchingCard(tp,c77239217.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    local g1=Duel.SelectMatchingCard(tp,c77239217.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)	
    g:Merge(g1)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)	
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end		
end
--------------------------------------------------------------------------------
function c77239217.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local d=Duel.GetAttackTarget()
    if chkc then return chkc==d end
    if chk==0 then return d and d:IsCanBeEffectTarget(e) end
    Duel.SetTargetCard(d)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,d,1,0,0)
end
function c77239217.posop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
    end
end
