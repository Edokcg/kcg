--卡通欧贝利斯克之巨神兵
function c77240069.initial_effect(c)
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c77240069.spcon)
    c:RegisterEffect(e2)
	
	--
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_ONFIELD,0)
    e3:SetTarget(c77240069.filter)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e4)

	--
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CANNOT_DISEFFECT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(c77240069.chainfilter)
    c:RegisterEffect(e5)

    --direct attack
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_DIRECT_ATTACK)
    c:RegisterEffect(e6)
	
    --unaffectable
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EFFECT_IMMUNE_EFFECT)
    e7:SetValue(c77240069.efilter)
    c:RegisterEffect(e7)
	
    --destroy
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(77240069,0))
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCost(c77240069.descost)
    e7:SetTarget(c77240069.destg)
    e7:SetOperation(c77240069.desop)
    c:RegisterEffect(e7)

    --atk
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(77240069,1))
    e7:SetCategory(CATEGORY_ATKCHANGE)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCost(c77240069.descost)
    e7:SetOperation(c77240069.atkop)
    c:RegisterEffect(e7)
end
-------------------------------------------------------------------------
function c77240069.spfilter(c)
    return c:IsFaceup() and (c:IsCode(15259703) or c:IsCode(900000079) or c:IsCode(511001251))
end
function c77240069.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77240069.spfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
-------------------------------------------------------------------------
function c77240069.filter(e,c)
    return c:IsFaceup() and (c:IsCode(15259703) or c:IsCode(900000079) or c:IsCode(511001251))
end
-------------------------------------------------------------------------
function c77240069.chainfilter(e,ct)
    local p=e:GetHandlerPlayer()
    local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
    local tc=te:GetHandler()
    return p==tp and tc:IsFaceup() and (tc:IsCode(15259703) or tc:IsCode(900000079) or tc:IsCode(511001251))
end
-------------------------------------------------------------------------
function c77240069.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
-------------------------------------------------------------------------
function c77240069.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,nil,2,e:GetHandler()) end
    local g=Duel.SelectReleaseGroup(tp,nil,2,2,e:GetHandler())
    Duel.Release(g,REASON_COST)
end
function c77240069.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77240069.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,e:GetHandler())
    Duel.Destroy(g,REASON_EFFECT)
    Duel.Damage(1-tp,4000,REASON_EFFECT)
end
-------------------------------------------------------------------------
function c77240069.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if e:GetHandler():IsFaceup() then
        local e1=Effect.CreateEffect(c)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_INF_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end





