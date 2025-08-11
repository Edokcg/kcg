--光之创造神-赫尔阿克帝(ZCG)
function c77239903.initial_effect(c)
    c:EnableReviveLimit()
	
    --destrroy
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    --e2:SetTarget(c77239903.destg)
    e2:SetOperation(c77239903.desop)
    c:RegisterEffect(e2)

    --lose
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetOperation(c77239903.winop)
    c:RegisterEffect(e3)	
	
    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_BATTLE_START)
    e4:SetTarget(c77239903.destg1)
    e4:SetOperation(c77239903.desop1)
    c:RegisterEffect(e4)

    --unaffectable
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetValue(c77239903.efilter)
    c:RegisterEffect(e5)	
end
----------------------------------------------------------------------------
function c77239903.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c77239903.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c77239903.filter,tp,0,LOCATION_ONFIELD,1,c) end
    local sg=Duel.GetMatchingGroup(c77239903.filter,tp,0,LOCATION_ONFIELD,c)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239903.desop(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c77239903.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
    Duel.Destroy(sg,REASON_RULE)
    Duel.SetLP(tp,1)	
end
----------------------------------------------------------------------------
function c77239903.winop(e,tp,eg,ep,ev,re,r,rp)
    local WIN_REASON_CREATORGOD=0x13
    Duel.Win(1-tp,WIN_REASON_CREATORGOD)
end
----------------------------------------------------------------------------
function c77239903.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if chk==0 then return tc and tc:IsFaceup() and tc:IsAttribute(ATTRIBUTE_DARK) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c77239903.desop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if tc:IsRelateToBattle() then Duel.Destroy(tc,REASON_EFFECT) end
end
----------------------------------------------------------------------------
function c77239903.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
