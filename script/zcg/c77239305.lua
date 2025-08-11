--殉道者 控水神将(ZCG)
function c77239305.initial_effect(c)
    c:EnableReviveLimit()
    --special summon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c77239305.sprcon)
    e2:SetOperation(c77239305.sprop)
    c:RegisterEffect(e2)
	
	--抗性
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetCondition(c77239305.excon)
    e3:SetValue(c77239305.efilter)
    --e3:SetOwnerPlayer(tp)
    c:RegisterEffect(e3)
    --不会被破坏
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e4:SetCondition(c77239305.excon)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e5)

    --token
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(77239305,0))
    e6:SetCategory(CATEGORY_TOKEN)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1)
    e6:SetCondition(c77239305.con)
    e6:SetTarget(c77239305.target)
    e6:SetOperation(c77239305.operation)
    c:RegisterEffect(e6)

	--奥利哈刚免疫
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE)
    e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCode(EFFECT_IMMUNE_EFFECT)
    e9:SetValue(c77239305.efilter9)
    c:RegisterEffect(e9)
    --cannot trigger
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_TRIGGER)
    e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetTargetRange(0xa,0xa)
    e11:SetTarget(c77239305.target10)
    c:RegisterEffect(e11)
    --disable
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_FIELD)
    e12:SetCode(EFFECT_DISABLE)
    e12:SetRange(LOCATION_MZONE)
    e12:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e12:SetTarget(c77239305.target10)
    c:RegisterEffect(e12)
    --disable effect
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e13:SetCode(EVENT_CHAIN_SOLVING)
    e13:SetRange(LOCATION_MZONE)
    e13:SetOperation(c77239305.disop)
    c:RegisterEffect(e13)
end
-----------------------------------------------------------------------
function c77239305.spcfilter(c)
    return c:IsSetCard(0xa60) and c:IsType(TYPE_MONSTER)
end
function c77239305.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3
        and Duel.IsExistingMatchingCard(c77239305.spcfilter,tp,LOCATION_MZONE,0,3,nil)
end
function c77239305.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c77239305.spcfilter,tp,LOCATION_MZONE,0,3,3,nil)
    Duel.Release(g,REASON_COST)
end
-----------------------------------------------------------------------
function c77239305.confilter(c)
    return c:IsFaceup() and c:IsSetCard(0xa60)
end
function c77239305.excon(e)
    return Duel.IsExistingMatchingCard(c77239305.confilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c77239305.efilter(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
-----------------------------------------------------------------------
function c77239305.con(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c77239305.filter(c)
    return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c77239305.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c77239305.filter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,60764582,0,nil,0,0,1,nil,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,c77239305.filter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,g,1,0,0)
end
function c77239305.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
        local token=Duel.CreateToken(tp,77239306)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
        local code=tc:GetOriginalCode()
        local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local att=tc:GetAttribute()
		local lv=tc:GetLevel()	
        local race=tc:GetRace()		
        token:CopyEffect(code,RESET_EVENT+0x1fe0000)
        --攻守
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetCode(EFFECT_SET_BASE_ATTACK)
        e1:SetValue(atk)
        token:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        e2:SetCode(EFFECT_SET_BASE_DEFENSE)
        e2:SetValue(def)
        token:RegisterEffect(e2)
		--属性
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e3:SetCode(EFFECT_ADD_ATTRIBUTE)
        e3:SetRange(LOCATION_MZONE)
        e3:SetValue(att)
        token:RegisterEffect(e3)
		--等级
		local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e4:SetRange(LOCATION_MZONE)
        e4:SetCode(EFFECT_CHANGE_LEVEL)
        e4:SetValue(lv)
        e4:SetReset(RESET_EVENT+0xff0000)
        token:RegisterEffect(e4)
        --种族
        local e5=Effect.CreateEffect(c)
        e5:SetType(EFFECT_TYPE_SINGLE)
        e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e5:SetCode(EFFECT_ADD_RACE)
        e5:SetRange(LOCATION_MZONE)
        e5:SetValue(race)
        token:RegisterEffect(e5)
    end
end
-----------------------------------------------------------------------
function c77239305.efilter9(e,te)
    return te:GetHandler():IsSetCard(0xa50)
end
function c77239305.target10(e,c)
    return c:IsSetCard(0xa50)
end
function c77239305.disop(e,tp,eg,ep,ev,re,r,rp)
    local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
    if tl==LOCATION_SZONE and re:GetHandler():IsSetCard(0xa50) then
        Duel.NegateEffect(ev)
    end
end