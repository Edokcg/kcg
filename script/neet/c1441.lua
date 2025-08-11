--魔偶甜点·巴伐露管理员
local s,id=GetID()
function s.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1441,0))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,1441)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1441,3))
	e3:SetCategory(CATEGORY_TODECK+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.retcon)
	e3:SetTarget(s.rettg)
	e3:SetOperation(s.retop)
	c:RegisterEffect(e3)
end
s.listed_series={0x71}
function s.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x71) and c:IsRace(RACE_BEAST)
end
function s.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x71) and c:IsRace(RACE_FAIRY)
end
function s.setfilter(c)
	return c:IsSetCard(0x71) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x71) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local sel=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_MZONE,0,1,nil)  
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE,0,1,nil) then sel=sel+1 end
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil)  
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1441,0))
		sel=Duel.SelectOption(tp,aux.Stringid(1441,1),aux.Stringid(1441,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(1441,1))
	else
		Duel.SelectOption(tp,aux.Stringid(1441,2))
	end
	e:SetLabel(sel)
	if sel~=1 then
		e:SetCategory(CATEGORY_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		if not Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_MZONE,0,1,nil) then return end
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.SSet(tp,tc)
		end
	else
		if not Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end

function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetHandler():GetReasonPlayer()==1-tp
		and e:GetHandler():GetPreviousControler()==tp
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end
