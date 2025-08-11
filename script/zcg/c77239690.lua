--双龙聚合体(ZCG)
function c77239690.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,8,2)
	c:EnableReviveLimit()

	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c77239690.target)
	e2:SetCondition(c77239690.con)
	e2:SetOperation(c77239690.activate)
	c:RegisterEffect(e2)	
	
	--cannot announce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c77239690.antarget)
	c:RegisterEffect(e3)
	
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c77239690.reptg)
	e5:SetOperation(c77239690.repop)
	c:RegisterEffect(e5)	

	--Special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77239690,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(c77239690.cdspsum)
	e4:SetTarget(c77239690.tgspsum)
	e4:SetOperation(c77239690.opspsum)
	c:RegisterEffect(e4)	
end
--------------------------------------------------------------------------------
function c77239690.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c77239690.filter(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c77239690.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77239690.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c77239690.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c77239690.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c77239690.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	end
end
--------------------------------------------------------------------------------
function c77239690.antarget(e,c)
	return c~=e:GetHandler()
end
--------------------------------------------------------------------------------
function c77239690.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	return Duel.SelectYesNo(tp,aux.Stringid(77239690,0))
end
function c77239690.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end
--------------------------------------------------------------------------------
function c77239690.cdspsum(e)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
--[[function c77239690.tgspsum(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp) and chkc:IsRace(RACE_DRAGON) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_GRAVE,0,1,1,nil,e,0,tp,false,false,POS_FACEUP,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77239690.opspsum(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end]]

function c77239690.filter1(c,e,tp)
    return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239690.tgspsum(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c77239690.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c77239690.opspsum(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239690.filter1,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
    local tc=g:GetFirst()   
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
    end
end