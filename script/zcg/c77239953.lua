--黑魔术女孩 黑将(ZCG)
function c77239953.initial_effect(c)
    --battle indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e1:SetCountLimit(1)
    e1:SetValue(c77239953.valcon)
    c:RegisterEffect(e1)
	
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetTarget(c77239953.sptg)
    e2:SetOperation(c77239953.spop)
    c:RegisterEffect(e2)
	
    --negate
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77239953,0))
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE+LOCATION_SZONE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCode(EVENT_CHAINING)
    e3:SetCondition(c77239953.discon)
    e3:SetCost(c77239953.discost)
    e3:SetTarget(c77239953.distg)
    e3:SetOperation(c77239953.disop)
    c:RegisterEffect(e3)	
end
-----------------------------------------------------------------
function c77239953.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0
end
-----------------------------------------------------------------
function c77239953.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c77239953.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    local e1=Effect.CreateEffect(c)
    e1:SetCode(EFFECT_CHANGE_TYPE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+0x1fc0000)
    e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
    c:RegisterEffect(e1)
    Duel.RaiseEvent(c,47408488,e,0,tp,0,0)
end
-----------------------------------------------------------------
function c77239953.discon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
        and Duel.IsChainNegatable(ev) and tp~=ep
end
function c77239953.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetDecktopGroup(tp,1)
    if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
    e:SetLabel(g:GetFirst():GetRace())   
	Duel.DiscardDeck(tp,1,REASON_COST)
end
function c77239953.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c77239953.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
		local sg=Duel.GetMatchingGroup(c77239953.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
		if e:GetLabel()==RACE_SPELLCASTER and Duel.SelectYesNo(tp,aux.Stringid(77239953,1)) and sg:GetCount()>0 then
		    Duel.Destroy(sg,REASON_EFFECT)
		end
    end
end
function c77239953.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end