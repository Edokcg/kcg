--奥利哈刚之魂(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	  c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	 --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(98710515,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
  --special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCondition(s.spcon2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)
--code
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetCode(EFFECT_CHANGE_CODE)
	e9:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND+LOCATION_REMOVED)
	e9:SetValue(98710447)
	c:RegisterEffect(e9)
--selfdes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.sdcon2)
	e4:SetOperation(s.sdop)
	c:RegisterEffect(e4)
	--Skip Draw
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_SKIP_DP)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTargetRange(1,0)
	c:RegisterEffect(e10)
--disable
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTargetRange(0,LOCATION_MZONE)
	e11:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e11)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	e5:SetCondition(s.imcon)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
end
function s.cfilter2(c)
	return c:IsType(TYPE_MONSTER)
end
function s.imcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_DECK,0,1,nil)
end
function s.sdcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(98710515)==0
end
function s.sdop(e,tp,eg,ep,ev,re,r,rp) 
	e:GetHandler():CopyEffect(98710447,RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterFlagEffect(98710515,RESET_EVENT+0x1fe0000,0,1)
end
function s.rfilter(c,ft,tp)
	return c:IsCode(98710447)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function s.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroup(tp,s.rfilter,1,nil,ft,tp)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,s.rfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function s.cfilter(c,tp,code)
	return c:IsCode(98710447) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	if e:GetHandler():IsLocation(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED) then
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then
		c:CompleteProcedure()
	end
end