--终末之机械骑士(neet)
local s,id=GetID()
function s.initial_effect(c)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY,EFFECT_FLAG2_CHECK_SIMULTANEOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,{id,0})
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.sdop)
		Duel.RegisterEffect(ge1,0)
	end
end
s.listed_series={0x10c}
s.listed_names={id}

--sp sum pro
function s.filter(c)
	return c:IsSetCard(0x10c) and c:IsType(TYPE_MONSTER) and c:IsCode(28692962,92204263,56809158,29415459,66022706,93020401,20537097)
end
function s.sdop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetOwner()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,LOCATION_HAND,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(id)==0 then
			local code=tc:GetOriginalCode()
			local effs={tc:GetCardEffect(EFFECT_SPSUMMON_PROC)}
			for _,eff in ipairs(effs) do
				if eff:GetOwner()==tc then
					eff:SetValue(s.hspval)
				end
			end
			tc:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000,0,1)
		end
		tc=g:GetNext()
	end
end
function s.cfilter(c)
	return c:GetColumnGroupCount()>0
end
function s.hspval(e,c)
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do
		zone=(zone|tc:GetColumnZone(LOCATION_MZONE,0,0,tp))
	end
	return id,zone
end


--to hand
function s.thfilter(c)
	return c:IsSetCard(0x10c) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
----sp sum self
function s.spfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL+id)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spfilter,1,nil,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL+id,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,SUMMON_TYPE_SPECIAL+id,tp,tp,false,false,POS_FACEUP)
	end
end