--凶导之白烙印(neet)
Duel.LoadScript("neet.lua")
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Special Summon this card from your hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0) 
	--lp
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.regcon)
	e1:SetOperation(s.regop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--Prevent effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(s.condition)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--Prevent destruction by effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.condition)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--Cannot be special summoned
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(s.ritlimit)
	c:RegisterEffect(e4)
end
function s.rfilter(c,e)
	return c:HasLevelRankLink() and c:IsReleasableByEffect(e) and not c:IsImmuneToEffect(e)
end
function s.rfilter2(c,e)
	return c:IsFaceup() and c:HasLevelRankLink() and c:IsReleasableByEffect(e) and c:IsSummonLocation(LOCATION_EXTRA) and not c:IsImmuneToEffect(e)
end
function s.rescon(sg,e,tp,mg,c)
	local sum=sg:GetSum(Card.GetLevelRankLink)
	return aux.ChkfMMZ(1)(sg,nil,tp) and sum==10,sum>10
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg1=Duel.GetMatchingGroup(s.rfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,c,e)
	local mg2=Duel.GetMatchingGroup(s.rfilter2,tp,0,LOCATION_MZONE,c,e)
	local mg=Group.__add(mg1,mg2)
	if chk==0 then return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) and aux.SelectUnselectGroup(mg,e,tp,1,#mg,s.rescon,0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg1=Duel.GetMatchingGroup(s.rfilter,tp,LOCATION_HAND+LOCATION_MZONE,LOCATION_MZONE,c,e)
	local mg2=Duel.GetMatchingGroup(s.rfilter2,tp,0,LOCATION_MZONE,c,e)
	local mg=Group.__add(mg1,mg2)
	if c:IsRelateToEffect(e) and aux.SelectUnselectGroup(mg,e,tp,1,#mg,s.rescon,0) then
		local rg=aux.SelectUnselectGroup(mg,e,tp,1,#mg,s.rescon,1,tp,HINTMSG_RELEASE,s.rescon,nil,false)
		if rg:IsExists(Card.IsControler,2,nil,1-tp) then e:SetLabel(1) end
		if Duel.Release(rg,REASON_EFFECT)~=0 and Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)~=0 then
			c:SetMaterial(nil)
			c:CompleteProcedure()
		end
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	return c:IsSummonType(SUMMON_TYPE_RITUAL) and e:GetLabelObject():GetLabel()==1
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)//2)
end
function s.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x146) or c:IsSetCard(0x166))
end
function s.condition(e)
	return Duel.IsExistingMatchingCard(s.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function s.ritlimit(e,se,sp,st)
	if (st&SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL then
		return se:GetHandler():IsSetCard(SET_DOGMATIKA)
	end
	return true
end