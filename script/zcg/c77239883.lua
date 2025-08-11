--神兽王 巴巴罗斯(ZCG)
function c77239883.initial_effect(c)
    --summon & set with no tribute
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(77239883,0))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(c77239883.ntcon)
    e1:SetOperation(c77239883.ntop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_PROC)
    c:RegisterEffect(e2)
	
    --summon with 3 tribute
	local e3=aux.AddNormalSummonProcedure(c,true,true,3,3,SUMMON_TYPE_TRIBUTE+1,aux.Stringid(77239883,1))
    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetCondition(c77239883.descon)	
    e4:SetTarget(c77239883.destg)
    e4:SetOperation(c77239883.desop)
    c:RegisterEffect(e4)
	
	--
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetCode(EVENT_PHASE+PHASE_END)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetTarget(c77239883.rettg)
    e5:SetOperation(c77239883.retop)
    c:RegisterEffect(e5)
end
-------------------------------------------------------------------------------------
function c77239883.ntcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c77239883.ntop(e,tp,eg,ep,ev,re,r,rp,c)
    --change base attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetReset(RESET_EVENT+0xff0000)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetValue(6600)
    c:RegisterEffect(e1)
end
-------------------------------------------------------------------------------------
function c77239883.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_TRIBUTE+1
end
function c77239883.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239883.desop(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end

function c77239883.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
end
function c77239883.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
-------------------------------------------------------------------------------------
function c77239883.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c77239883.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end

