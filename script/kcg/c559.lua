--奧雷卡爾克斯菲勒斯 (KA)
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x900),3,3)
	c:EnableReviveLimit() 
	--confirm hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(35699,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.atkcost)
	e1:SetTarget(s.cftg)
	e1:SetOperation(s.cfop)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1,false,EFFECT_MARKER_DETACH_XMAT)

	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetCondition(s.con)
	e6:SetTarget(s.tfilter)
	c:RegisterEffect(e6)
end
s.listed_series={0x900}
s.material_setcode={0x900}

function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.damfilter(c)
	return c:IsFaceup()
end
function s.cftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.IsExistingMatchingCard(s.damfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_HAND) 
end

function s.cfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)==0 or not Duel.IsExistingMatchingCard(s.damfilter,tp,LOCATION_MZONE,0,1,nil) then return end
		Duel.ConfirmCards(tp,g)
		local mg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
		 if mg:GetCount()>0 then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		  local mgc=mg:Select(tp,1,1,nil):GetFirst()
		  if Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,mgc,e,tp) then
			 Duel.SpecialSummonStep(mgc,0,tp,tp,false,false,POS_FACEUP)
			 --setname
			 local e1=Effect.CreateEffect(c)
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetCode(EFFECT_ADD_SETCODE)
			 e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			 e1:SetRange(LOCATION_MZONE)
			 e1:SetReset(RESET_EVENT+0x1ff0000)
			 e1:SetValue(0x900)
			 mgc:RegisterEffect(e1,true)
			 Duel.SpecialSummonComplete()
		  end
		 end
		Duel.ShuffleHand(1-tp)
end 

function s.filter(c,tc,e,tp)
	return c:GetAttack()>=tc:GetAttack() and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end

function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,1-e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,0x900)
end
function s.tfilter(e,c)
	return c:GetBaseAttack()>=c:GetAttack()
end