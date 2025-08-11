--幻兽 巨角恐狼(neet)
local s,id=GetID()
function s.initial_effect(c)
	-- Special Summon self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)   
	--Decrease the ATK of monster your opponent controls
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
end
s.listed_series={0x1b}
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,Card.IsRace,1,false,aux.ReleaseCheckMMZ,nil,RACE_BEAST+RACE_BEASTWARRIOR) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupCost(tp,Card.IsRace,1,99,false,aux.ReleaseCheckMMZ,nil,RACE_BEAST+RACE_BEASTWARRIOR)
	Duel.Release(g,REASON_COST)
	e:SetLabel(#g)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local atk=c:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel()*500)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE&~RESET_TOFIELD)
		c:RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete()
	e:SetLabel(0)
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil,0x1b)*-100
end