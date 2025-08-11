--青眼白龙·海马仪式
function c77240090.initial_effect(c)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77240090.spcon)
    c:RegisterEffect(e1)

    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(77240090,0))
    e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)	
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)	
    e2:SetTarget(c77240090.sptg)
    e2:SetOperation(c77240090.spop)
    c:RegisterEffect(e2)

    --negate
    --[[local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77240090,1))
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCode(EVENT_CHAINING)
    e3:SetCountLimit(1)
    e3:SetCost(c77240090.cost)
    e3:SetTarget(c77240090.distg)
    e3:SetOperation(c77240090.disop)
    c:RegisterEffect(e3)]]
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77240090,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_CHAINING)
    e3:SetCost(c77240090.cost)
	e3:SetCondition(c77240090.condition4)
	e3:SetTarget(c77240090.target4)
	e3:SetOperation(c77240090.activate4)
	c:RegisterEffect(e3)
    
    --破坏效果
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(77240090,2))
    e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(c77240090.tdtg)
    e4:SetOperation(c77240090.tdop)
    c:RegisterEffect(e4)		
end
----------------------------------------------------------------
function c77240090.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
----------------------------------------------------------------
function c77240090.filter(c,e,tp)
    return c:IsCode(89631139) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77240090.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsExistingMatchingCard(c77240090.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
end
function c77240090.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77240090.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,ft,ft,nil,e,tp)
    if g:GetCount()>0 then
        local fid=e:GetHandler():GetFieldID()
        local tc=g:GetFirst()
        while tc do
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
        Duel.SpecialSummonComplete()
        tc=g:GetNext()
        end
    end
end
----------------------------------------------------------------
--[[function c77240090.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISCARD_COST_CHANGE) then return true end
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c77240090.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c77240090.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end]]

function c77240090.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c77240090.condition4(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev) and ep~=tp
end
function c77240090.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77240090.activate4(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
----------------------------------------------------------------
function c77240090.tdfilter(c)
    return c:IsDestructable()
end
function c77240090.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77240090.tdfilter,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c77240090.tdfilter,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77240090.tdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,c77240090.tdfilter,tp,0,LOCATION_MZONE,1,1,nil)
    local atk=g:GetFirst():GetAttack()  
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.Destroy(g,REASON_EFFECT)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(atk)
        e:GetHandler():RegisterEffect(e1)
    end
end


