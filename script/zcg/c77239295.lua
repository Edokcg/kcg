--奥利哈刚 黑蛇魔(ZCG)
function c77239295.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c77239295.spcon)
	c:RegisterEffect(e1)

	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77239295,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c77239295.destg)
	e2:SetOperation(c77239295.desop)
	c:RegisterEffect(e2)

	--spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_LEAVE_FIELD)
    e3:SetTarget(c77239295.sptg)
    e3:SetOperation(c77239295.spop)
    c:RegisterEffect(e3)
end
-----------------------------------------------------------------------------------
function c77239295.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_SZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77239295.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_SZONE,nil)
	local g1=Duel.GetMatchingGroup(Card.IsFaceu,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)
		if g1:GetCount()>0 then
			Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
			local tc=Duel.GetFirstTarget()
			if tc:IsRelateToEffect(e) and tc:IsFaceup() then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(-ct*500)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetValue(-ct*500)
				tc:RegisterEffect(e2)
			end
		end
	end
end
-----------------------------------------------------------------------------------
function c77239295.filter(c)
	return c:IsCode(77240024)
end
function c77239295.filter1(c)
	return c:IsCode(77240076)
end
function c77239295.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(c77239295.filter,c:GetControler(),LOCATION_MZONE,0,1,nil) or Duel.IsExistingMatchingCard(c77239295.filter1,c:GetControler(),LOCATION_MZONE,0,1,nil))
end

function c77239295.filter2(c,e,tp)
    return (c:IsCode(77240024) or c:IsCode(77240076)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c77239295.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c77239295.filter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c77239295.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c77239295.filter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
    end
end