--卡通太阳神之翼神龙(ZCG)
function c77240070.initial_effect(c)
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
    e2:SetCondition(c77240070.spcon)
    c:RegisterEffect(e2)
	
	--
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_ONFIELD,0)
    e3:SetTarget(c77240070.filter)
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
    e5:SetValue(c77240070.chainfilter)
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
    e7:SetValue(c77240070.efilter)
    c:RegisterEffect(e7)

    --One Turn Kill
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(77240070,0))
    e8:SetCategory(CATEGORY_ATKCHANGE)
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCost(c77240070.atkcost)
    e8:SetOperation(c77240070.atkop)
    c:RegisterEffect(e8)

    --破坏
	local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(77240070,1))
	e9:SetCategory(CATEGORY_DESTROY)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCost(c77240070.cost)
	e9:SetTarget(c77240070.target)
	e9:SetOperation(c77240070.operation)
	c:RegisterEffect(e9)
end

function c77240070.spfilter(c)
    return c:IsFaceup() and (c:IsCode(15259703) or c:IsCode(900000079) or c:IsCode(511001251))
end

function c77240070.spcon(e,c)
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c77240070.spfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end

function c77240070.filter(e,c)
    return c:IsFaceup() and (c:IsCode(15259703) or c:IsCode(900000079) or c:IsCode(511001251))
end

function c77240070.chainfilter(e,ct)
    local p=e:GetHandlerPlayer()
    local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
    local tc=te:GetHandler()
    return p==tp and tc:IsFaceup() and (tc:IsCode(15259703) or tc:IsCode(900000079) or tc:IsCode(511001251))
end

function c77240070.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end

function c77240070.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLP(tp)>100 end
    local lp=Duel.GetLP(tp)
    e:SetLabel(lp-100)
    Duel.PayLPCost(tp,lp-100)
end
function c77240070.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(e:GetLabel())
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        c:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        c:RegisterEffect(e2)
    end
end

function c77240070.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c77240070.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77240070.operation(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end