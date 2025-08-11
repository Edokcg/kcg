--CNo.30
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,4,3)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetCondition(s.sumcon)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.cost)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2,false,EFFECT_MARKER_DETACH_XMAT)

	local e3=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.condition)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)

	--battle indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(s.indes)
	c:RegisterEffect(e5)
end
s.xyz_number=30
s.listed_names={81330115}
s.listed_series={0x48}
function s.indes(e,c)
	return not c:IsSetCard(0x48)
end
function s.sfilter(c)
	return c:IsCode(81330115)
end
function s.sumcon(e)
	return not Duel.IsExistingMatchingCard(s.sfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.filter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_XYZ) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp))
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil)
	and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,0,1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	local s1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local s2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and g:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif s1 then op=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif s2 then op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else return end
	if op==0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP) end
	Duel.BreakEffect()
	local ap=g:GetControler()
	if Duel.IsPlayerCanDraw(1-ap,1) then
	Duel.Draw(1-ap,1,REASON_EFFECT)
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,#sg,0,0)
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,81330115) and Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 then
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_GRAVE)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,81330115) and Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 then
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end