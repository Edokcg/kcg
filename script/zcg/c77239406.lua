--六芒星之龙 封锁水龙(ZCG)
function c77239406.initial_effect(c)
    --通常召唤
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77239406,0))
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c77239406.ttcon)
    e1:SetOperation(c77239406.ttop)
    --e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77239406,1))	
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e4:SetCondition(c77239406.ttcon1)
    e4:SetOperation(c77239406.ttop1)
    --e4:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e4)	
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_LIMIT_SET_PROC)
    e2:SetCondition(c77239406.setcon)
    c:RegisterEffect(e2)
    --祭品限制
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_TRIBUTE_LIMIT)
    e3:SetValue(c77239406.tlimit)
    c:RegisterEffect(e3)	

    --召唤不会无效
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e5)

    --summon success
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetOperation(c77239406.sumsuc)
	c:RegisterEffect(e8)

    --不能特殊召唤
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetTargetRange(0,1)
    c:RegisterEffect(e6)
	
    --使发动无效
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_NEGATE)
    e7:SetType(EFFECT_TYPE_QUICK_F)
    e7:SetCode(EVENT_CHAINING)
    e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c77239406.codisable)
    e7:SetTarget(c77239406.tgdisable)
    e7:SetOperation(c77239406.opdisable)
    c:RegisterEffect(e7)	

    --奥利哈刚无效
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetCode(EFFECT_DISABLE)
    e10:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e10:SetRange(LOCATION_MZONE)	
    e10:SetTarget(c77239406.target)
    c:RegisterEffect(e10)
	
    --奥利哈刚除外
    local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_REMOVE)
	e11:SetType(EFFECT_TYPE_IGNITION)
    e11:SetRange(LOCATION_MZONE)		
    e11:SetTarget(c77239406.target2)
    e11:SetOperation(c77239406.activate2)
    c:RegisterEffect(e11)	
end
-----------------------------------------------------------------------------
function c77239406.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c77239406.otfilter(c,tp)
    return c:IsAttribute(ATTRIBUTE_WATER) and (c:IsControler(tp) or c:IsFaceup())
end
function c77239406.ttcon(e,c,minc)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c77239406.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    return minc<=1 and Duel.CheckTribute(c,2,2,mg)       
end
function c77239406.ttop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c77239406.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    local sg=Duel.SelectTribute(tp,c,2,2,mg)
    c:SetMaterial(sg)	
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end

function c77239406.otfilter1(c,tp)
    return c:IsSetCard(0xa70) and (c:IsControler(tp) or c:IsFaceup())
end
function c77239406.ttcon1(e,c,minc)
    if c==nil then return true end
	local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c77239406.otfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    return minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c77239406.ttop1(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c77239406.otfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    local sg=Duel.SelectTribute(tp,c,1,1,mg)
    c:SetMaterial(sg)	
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end

function c77239406.setcon(e,c,minc,minc1)
    if not c then return true end
    return false
end
function c77239406.tlimit(e,c)
    return not ((c:IsSetCard(0xa70) and Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_MZONE,0,nil,0xa70)>0)
	 or (c:IsAttribute(ATTRIBUTE_WATER) and Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_MZONE,0,nil,ATTRIBUTE_WATER)>1))
end
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
function c77239406.codisable(e,tp,eg,ep,ev,re,r,rp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and not e:GetHandler():IsStatus(STATUS_CHAINING) and ep~=tp and Duel.IsChainNegatable(ev)
end
function c77239406.tgdisable(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(77239406)==0 end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c77239406.opdisable(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsFaceup() or not c:IsRelateToEffect(e) or Duel.GetCurrentChain()~=ev+1 or c:IsStatus(STATUS_BATTLE_DESTROYED) then
        return
    end
    Duel.NegateActivation(ev)
end
-----------------------------------------------------------------------------
function c77239406.target(e,c)
    return c:IsSetCard(0xa50)
end
-----------------------------------------------------------------------------
function c77239406.filter1(c)
    return c:IsSetCard(0xa50) and c:IsFaceup()
end
function c77239406.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239406.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local sg=Duel.GetMatchingGroup(c77239406.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239406.activate2(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c77239406.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    local ct=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
    if ct>0 then
	    Duel.Damage(1-tp,ct*1000,REASON_EFFECT)	
    end
end
