--六芒星之龙 黑海霸龙 （ZCG）
function c77240238.initial_effect(c)
	--通常召唤
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77240238,1))
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c77240238.otcon)
    e1:SetOperation(c77240238.otop)
    --e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77240238,0))
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e4:SetCondition(c77240238.otcon1)
    e4:SetOperation(c77240238.otop1)
    --e4:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e4)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_LIMIT_SET_PROC)
    e2:SetCondition(c77240238.setcon)
    c:RegisterEffect(e2)
    --祭品限制
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_TRIBUTE_LIMIT)
    e3:SetValue(c77240238.tlimit)
    c:RegisterEffect(e3)
	--cannot target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
 --summon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e7)
	--summon success
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetOperation(c77240238.sumsuc)
	c:RegisterEffect(e8)
 --ATK Up
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	--e6:SetCondition(aux.bdocon)
	e6:SetTarget(c77240238.drtg)
	e6:SetOperation(c77240238.drop)
	c:RegisterEffect(e6)
end
function c77240238.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c77240238.filter9(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e)
end
function c77240238.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 local g=Duel.GetMatchingGroup(c77240238.filter9,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil,e)
	 if chkc then return c77240238.filter9(chkc,e) end
	--if chk==0 then return g:GetClassCount(Card.GetAttribute())>=5 end
end
function c77240238.costfilter1(c,tp)
	return c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c77240238.costfilter2,tp,0,LOCATION_HAND+LOCATION_MZONE,1,c,c:GetOriginalAttribute(),tp)
end
function c77240238.costfilter2(c,att,tp)
	return c:IsType(TYPE_MONSTER) and c:GetOriginalAttribute()~=att
		and Duel.IsExistingMatchingCard(c77240238.costfilter3,tp,0,LOCATION_HAND+LOCATION_MZONE,1,c,c:GetOriginalAttribute(),tp)
end
function c77240238.costfilter3(c,att2,tp)
	return c:IsType(TYPE_MONSTER) and c:GetOriginalAttribute()~=att2 and c:GetOriginalAttribute()~=att
		and Duel.IsExistingMatchingCard(c77240238.costfilter4,tp,0,LOCATION_HAND+LOCATION_MZONE,1,c,c:GetOriginalAttribute(),tp)
end
function c77240238.costfilter4(c,att3,tp)
	return c:IsType(TYPE_MONSTER) and c:GetOriginalAttribute()~=att2 and c:GetOriginalAttribute()~=att and c:GetOriginalAttribute()~=att3
		and Duel.IsExistingMatchingCard(c77240238.costfilter5,tp,0,LOCATION_HAND+LOCATION_MZONE,1,c,c:GetOriginalAttribute(),tp)
end
function c77240238.costfilter5(c,att4,tp)
	return c:IsType(TYPE_MONSTER) and c:GetOriginalAttribute()~=att2 and c:GetOriginalAttribute()~=att and c:GetOriginalAttribute()~=att  and c:GetOriginalAttribute()~=att3 and c:GetOriginalAttribute()~=att4
		
end
function c77240238.drop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g=Duel.GetMatchingGroup(c77240238.costfilter1,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil,e)
	if g:GetCount()>=5 and Duel.SelectYesNo(tp,aux.Stringid(77240238,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,5,5,nil)
		Duel.SetTargetCard(sg)
	if sg:GetCount()>0  then
	   if Duel.Destroy(sg,REASON_EFFECT)~=0  and hg>0 then
		 Duel.BreakEffect()
		 Duel.ConfirmCards(tp,hg)
		 Duel.SendtoDeck(hg,nil,2,REASON_EFFECT)
		 Duel.ShuffleDeck(1-tp)
		 Duel.Draw(1-tp,hg:GetCount(),REASON_EFFECT)
	end
end
end
end

function c77240238.otfilter(c,tp)
    return c:IsAttribute(ATTRIBUTE_DARK) and (c:IsControler(tp) or c:IsFaceup())
end
function c77240238.otcon(e,c,minc)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c77240238.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    return minc<=1 and Duel.CheckTribute(c,2,2,mg)       
end
function c77240238.otop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c77240238.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    local sg=Duel.SelectTribute(tp,c,2,2,mg)
    c:SetMaterial(sg)	
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end

function c77240238.otfilter1(c,tp)
    return c:IsSetCard(0xa70) and (c:IsControler(tp) or c:IsFaceup())
end
function c77240238.otcon1(e,c,minc)
    if c==nil then return true end
	local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c77240238.otfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    return minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c77240238.otop1(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c77240238.otfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
    local sg=Duel.SelectTribute(tp,c,1,1,mg)
    c:SetMaterial(sg)	
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end

function c77240238.setcon(e,c,minc,minc1)
    if not c then return true end
    return false
end
function c77240238.tlimit(e,c)
    return not ((c:IsSetCard(0xa70) and Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_MZONE,0,nil,0xa70)>0)
	 or (c:IsAttribute(ATTRIBUTE_DARK) and Duel.GetMatchingGroupCount(Card.IsAttribute,c:GetControler(),LOCATION_MZONE,0,nil,ATTRIBUTE_DARK)>1))
end