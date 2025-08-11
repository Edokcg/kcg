--吸血鬼的呼唤者（neet）
local s,id=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)	
end
s.listed_series={0x8e}
function s.filter(c,e,tp,sel)
	if not c:IsSetCard(0x8e) or not c:IsMonster() then return false end
	return (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and sel==1) or (c:IsAbleToRemove() and Duel.IsExistingMatchingCard(s.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp,c:GetLevel()) and sel==2)
end
function s.spfilter(c,e,tp,lv)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(lv)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and (s.filter(chkc,e,tp,1) or s.filter(chkc,e,tp,2)) end
	local b1=Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,1)
	local b2=Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,2)
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	e:SetLabel(op)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,op)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_GRAVE)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local op=e:GetLabel()
	if not tc:IsRelateToEffect(e) then return end
	if op==1 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		local lv=tc:GetLevel()
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp,lv)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_RACE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(RACE_ZOMBIE)
			g:GetFirst():RegisterEffect(e2,true)  
		end
	end
end