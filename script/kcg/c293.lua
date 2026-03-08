--Legendary Knight Timaeus
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()

	-- local e00=Effect.CreateEffect(c)
	-- e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	-- e00:SetType(EFFECT_TYPE_SINGLE)
	-- e00:SetCode(EFFECT_NOT_EXTRA)
	-- e00:SetValue(1)
	-- c:RegisterEffect(e00)

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
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)

	-- local e0=Effect.CreateEffect(c)
	-- e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	-- e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	-- e0:SetCode(EVENT_ADJUST)
	-- e0:SetRange(LOCATION_MZONE)
	-- e0:SetCondition(s.adjustcon) 
	-- e0:SetOperation(s.adjustop)
	-- c:RegisterEffect(e0)
	
	--remove
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetTarget(s.rmtg)
	e0:SetOperation(s.rmop)
	c:RegisterEffect(e0)

	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetTarget(s.tar)
    e3:SetOperation(s.op2)
    e3:SetCountLimit(1)
    c:RegisterEffect(e3)

    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.applycost)
	e2:SetTarget(s.tg)
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
end

-- function s.adjustcon(e,tp,eg,ep,ev,re,r,rp)
-- 	return Duel.GetMatchingGroupCount(s.adfilter,tp,0,LOCATION_ONFIELD,nil)>0
-- end
-- function s.adfilter(c)
--     return c:IsFaceup() and c:IsSetCard(0x900) and c:IsType(TYPE_FIELD)
-- end
-- function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
-- 	local c=e:GetHandler()
-- 	local g=Duel.GetMatchingGroup(s.adfilter,tp,0,LOCATION_ONFIELD,nil)
-- 	if #g>0 then
-- 		Duel.Destroy(g,REASON_RULE+REASON_EFFECT)
-- 	end
-- end

function s.rmfilter(c)
	return c:IsSpellTrap() and c:IsFaceup()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and s.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Remove(tc,POS_FACEUP,REASON_RULE+REASON_EFFECT)
	end
end

function s.spfilter1(c,e)
	local tp=c:GetControler()
	return c:IsCode(293) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e) and c:IsFaceup()
	and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_MZONE,0,1,c,e,c)
end
function s.spfilter2(c,e,tc1)
	local tp=c:GetControler()
	return c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e) and c:IsFaceup()
	and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,tc1),TYPE_FUSION)>0
end
function s.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_MZONE,0,1,nil,e) end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e)
	if #g1<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_MZONE,0,1,99,g1:GetFirst(),e,g1:GetFirst())
	if #g2<1 then return end
	g1:Merge(g2)
	local code=296
	local g4=Duel.CreateToken(tp,code,nil,nil,nil,nil,nil,nil)
	Duel.SendtoDeck(g4,tp,0,REASON_RULE+REASON_EFFECT)
	Duel.SendtoGrave(g1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	g4:SetMaterial(g1)
	Duel.SpecialSummon(g4,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
	g4:CompleteProcedure()
end

function s.applycost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.applyfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost() and c:CheckActivateEffect(false,false,false,true)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.applyfilter),tp,LOCATION_GRAVE,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.applyfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()<1 then return end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local tc=g:GetFirst()
    Duel.ClearOperationInfo(0)
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,false,true,true)
	local ctp=te:GetHandlerPlayer()
	local cost = te:GetCost()
	local tg = te:GetTarget()
	e:SetDescription(te:GetDescription())
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	tc:CreateEffectRelation(te)
	if cost then cost(te,ctp,ceg,cep,cev,cre,cr,crp,1) end
	if tg then tg(te,ctp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	local gg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
	if gg then
		local etc = gg:GetFirst()
		while etc do
			etc:CreateEffectRelation(te)
			etc = gg:GetNext()
		end
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local te=e:GetLabelObject()
	if not te then return end
	local ctp=te:GetHandlerPlayer()
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(te,ctp,eg,ep,ev,re,r,rp) end
	local gg = Duel.GetChainInfo(0, CHAININFO_TARGET_CARDS)
	if gg then
		local etc = gg:GetFirst()
		while etc do
			etc:ReleaseEffectRelation(te)
			etc = gg:GetNext()
		end
	end
end