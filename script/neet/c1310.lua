--魔女术组合·召唤小组(neet)
local s,id=GetID()
local Auxiliary={}
local Witchcrafter={}
function s.initial_effect(c)
	c:EnableReviveLimit()
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_SPELLCASTER),2,2,s.lcheck)
	c:SetSPSummonOnce(id)   
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(aux.WitchcrafterDiscardCost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2=Auxiliary.CreateWitchcrafterReplace2(c,id)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_DECK,0)
	e3:SetTarget(s.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
s.listed_series={0x128}
--s.listed_names={id}
function s.lcheck(g,lc,sumtype,tp)
	return g:CheckDifferentPropertyBinary(Card.GetAttribute,lc,sumtype,tp)
end
function s.eftg(e,c)
	return c:IsSpell() and c:IsSetCard(0x128)
end
function Auxiliary.CreateWitchcrafterReplace2(c,id)
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_FIELD)
	e:SetCode(EFFECT_WITCHCRAFTER_REPLACE)
	e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e:SetTargetRange(1,0)
	e:SetRange(LOCATION_DECK)
	e:SetCountLimit(1,id)
	e:SetCondition(Witchcrafter.repcon)
	e:SetValue(Witchcrafter.repval)
	e:SetOperation(Witchcrafter.repop(id))
	return e
end
function Witchcrafter.repcon(e)
	return e:GetHandler():IsAbleToGraveAsCost()
end
function Witchcrafter.repval(base,e,tp,eg,ep,ev,re,r,rp,chk,extracon)
	local c=e:GetHandler()
	return c:IsControler(tp) and c:IsMonster() and c:IsSetCard(SET_WITCHCRAFTER) and not c:IsCode(id)
end
function Witchcrafter.repop(id)
	return function(base,e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_CARD,0,id)
		Duel.SendtoGrave(base:GetHandler(),REASON_COST)
	end
end

function s.spfilter(c,e,tp)
	return c:IsSetCard(0x128) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(3312)
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e3:SetReset(RESET_EVENT|RESETS_STANDARD)
		e3:SetValue(1)
		tc:RegisterEffect(e3)
	end
	Duel.SpecialSummonComplete()
end