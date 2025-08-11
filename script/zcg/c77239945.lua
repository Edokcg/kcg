--沉默的太阳神翼神龙LVMAX
function c77239945.initial_effect(c)
    c:EnableReviveLimit()
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(23434538,0))
    e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)	
    e0:SetType(EFFECT_TYPE_QUICK_O)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetHintTiming(0,0x1c0)
    e0:SetRange(LOCATION_HAND)
    e0:SetTarget(c77239945.tg)	
    e0:SetCondition(c77239945.spcon1)
    e0:SetOperation(c77239945.spop1)
    c:RegisterEffect(e0)		
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c77239945.spcon)
    e1:SetOperation(c77239945.spop)
    c:RegisterEffect(e1)
	
    --cannot special summon
    local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e2)

    --summon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e3)

    --immune spell
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(c77239945.efilter)
    c:RegisterEffect(e4)

    --copy
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(77239945,0))
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)	
    e5:SetTarget(c77239945.target)
    e5:SetOperation(c77239945.operation)
    c:RegisterEffect(e5)	
	
    --Indestructibility
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e7)

    --解放
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(77239945,1))
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCountLimit(1)	
    e8:SetCost(c77239945.cost)
    e8:SetOperation(c77239945.operation1)
    c:RegisterEffect(e8)
    --Revive
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e9:SetCode(EVENT_PHASE+PHASE_END)
    e9:SetRange(LOCATION_GRAVE)
    e9:SetCountLimit(1)
    e9:SetTarget(c77239945.sumtg)
    e9:SetOperation(c77239945.sumop)
    c:RegisterEffect(e9)

	--削卡组
    local e10=Effect.CreateEffect(c)
    e10:SetDescription(aux.Stringid(77239945,2))	
    e10:SetType(EFFECT_TYPE_IGNITION)	
    e10:SetRange(LOCATION_MZONE)	
    e10:SetCountLimit(1)	
    e10:SetCondition(c77239945.condition2)
    e10:SetOperation(c77239945.operation2)
    c:RegisterEffect(e10)		
end
---------------------------------------------------------------------
function c77239945.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function c77239945.spcon1(e,c)
    if c==nil then return true end
    local tp=e:GetHandler():GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetTurnPlayer()~=tp
end
function c77239945.spop1(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
    Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)
end
function c77239945.spcon(e,c)
    if c==nil then return true end
    local tp=e:GetHandler():GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c77239945.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
---------------------------------------------------------------------
function c77239945.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
---------------------------------------------------------------------
function c77239945.filter(c)
    return c:IsFaceup() and not c:IsDisabled()
end
function c77239945.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239945.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c77239945.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        local tc=g:GetFirst()
        while tc do
            local code=tc:GetOriginalCode()	
            c:CopyEffect(code,RESET_EVENT+0x1fe0000)			
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            tc:RegisterEffect(e1)
            tc=g:GetNext()
        end
    end
end
---------------------------------------------------------------------
function c77239945.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c77239945.operation1(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(77239945,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
end
function c77239945.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetFlagEffect(77239945)>0
        and c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c77239945.sumop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,true,POS_FACEUP)
		Duel.Damage(1-tp,4000,REASON_EFFECT)
    end
end
---------------------------------------------------------------------
function c77239945.condition2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>1
end
function c77239945.operation2(e,tp,eg,ep,ev,re,r,rp)
    local g2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)
    --if g2==0 or g2%2~=0 then Duel.Destroy(e:GetHandler(),REASON_RULE) return end 
    local gc=Duel.GetMatchingGroup(aux.TRUE,1-tp,LOCATION_DECK,0,nil):RandomSelect(1-tp,math.floor(g2/2))
    Duel.SendtoGrave(gc,REASON_EFFECT)
end


