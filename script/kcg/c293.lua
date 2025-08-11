--Legendary Knight Timaeus
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	local e00=Effect.CreateEffect(c)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e00:SetType(EFFECT_TYPE_SINGLE)
	e00:SetCode(EFFECT_NOT_EXTRA)
	e00:SetValue(1)
	c:RegisterEffect(e00)

	local e001=Effect.CreateEffect(c)
	e001:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e001:SetType(EFFECT_TYPE_SINGLE)
	e001:SetCode(EFFECT_OVERINFINITE_ATTACK)
	c:RegisterEffect(e001)	
	local e002=Effect.CreateEffect(c)
	e002:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e002:SetType(EFFECT_TYPE_SINGLE)
	e002:SetCode(EFFECT_OVERINFINITE_DEFENSE)
	c:RegisterEffect(e002)			

	--cannot special summon
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	-- e1:SetType(EFFECT_TYPE_SINGLE)
	-- e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	-- e1:SetValue(aux.FALSE)
	-- c:RegisterEffect(e1)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(s.adjustcon) 
	e0:SetOperation(s.adjustop)
	c:RegisterEffect(e0)

    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(2978414,0))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetTarget(s.tar) 
    e2:SetOperation(s.op)
    e2:SetCountLimit(1)
    c:RegisterEffect(e2)

	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e100:SetRange(LOCATION_MZONE)
	e100:SetCode(EFFECT_CANNOT_DISABLE)
	e100:SetValue(1)
	c:RegisterEffect(e100)
	local e101=e100:Clone()
	e101:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e101)
	--特殊召唤不会被无效化
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e9)

	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80019195,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(s.settg)
	e3:SetOperation(s.setop)
	c:RegisterEffect(e3)	
end

function s.adjustcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(s.adfilter,tp,0,LOCATION_ONFIELD,nil)>0
end
function s.adfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x900) and c:IsType(TYPE_FIELD)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.adfilter,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_RULE+REASON_EFFECT)
	end
end

function s.spfilter(c,tc1)
	return c:IsAbleToRemove() and c:IsFaceup() and c~=tc1
end
function s.spfilter1(c)
	local tp=c:GetControler()
	return c:IsCode(293) and c:IsAbleToRemove() and c:IsFaceup()
	and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_MZONE,0,1,c,c)
end
function s.spfilter2(c,tc1)
	local tp=c:GetControler()
	return c:IsAbleToRemove() and c:IsFaceup()
	and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,tc1),TYPE_FUSION)>0
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return s[0]>0 and s[1]>0
end
function s.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_MZONE,0,1,nil) end
end
function s.op(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_MZONE,0,1,nil) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	if #g1<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_MZONE,0,1,99,g1:GetFirst(),g1:GetFirst())
	if #g2<1 then return end
	g1:Merge(g2)
	local code=296
	local g4=Duel.CreateToken(tp,code,nil,nil,nil,nil,nil,nil)
	Duel.SendtoDeck(g4,tp,0,REASON_RULE+REASON_EFFECT)
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	g4:SetMaterial(g1)
	Duel.SpecialSummon(g4,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
	g4:CompleteProcedure() end
end

function s.filter2(c,tcode,e,tp)
	return c:IsCode(tcode) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false)
end

function s.setfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.setfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,s.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.SSet(tp,tc)
	end
end
