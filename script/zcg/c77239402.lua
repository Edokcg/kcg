--六芒星之龙 长翼风龙(ZCG)
function c77239402.initial_effect(c)
    --通常召唤
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77239402,0))
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c77239402.ttcon)
    e1:SetOperation(c77239402.ttop)
    --e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77239402,1))	
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e4:SetCondition(c77239402.ttcon1)
    e4:SetOperation(c77239402.ttop1)
    --e4:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e4)	
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_LIMIT_SET_PROC)
    e2:SetCondition(c77239402.setcon)
    c:RegisterEffect(e2)
    --祭品限制
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_TRIBUTE_LIMIT)
    e3:SetValue(c77239402.tlimit)
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
	e8:SetOperation(c77239402.sumsuc)
	c:RegisterEffect(e8)
	
	--破坏
    local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(77239402,2))
    e6:SetCategory(CATEGORY_DESTROY)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetCountLimit(1)	
    e6:SetCost(c77239402.cost)
    e6:SetTarget(c77239402.target1)
    e6:SetOperation(c77239402.operation1)
    c:RegisterEffect(e6)

    --奥利哈刚无效
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_FIELD)
    e10:SetCode(EFFECT_DISABLE)
    e10:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e10:SetRange(LOCATION_MZONE)	
    e10:SetTarget(c77239402.target)
    c:RegisterEffect(e10)
	
    --奥利哈刚除外
    local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(77239402,3))
	e11:SetCategory(CATEGORY_REMOVE)
	e11:SetType(EFFECT_TYPE_IGNITION)
    e11:SetRange(LOCATION_MZONE)		
    e11:SetTarget(c77239402.target2)
    e11:SetOperation(c77239402.activate2)
    c:RegisterEffect(e11)	
end
-----------------------------------------------------------------------------
function c77239402.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c77239402.otfilter(c,tp)
    return c:IsAttribute(ATTRIBUTE_WIND) and (c:IsControler(tp) or c:IsFaceup())
end
function c77239402.ttcon(e,c,minc)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c77239402.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    return minc<=1 and Duel.CheckTribute(c,2,2,mg)       
end
function c77239402.ttop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c77239402.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    local sg=Duel.SelectTribute(tp,c,2,2,mg)
    c:SetMaterial(sg)	
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end

function c77239402.otfilter1(c,tp)
    return c:IsSetCard(0xa70) and (c:IsControler(tp) or c:IsFaceup())
end
function c77239402.ttcon1(e,c,minc)
    if c==nil then return true end
	local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c77239402.otfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    return minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c77239402.ttop1(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c77239402.otfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    local sg=Duel.SelectTribute(tp,c,1,1,mg)
    c:SetMaterial(sg)	
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c77239402.setcon(e,c,minc,minc1)
    if not c then return true end
    return false
end
function c77239402.tlimit(e,c)
    return not ((c:IsSetCard(0xa70) and Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_MZONE,0,nil,0xa70)>0)
	 or (c:IsAttribute(ATTRIBUTE_WIND) and Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_MZONE,0,nil,ATTRIBUTE_WIND)>1))
end
-----------------------------------------------------------------------------
function c77239402.costfilter(c)
    return c:IsDiscardable() 
end
function c77239402.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239402.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
    local rt=Duel.GetTargetCount(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
    local cg=Duel.SelectMatchingCard(tp,c77239402.costfilter,tp,LOCATION_HAND,0,1,rt,nil)
    Duel.SendtoGrave(cg,REASON_COST+REASON_DISCARD)
    e:SetLabel(cg:GetCount())
end
function c77239402.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
    local ct=e:GetLabel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local eg=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,ct,ct,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,ct,0,0)
end
function c77239402.operation1(e,tp,eg,ep,ev,re,r,rp,chk)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
    if rg:GetCount()>0 then 
        Duel.Destroy(rg,REASON_EFFECT)
    end
end
-----------------------------------------------------------------------------
function c77239402.target(e,c)
    return c:IsSetCard(0xa50)
end
-----------------------------------------------------------------------------
function c77239402.filter1(c)
    return c:IsSetCard(0xa50) and c:IsFaceup()
end
function c77239402.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c77239402.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local sg=Duel.GetMatchingGroup(c77239402.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c77239402.activate2(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c77239402.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    local ct=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
    if ct>0 then
	    Duel.Damage(1-tp,ct*1000,REASON_EFFECT)	
    end
end
