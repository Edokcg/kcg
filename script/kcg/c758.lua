--暗黑方界邪神　深藍新星三位一體 (KA)
local s,id=GetID()
function s.initial_effect(c)
	 --fusion material
	c:EnableReviveLimit()
	Fusion.AddProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0xe3),3,true)

	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetCondition(s.retcon)
	e8:SetOperation(s.tgop)
	c:RegisterEffect(e8)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15610297,0))
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCondition(s.defcon)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
 
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)

	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetOperation(s.spsop)
	c:RegisterEffect(e7)
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetOperation(s.op)
	e5:SetLabelObject(e7)
	c:RegisterEffect(e5)
end
s.material_setcode=0xe3
s.listed_series={0xe3}

function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFusionSummoned()
end
function s.filter(c)
	return c:IsSetCard(0xe3) and c:IsType(TYPE_MONSTER)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial():Filter(s.filter,nil)
	-- Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	-- local ag=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,g,nil)
	if #g>0 then
		Duel.Overlay(e:GetHandler(),g)
	end
end

function s.atkval(e)
	return e:GetHandler():GetOverlayGroup():FilterCount(Card.IsType,nil,TYPE_MONSTER)*1000
end

function s.defcon(e)
	return e:GetHandler():GetBattleTarget()
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local bc=g:GetFirst()
	for bc in aux.Next(g) do
		bc:AddCounter(0x1038,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetCondition(s.condition)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE)
		bc:RegisterEffect(e2)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_MATERIAL)
        e4:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK))
		bc:RegisterEffect(e4)
	end
end
function s.condition(e)
	return e:GetHandler():GetCounter(0x1038)>0
end

function s.destg(e,tp,eg,ev,ep,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function s.desop(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end

function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe3)
end
function s.spsop(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local mg=e:GetLabelObject()
	if not mg or mg:FilterCount(s.spfilter,nil,e,tp)<1 or Duel.GetLocationCount(tp,LOCATION_MZONE)<mg:GetCount() 
	   or (Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and mg:GetCount()>1) then return end
	Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	mg:DeleteGroup()
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	if g:GetCount()>0 then
	local mg=g:Filter(s.spfilter,nil,e,tp)
	mg:KeepAlive()
	e:GetLabelObject():SetLabelObject(mg) end
end
