--奥利哈刚 艾亚托斯
function c77239210.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239210.spcon)
    c:RegisterEffect(e1)

    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77239210,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(c77239210.tg)
    e2:SetOperation(c77239210.op)
    c:RegisterEffect(e2)
	local e02=e2:Clone()
    e02:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e02)

	--
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)	
    e3:SetCondition(c77239210.atkcon)
    e3:SetOperation(c77239210.atkop)	
    c:RegisterEffect(e3)	
	
	--
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCondition(c77239210.drcon)
    e4:SetTarget(c77239210.drtg)
    e4:SetOperation(c77239210.drop)
    c:RegisterEffect(e4)	
end
--------------------------------------------------------------------
function c77239210.spfilter(c)
    return c:IsSetCard(0xa50)
end
function c77239210.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239210.spfilter,c:GetControler(),LOCATION_GRAVE,0,1,nil)
end
--------------------------------------------------------------------
function c77239210.filter2(c)
    return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c77239210.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239210.filter2,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c77239210.op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.SelectMatchingCard(tp,c77239210.filter2,tp,LOCATION_DECK,0,1,1,nil)
    if tc then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end
--------------------------------------------------------------------
function c77239210.atkcon(e)
    return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil
end
function c77239210.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local atk=e:GetHandler():GetBattleTarget():GetAttack()
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(atk)
    e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
end
--------------------------------------------------------------------
function c77239210.drcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,0x41)==0x41 and rp~=tp and c:GetPreviousControler()==tp
        and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c77239210.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77239210.drop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.Destroy(g,REASON_RULE)
    end
end