--六芒星之龙 黄金地龙(ZCG)
function c77239401.initial_effect(c)
    --通常召唤
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77239401,0))
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c77239401.otcon)
    e1:SetOperation(c77239401.otop)
    --e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77239401,1))	
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e4:SetCondition(c77239401.otcon1)
    e4:SetOperation(c77239401.otop1)
    --e4:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e4)	
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_LIMIT_SET_PROC)
    e2:SetCondition(c77239401.setcon)
    c:RegisterEffect(e2)
    --祭品限制
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_TRIBUTE_LIMIT)
    e3:SetValue(c77239401.tlimit)
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
	e8:SetOperation(c77239401.sumsuc)
	c:RegisterEffect(e8)
	
    --破坏
    local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77239401,2))		
    e6:SetCategory(CATEGORY_DESTROY)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetCode(EVENT_ATTACK_ANNOUNCE)
    e6:SetRange(LOCATION_MZONE)	
    e6:SetCondition(c77239401.condition)
    e6:SetTarget(c77239401.target1)
    e6:SetOperation(c77239401.operation)
    c:RegisterEffect(e6)	

    --不会成为效果对象
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetValue(1)
    c:RegisterEffect(e7)

    --奥利哈刚无效
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetCode(EFFECT_DISABLE)
    e10:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e10:SetRange(LOCATION_MZONE)	
    e10:SetTarget(c77239401.target)
    c:RegisterEffect(e10)
	
    --奥利哈刚除外
    local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_REMOVE)
	e11:SetType(EFFECT_TYPE_IGNITION)
    e11:SetRange(LOCATION_MZONE)		
    e11:SetTarget(c77239401.target2)
    e11:SetOperation(c77239401.activate2)
    c:RegisterEffect(e11)	
end
-----------------------------------------------------------------------------
function c77239401.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c77239401.otfilter(c,tp)
    return c:IsAttribute(ATTRIBUTE_EARTH) and (c:IsControler(tp) or c:IsFaceup())
end
function c77239401.otcon(e,c,minc)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c77239401.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    return minc<=1 and Duel.CheckTribute(c,2,2,mg)       
end
function c77239401.otop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c77239401.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    local sg=Duel.SelectTribute(tp,c,2,2,mg)
    c:SetMaterial(sg)	
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end

function c77239401.otfilter1(c,tp)
    return c:IsSetCard(0xa70) and (c:IsControler(tp) or c:IsFaceup())
end
function c77239401.otcon1(e,c,minc)
    if c==nil then return true end
	local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c77239401.otfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    return minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c77239401.otop1(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c77239401.otfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    local sg=Duel.SelectTribute(tp,c,1,1,mg)
    c:SetMaterial(sg)	
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end

function c77239401.setcon(e,c,minc,minc1)
    if not c then return true end
    return false
end
function c77239401.tlimit(e,c)
    return not ((c:IsSetCard(0xa70) and Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_MZONE,0,nil,0xa70)>0)
	 or (c:IsAttribute(ATTRIBUTE_EARTH) and Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_MZONE,0,nil,ATTRIBUTE_EARTH)>1))
end
-----------------------------------------------------------------------------
function c77239401.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c77239401.filter(c)
    return c:IsDestructable()
end
function c77239401.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and c77239401.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c77239401.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c77239401.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239401.operation(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
    Duel.Destroy(sg,REASON_EFFECT)
end
-----------------------------------------------------------------------------
function c77239401.target(e,c)
    return c:IsSetCard(0xa50)
end
-----------------------------------------------------------------------------
function c77239401.filter1(c)
    return c:IsSetCard(0xa50) and c:IsFaceup()
end
function c77239401.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239401.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local sg=Duel.GetMatchingGroup(c77239401.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239401.activate2(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c77239401.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    local ct=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
    if ct>0 then
	    Duel.Damage(1-tp,ct*1000,REASON_EFFECT)	
    end
end
