--奧雷卡爾克斯聖母EX (KA)
local s, id = GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,false,false,s.ffilter,2)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)

	-- --spsummon condition
	-- local e1=Effect.CreateEffect(c)
	-- e1:SetType(EFFECT_TYPE_SINGLE)
	-- e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	-- e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	-- e1:SetValue(s.splimit)
	-- c:RegisterEffect(e1) 
	
	-- --special summon rule
	-- local e2=Effect.CreateEffect(c)
	-- e2:SetType(EFFECT_TYPE_FIELD)
	-- e2:SetCode(EFFECT_SPSUMMON_PROC)
	-- e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	-- e2:SetRange(LOCATION_EXTRA)
	-- e2:SetCondition(s.sprcon)
	-- e2:SetOperation(s.sprop)
	-- c:RegisterEffect(e2)
	
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
	
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(2407234,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e4:SetCountLimit(1)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)	

	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(31986289,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(s.sptg2)
	e5:SetOperation(s.spop2)
	c:RegisterEffect(e5)

	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SET_ATTACK_FINAL)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetCondition(s.con)
	e6:SetTarget(s.tfilter)
	e6:SetValue(s.efilter)
	c:RegisterEffect(e6)
end
s.listed_series={0x900}
s.material_setcode={0x900}

function s.ffilter(c,fc,sumtype,tp,sub,mg,sg)
	return c:IsSetCard(0x900,fc,sumtype,tp) and c:IsLevelAbove(5)
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_MATERIAL)
end
function s.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

-- function s.spfilter(c)
--  return c:IsSetCard(0x900) and c:GetLevel()>4 and c:IsCanBeFusionMaterial() 
--  and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost()) 
-- end
-- function s.spfilter1(c,tp,g,sc)
--  return g:IsExists(s.spfilter21,1,c,tp,c,sc)
-- end
-- function s.spfilter21(c,tp,tc,sc)
--  return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,tc),sc)>0
-- end
-- function s.sprcon(e,c)
--  if c==nil then return true end 
--  local tp=c:GetControler()
--  local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE,0,nil)
--  return g:IsExists(s.spfilter1,1,nil,tp,g,e:GetHandler())
-- end
-- function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
--  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
--  local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_MZONE,0,2,2,nil)
--  if #g~=2 then return end
--  local tc=g:GetFirst()
--  while tc do
--  if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
--  tc=g:GetNext()
--  end
--  Duel.SendtoDeck(g,nil,2,REASON_COST)
-- end

function s.vfilter(c)
	return c:IsSetCard(0x900) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(s.vfilter,c:GetControler(),LOCATION_MZONE,0,nil)*500
end

function s.cfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x900)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():GetFlagEffect(556)==0 end
	e:GetHandler():RegisterFlagEffect(556,RESET_EVENT+0x1ff0000,0,1)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local code=g:GetFirst():GetOriginalCode()
		e:GetHandler():CopyEffect(code, RESET_EVENT+RESETS_STANDARD_DISABLE,1)
	end
end

function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,557,0x900,0,0,2500,4,RACE_DIVINE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,557,0x900,0,0,2500,4,RACE_DIVINE,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,557)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(token)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(s.atktg) 
		e1:SetValue(aux.imval1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1)
	Duel.SpecialSummonComplete()
end
function s.atktg(e,c)
	return not (c:IsFaceup() and c:IsCode(557))
end

function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,1-e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,0x900)
end
function s.tfilter(e,c)
	return c:IsSetCard(0x900) and c:IsType(TYPE_MONSTER)
end
function s.efilter(e,c)
	return c:GetAttack()*2
end