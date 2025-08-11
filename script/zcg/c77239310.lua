--殉道者 地狱魔神(ZCG)
function c77239310.initial_effect(c)
    c:EnableReviveLimit()

    --特殊召唤
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c77239310.sprcon)
    e2:SetOperation(c77239310.sprop)
    c:RegisterEffect(e2)
	
	--破坏
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c77239310.destg)
	e4:SetOperation(c77239310.desop)
	c:RegisterEffect(e4)
	
    --召唤不会无效
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e5)

    --不会成为效果对象
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(1)
    c:RegisterEffect(e6)

	--攻防提升
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c77239310.atkval)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c77239310.defval)
	c:RegisterEffect(e6)

    --解放提升攻防
    local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_ATKCHANGE)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c77239310.con)
    e7:SetOperation(c77239310.op)
    c:RegisterEffect(e7)
	
    --特殊召唤送墓
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e8:SetCode(EVENT_SPSUMMON_SUCCESS)
    e8:SetOperation(c77239310.retreg)
    c:RegisterEffect(e8)


	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239310.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239310.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239310.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77239310.disop)
    c:RegisterEffect(e13)
end
-----------------------------------------------------------------------------
function c77239310.spcfilter1(c)
    return (c:IsCode(10000000) or c:IsCode(513000135)) and c:IsAbleToRemoveAsCost()
end
function c77239310.spcfilter2(c)
    return (c:IsCode(10000010) or c:IsCode(513000134)) and c:IsAbleToRemoveAsCost()
end
function c77239310.spcfilter3(c)
    return (c:IsCode(10000020) or c:IsCode(513000136)) and c:IsAbleToRemoveAsCost()
end
function c77239310.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77239310.spcfilter1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c77239310.spcfilter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c77239310.spcfilter3,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
end
function c77239310.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c77239310.spcfilter1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c77239310.spcfilter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local g3=Duel.SelectMatchingCard(tp,c77239310.spcfilter3,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
    g1:Merge(g2)
    g1:Merge(g3)
    Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
-----------------------------------------------------------------------------
function c77239310.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239310.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		Duel.Damage(1-tp,og:GetCount()*1000,REASON_EFFECT)
	end
end
------------------------------------------------------------------------------
function c77239310.atkval(e,c)
	local tp=e:GetHandler():GetControler()
    local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,TYPE_MONSTER)
    local atk=g:GetSum(Card.GetAttack)
	return math.ceil(atk)	
end
function c77239310.defval(e,c)
	local tp=e:GetHandler():GetControler()
    local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,TYPE_MONSTER)
    local def=g:GetSum(Card.GetDefense)
	return math.ceil(def)
end
------------------------------------------------------------------------------
function c77239310.cfilter(c,tp)
    return c:IsReleasable()
end
function c77239310.con(e,c)
    local c=e:GetHandler()
    if c==nil then return true end
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
        and Duel.CheckReleaseGroup(c:GetControler(),c77239310.cfilter,1,e:GetHandler())
end
function c77239310.op(e,tp,eg,ep,ev,re,r,rp,c)
    local c=e:GetHandler()
    local g=Duel.SelectReleaseGroup(c:GetControler(),c77239310.cfilter,1,1,e:GetHandler())
    Duel.Release(g,REASON_COST)
    local atk=g:GetFirst():GetAttack()
    local def=g:GetFirst():GetDefense()	
    if atk>0 then 
	    local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+0xff0000)
        c:RegisterEffect(e1)
    end
    if def>0 then
	    local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        e2:SetValue(atk)
        e2:SetReset(RESET_EVENT+0xff0000)
        c:RegisterEffect(e2)	
	end	
end
------------------------------------------------------------------------------
function c77239310.retreg(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
    e1:SetCondition(c77239310.descon)	
    e1:SetTarget(c77239310.rettg)
    e1:SetOperation(c77239310.retop)
    c:RegisterEffect(e1)
end
function c77239310.descon(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function c77239310.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c77239310.retop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoGrave(c,REASON_EFFECT)
    end
end
------------------------------------------------------------------------------
function c77239310.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239310.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239310.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end

