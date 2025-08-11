--游戏 神的天空龙(ZCG)
function c77239908.initial_effect(c)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239908.spcon)
    e1:SetOperation(c77239908.spop)
    c:RegisterEffect(e1)

    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(c77239908.destg)
    e2:SetOperation(c77239908.desop)
    c:RegisterEffect(e2)	
	
    --disable
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e3:SetTarget(c77239908.distg)
    c:RegisterEffect(e3)
    --disable effect
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_CHAIN_SOLVING)
    e4:SetRange(LOCATION_MZONE)
    e4:SetOperation(c77239908.disop)
    c:RegisterEffect(e4)
    --disable trap monster
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_DISABLE_TRAPMONSTER)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e5:SetTarget(c77239908.distg)
    c:RegisterEffect(e5)

    --Destroy replace
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EFFECT_DESTROY_REPLACE)
    e6:SetTarget(c77239908.desreptg)
    c:RegisterEffect(e6)

    --draw
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetOperation(c77239908.op)
    c:RegisterEffect(e7)	
end
----------------------------------------------------------------------------------
function c77239908.filter(c,e,tp)
    return c:IsRace(RACE_DRAGON)
end
function c77239908.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77239908.filter,tp,LOCATION_HAND,0,2,c)
end
function c77239908.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local g=Duel.SelectMatchingCard(tp,c77239908.filter,tp,LOCATION_HAND,0,2,2,c)
    Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
----------------------------------------------------------------------------------
function c77239908.filter1(c)
    return c:IsFaceup() and c:IsAttackBelow(6000)
end
function c77239908.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239908.filter1,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(c77239908.filter,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239908.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c77239908.filter1,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
----------------------------------------------------------------------------------
function c77239908.distg(e,c)
    return c~=e:GetHandler()
end
function c77239908.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if re:GetHandler()~=e:GetHandler() then
        Duel.NegateEffect(ev)
    end
end
----------------------------------------------------------------------------------
function c77239908.filter3(c)
    return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c77239908.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsReason(REASON_REPLACE)
        and Duel.IsExistingMatchingCard(c77239908.filter3,tp,0,LOCATION_MZONE,1,nil) end
    if Duel.SelectYesNo(tp,aux.Stringid(77239908,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
        local g=Duel.SelectMatchingCard(tp,c77239908.filter3,tp,0,LOCATION_MZONE,1,1,nil)
        Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
        return true
    else return false end
end
----------------------------------------------------------------------------------
function c77239908.op(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetCondition(c77239908.con)
    e1:SetOperation(c77239908.op1)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)	
    Duel.RegisterEffect(e1,tp)
end
function c77239908.filter2(c,e,tp)
    return c:IsCode(10000020) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77239908.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c77239908.op1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c77239908.filter2,tp,LOCATION_HAND,0,nil,e,tp)
    if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c77239908.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

