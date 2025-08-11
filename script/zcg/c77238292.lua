--千年首饰
function c77238292.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c77238292.target)
    e1:SetOperation(c77238292.activate)
    c:RegisterEffect(e1)
	
	--
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c77238292.desreptg)
    e2:SetOperation(c77238292.desrepop)
    c:RegisterEffect(e2)
	
    --
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(77238292,0))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c77238292.cfcon)
    e3:SetOperation(c77238292.cfop)
    c:RegisterEffect(e3)	
end
---------------------------------------------------------------------
function c77238292.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
        Duel.IsPlayerCanSpecialSummonMonster(tp,e:GetHandler():GetCode(),nil,0x11,0,0,0,0,0,POS_FACEUP) end
	e:GetHandler():SetTurnCounter(0)	
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77238292.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        or not Duel.IsPlayerCanSpecialSummonMonster(tp,e:GetHandler():GetCode(),nil,0x11,0,0,0,0,0,POS_FACEUP) then return end
    c:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPELL)
    Duel.SpecialSummon(c,1,tp,tp,true,false,POS_FACEUP)
end
-------------------------------------------------------------------
function c77238292.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReason(REASON_BATTLE) and c:IsOnField() and c:IsFaceup() end
    if c then
        return true
    else return false end	
end
function c77238292.desrepop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetTurnCounter()
    ct=ct+1
    c:SetTurnCounter(ct)
    if ct>1 then
        Duel.Destroy(c,REASON_RULE)
    end
end
---------------------------------------------------------------------
function c77238292.cfcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=10
end
function c77238292.cfop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetDecktopGroup(1-tp,10)
    if g:GetCount()~=0 then
        Duel.ConfirmCards(tp,g)
    end
end
